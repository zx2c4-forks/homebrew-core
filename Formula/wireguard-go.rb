class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20180514.tar.xz"
  sha256 "3ff1d2d72026da986cf93ac3a32602f4d175735ba5dc2962cd303275de8dff6e"
  head "https://git.zx2c4.com/wireguard-go", :using => :git

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/wireguard-go").install buildpath.children
    cd "src/wireguard-go" do
      system "dep", "ensure", "-vendor-only"
      (buildpath/"gopath/src").install (buildpath/"src/wireguard-go/vendor").children
      ENV["GOPATH"] = buildpath/"gopath"
      system "make", "PREFIX=#{prefix}", "install"
    end
  end

  test do
    assert_match "be utun", pipe_output("WG_PROCESS_FOREGROUND=1 #{bin}/wireguard-go notrealutun")
  end
end
