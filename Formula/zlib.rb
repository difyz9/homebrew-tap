class Zlib < Formula
  desc "Search and download books from Z-Library and Anna's Archive"
  homepage "https://github.com/difyz9/zlib-go"
  version "0.1.3"

  on_macos do
    on_arm do
      url "https://github.com/difyz9/zlib-go/releases/download/v0.1.3/zlib-v0.1.3-darwin-arm64.tar.gz"
      sha256 "336bb151970a53aff578f89af14128410fbfe9f8d6034e6956bbbdb3e7b80c1d"
    end

    on_intel do
      url "https://github.com/difyz9/zlib-go/releases/download/v0.1.3/zlib-v0.1.3-darwin-amd64.tar.gz"
      sha256 "fc54660c110ff71b668b1dda74c07f841b3a0e9a1c4d4a7825ba88e511b467bf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/difyz9/zlib-go/releases/download/v0.1.3/zlib-v0.1.3-linux-arm64.tar.gz"
      sha256 "7c474ee2fcc3ace966c6431392ffc7c0f5d8438c797014f09a395fe58c6bd203"
    end

    on_intel do
      url "https://github.com/difyz9/zlib-go/releases/download/v0.1.3/zlib-v0.1.3-linux-amd64.tar.gz"
      sha256 "cbcd4dfea34e2a40d304f9a748727ddb853cb69885821ba6b2addf02caa2a387"
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
