# homebrew-tap

个人 Homebrew tap，为多个项目提供 `brew install` 安装支持，并通过 GitHub Actions 每天自动监控上游 release，保持 formula 始终指向最新版本。

## 安装

## Linux 安装brew

```
# 安装linuxbrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

```

安装完成后，按提示把环境变量写入 shell（debian 默认 bash）：

```
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
source ~/.bashrc
```


```bash
brew tap difyz9/homebrew-tap https://github.com/difyz9/homebrew-tap
```

## 可安装的项目

```bash
brew install zlib   # Z-Library / Anna's Archive 搜索下载工具 (zlib-go)
brew install ytb    # YouTube → Bilibili 搬运 CLI (ytb2bili-cli)
```

formula 自动更新后，用户执行 `brew upgrade` 即可拿到最新包，无需任何额外操作。

## 自动更新机制

每天北京时间 16:00（UTC 08:00），GitHub Actions 会：

1. 读取 `.github/upstream.json`，逐个查询上游仓库的最新 release tag
2. 与 `Formula/<名字>.rb` 中声明的版本比较，有新版才处理
3. 从旧 URL 自动推导新 URL（直接替换版本号，兼容 `zlib-v0.1.4-darwin-arm64` 和 `ytb_0.3.4_darwin_arm64` 等命名风格），下载各平台包计算 sha256
4. 改写 formula 的 `version` / `url` / `sha256`，提交并推送

也支持在仓库的 Actions 页面手动触发（workflow_dispatch）。单个项目更新失败（如上游缺少某平台资产）不影响其他项目。

## 添加新项目

三步：

**1. 创建 `Formula/<名字>.rb`**，照抄现有模板（如 `zlib.rb`），修改 `desc`、`homepage`、`version`，以及四个平台的 `url` 和 `sha256`。

**2. 在 `.github/upstream.json` 注册：**

```json
{
  "zlib": { "upstream": "difyz9/zlib-go" },
  "ytb":  { "upstream": "difyz9/ytb2bili-cli" },
  "foo":  { "upstream": "difyz9/foo" }
}
```

**3. 提交推送。** 之后每日任务会自动把新项目纳入监控。

## 约定

- formula 文件名、`upstream.json` 的 key、formula 类名需保持一致（`foo` → `Formula/foo.rb` → `class Foo < Formula`）
- formula 中 `version` / `url` / `sha256` 保持标准写法，脚本才能可靠解析和改写
- 下载地址可以指向上游仓库或本 tap 的 releases，更新时会自动把下载仓库改写为上游仓库
- 上游 release 需包含 darwin-amd64 / darwin-arm64 / linux-amd64 / linux-arm64 四个平台的压缩包

## 注意事项

- 仓库超过 60 天无活动时 GitHub 会暂停 Actions 定时任务，需到 Actions 页面手动 re-enable（有自动更新推送的仓库不受影响）
