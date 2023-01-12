# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class VaultCgo < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://github.com/individuwill/homebrew-tap"
  # TODO: Migrate to `python@3.11` in v1.13
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.12.2",
      revision: "415e1fe3118eebd5df6cb60d13defdc01aa17b03"
  license "MPL-2.0"
  head "https://github.com/individuwill/homebrew-tap.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  def pour_bottle?
    false
  end

  depends_on "go" => :build
  depends_on "gox" => :build
  depends_on "node@18" => :build
  depends_on "python@3.10" => :build # TODO: Migrate to `python@3.11` in v1.13
  depends_on "yarn" => :build

  conflicts_with "vault"
  conflicts_with "hashicorp/tap/vault"

  option "netcgo", "Use native C DNS resolution"

  def install
    # Needs both `npm` and `python` in PATH
    ENV.prepend_path "PATH", Formula["node@18"].opt_libexec/"bin"
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin" if OS.mac?
    ENV.prepend_path "PATH", "#{ENV["GOPATH"]}/bin"
    
    params = ["bootstrap", "static-dist", "dev-ui"]

    if build.with? "netcgo"
      ENV["CGO_ENABLED"] = "1"
      params = ["BUILD_TAGS=netcgo", "GO_TAGS=netcgo"] + params
    end
    
    system "make", *params
    bin.install "bin/vault"
  end

  service do
    run [opt_bin/"vault", "server", "-dev"]
    keep_alive true
    working_dir var
    log_path var/"log/vault.log"
    error_log_path var/"log/vault.log"
  end

  test do
    port = free_port
    ENV["VAULT_DEV_LISTEN_ADDRESS"] = "127.0.0.1:#{port}"
    ENV["VAULT_ADDR"] = "http://127.0.0.1:#{port}"

    pid = fork { exec bin/"vault", "server", "-dev" }
    sleep 5
    system bin/"vault", "status"
    Process.kill("TERM", pid)
  end
end
