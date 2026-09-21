class Zlib < Formula
  desc "Search and download books from Z-Library and Anna's Archive"
  homepage "https://github.com/difyz9/zlib-go"
  version "0.1.4"

  on_macos do
    on_arm do
      url "https://github.com/difyz9/zlib-go/releases/download/v0.1.4/zlib-v0.1.4-darwin-arm64.tar.gz"
      sha256 "c8827227999c36ab184a4b2926d8b73205b64f2f0e68ae26f863563993364653"
    end

    on_intel do
      url "https://github.com/difyz9/zlib-go/releases/download/v0.1.4/zlib-v0.1.4-darwin-amd64.tar.gz"
      sha256 "c1aa42fd9c8e7396834ef7747e65b70d841e702dbe5a25d281565cecd065807b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/difyz9/zlib-go/releases/download/v0.1.4/zlib-v0.1.4-linux-arm64.tar.gz"
      sha256 "cc4bce6d5f7b9853680a6d13d75c05976b71a1caf9f7ae915ef1be166e05e471"
    end

    on_intel do
      url "https://github.com/difyz9/zlib-go/releases/download/v0.1.4/zlib-v0.1.4-linux-amd64.tar.gz"
      sha256 "cd8efe70cc321f6524606508b6e87e6c31311b0726a0d59d025f56cc1104f92f"
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
