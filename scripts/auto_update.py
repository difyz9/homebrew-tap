#!/usr/bin/env python3
"""Check upstream repos for new releases and update Homebrew formulae.

For each entry in .github/upstream.json (formula name -> upstream repo):
  1. Query the GitHub API for the latest release tag.
  2. Compare with the version currently in Formula/<name>.rb.
  3. If newer, download every platform asset (deriving new URLs from the old
     ones by substituting the version string), compute sha256 checksums,
     rewrite the formula, and stage a commit.

Asset naming is auto-detected: the old version number is simply replaced by
the new one inside each URL, so per-formula templates are not needed.
"""

import json
import os
import re
import subprocess
import sys
import urllib.request
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
FORMULA_DIR = REPO_ROOT / "Formula"
CONFIG_PATH = REPO_ROOT / ".github" / "upstream.json"

PLATFORM_ORDER = ["darwin-arm64", "darwin-amd64", "linux-arm64", "linux-amd64"]


def http_get_json(url: str) -> dict:
    req = urllib.request.Request(url, headers={
        "Accept": "application/vnd.github+json",
        "User-Agent": "homebrew-tap-auto-update",
    })
    token = os.environ.get("GITHUB_TOKEN")
    if token:
        req.add_header("Authorization", f"Bearer {token}")
    with urllib.request.urlopen(req) as resp:
        return json.loads(resp.read().decode())


def http_download(url: str) -> bytes:
    req = urllib.request.Request(url, headers={"User-Agent": "homebrew-tap-auto-update"})
    with urllib.request.urlopen(req) as resp:
        return resp.read()


def normalize_version(tag: str) -> str:
    return tag.lstrip("vV")


def version_tuple(v: str):
    parts = []
    for p in re.split(r"[.\-+]", v):
        parts.append(int(p) if p.isdigit() else 0)
    return tuple(parts)


def run_git(*args: str) -> str:
    result = subprocess.run(
        ["git", "-C", str(REPO_ROOT), *args],
        capture_output=True, text=True,
    )
    if result.returncode != 0:
        raise RuntimeError(f"git {' '.join(args)} failed: {result.stderr.strip()}")
    return result.stdout.strip()


def update_formula(name: str, upstream: str) -> str | None:
    """Update Formula/<name>.rb to the latest upstream release.

    Returns a summary string if an update was made, None if already current.
    Raises on errors (network, missing asset, etc.).
    """
    formula_path = FORMULA_DIR / f"{name}.rb"
    content = formula_path.read_text()

    # Current version declared in the formula.
    m = re.search(r'^\s*version\s+"([^"]+)"', content, re.MULTILINE)
    if not m:
        raise RuntimeError(f'no version line found in {formula_path}')
    current_version = m.group(1)

    # Latest release from upstream.
    release = http_get_json(f"https://api.github.com/repos/{upstream}/releases/latest")
    tag = release.get("tag_name") or ""
    if not tag:
        raise RuntimeError(f"upstream {upstream} has no latest release")
    new_version = normalize_version(tag)

    if version_tuple(new_version) <= version_tuple(current_version):
        return None

    # Collect (old_url, old_sha) pairs in file order.
    pairs = re.findall(
        r'url\s+"([^"]+)"\s*\n\s*sha256\s+"([0-9a-f]{64})"', content
    )
    if not pairs:
        raise RuntimeError(f"no url/sha256 pairs found in {formula_path}")

    new_content = content
    for old_url, old_sha in pairs:
        new_url = old_url
        # Replace every occurrence of the old version string (with or
        # without a leading v) by the new one, in both tag and asset name.
        for old_tok in {f"v{current_version}", current_version}:
            new_url = new_url.replace(
                old_tok,
                "v" + new_version if old_tok.startswith("v") else new_version,
            )
        if new_url == old_url:
            raise RuntimeError(
                f"could not derive new URL from {old_url} "
                f"(version {current_version} not found in URL)"
            )
        # Assets for the new release are published on the upstream repo;
        # redirect the download host away from this tap if it was used before.
        new_url = re.sub(
            r"github\.com/[^/]+/[^/]+/releases/download",
            f"github.com/{upstream}/releases/download",
            new_url,
        )
        print(f"  downloading {new_url}")
        data = http_download(new_url)  # raises on 404 / missing asset
        import hashlib
        new_sha = hashlib.sha256(data).hexdigest()
        new_content = new_content.replace(f'url "{old_url}"', f'url "{new_url}"')
        new_content = new_content.replace(f'sha256 "{old_sha}"', f'sha256 "{new_sha}"')

    new_content = re.sub(
        r'^(\s*)version\s+"[^"]+"',
        r'\1version "' + new_version + '"',
        new_content,
        count=1,
        flags=re.MULTILINE,
    )
    formula_path.write_text(new_content)

    run_git("add", str(formula_path))
    run_git(
        "-c", "user.name=github-actions[bot]",
        "-c", "user.email=41898282+github-actions[bot]@users.noreply.github.com",
        "commit", "-m", f"{name} {new_version} (auto-update from {upstream})",
    )
    return f"{name} {current_version} -> {new_version}"


def main() -> int:
    config = json.loads(CONFIG_PATH.read_text())
    updated, errors = [], []

    for name, cfg in config.items():
        upstream = cfg.get("upstream") if isinstance(cfg, dict) else cfg
        print(f"== {name} (upstream: {upstream})")
        try:
            result = update_formula(name, upstream)
        except Exception as exc:
            errors.append(f"{name}: {exc}")
            print(f"   ERROR: {exc}")
            continue
        if result:
            updated.append(result)
            print(f"   updated: {result}")
        else:
            print("   already up to date")

    if updated:
        print(f"\npushing {len(updated)} update(s): {', '.join(updated)}")
        run_git("push")

    if errors:
        print("\nfailures:", file=sys.stderr)
        for err in errors:
            print(f"  - {err}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
