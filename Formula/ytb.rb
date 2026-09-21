class Ytb < Formula
  desc "YouTube to Bilibili video republishing pipeline CLI"
  homepage "https://github.com/difyz9/ytb2bili-cli"
  version "0.3.4"

  on_macos do
    on_arm do
      url "https://github.com/difyz9/ytb2bili-cli/releases/download/v0.3.4/ytb_0.3.4_darwin_arm64.tar.gz"
      sha256 "7be70175b4bf29d27e5bcb3e2b9576aa63c34f5109714c4a7de062ba79193146"
    end

    on_intel do
      url "https://github.com/difyz9/ytb2bili-cli/releases/download/v0.3.4/ytb_0.3.4_darwin_amd64.tar.gz"
      sha256 "8b1c6feb61b340ea75d7c860ed301b7e1fa92d610fba287fbc5319f41f13295b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/difyz9/ytb2bili-cli/releases/download/v0.3.4/ytb_0.3.4_linux_arm64.tar.gz"
      sha256 "ee291388a7c86b6b5ade3085c191bd5048f477a8ac049fd2b734d16d31f1fdb1"
    end

    on_intel do
      url "https://github.com/difyz9/ytb2bili-cli/releases/download/v0.3.4/ytb_0.3.4_linux_amd64.tar.gz"
      sha256 "0971ffdc95b2971f8936daaffe38129000ecdd66c7c9ec8a03a632c5c2bc0882"
    end
  end

  def install
    bin.install "ytb"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ytb --version")
  end
end
