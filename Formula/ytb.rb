class Ytb < Formula
  desc "YouTube to Bilibili video republishing pipeline CLI"
  homepage "https://github.com/difyz9/ytb2bili-cli"
  version "0.3.3"

  on_macos do
    on_arm do
      url "https://github.com/difyz9/homebrew-tap/releases/download/v0.3.3/ytb_0.3.3_darwin_arm64.tar.gz"
      sha256 "f0dc4446d9e566ab14611ad66db901f281127550ce8ccfaeadba160d5c9e5379"
    end

    on_intel do
      url "https://github.com/difyz9/homebrew-tap/releases/download/v0.3.3/ytb_0.3.3_darwin_amd64.tar.gz"
      sha256 "47134fd21121d99a0a21a93d822f6b545357db25e41ee23fc79000b9945d6a50"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/difyz9/homebrew-tap/releases/download/v0.3.3/ytb_0.3.3_linux_arm64.tar.gz"
      sha256 "924a719b42646d4a6a3239f81d0f06d028c6dac0db4c36cae01357410daceb87"
    end

    on_intel do
      url "https://github.com/difyz9/homebrew-tap/releases/download/v0.3.3/ytb_0.3.3_linux_amd64.tar.gz"
      sha256 "67c9e3dfa495650f3b4bb4a60fee7db2e11120d241c435a61f4d85547b77f1cf"
    end
  end

  def install
    bin.install "ytb"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ytb --version")
  end
end
