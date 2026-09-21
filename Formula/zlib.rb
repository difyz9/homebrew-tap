class Zlib < Formula
  desc "Search and download books from Z-Library and Anna's Archive"
  homepage "https://github.com/difyz9/zlib-go"
  version "0.1.5"

  on_macos do
    on_arm do
      url "https://github.com/difyz9/zlib-go/releases/download/v0.1.5/zlib-v0.1.5-darwin-arm64.tar.gz"
      sha256 "4d9db7e1ee5c70c8d4e04c9fe9b8576f1c1dff9b7ba7939ec1de29c2b61d75d5"
    end

    on_intel do
      url "https://github.com/difyz9/zlib-go/releases/download/v0.1.5/zlib-v0.1.5-darwin-amd64.tar.gz"
      sha256 "f82d5edf807c8f1f168ea6735e8b95a3d6b3227a0c3867aaf7b1bdb1d7b1cb19"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/difyz9/zlib-go/releases/download/v0.1.5/zlib-v0.1.5-linux-arm64.tar.gz"
      sha256 "270bfda05b586824647c360e72f132e43b40743be661eb08f43e9c02f2cb4d0a"
    end

    on_intel do
      url "https://github.com/difyz9/zlib-go/releases/download/v0.1.5/zlib-v0.1.5-linux-amd64.tar.gz"
      sha256 "15add32ab64b582f1d2e86fd97231d6195fe4804dfaf88387c282e65cd42ccd1"
    end
  end

  def install
    # Release archives name the binary with the version suffix (e.g.
    # zlib-v0.1.3-darwin-arm64); strip it back to plain "zlib" on install.
    bin.install Dir["zlib-*"].first => "zlib"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zlib version")
  end
end
