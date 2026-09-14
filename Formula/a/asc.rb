class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.3.1.tar.gz"
  sha256 "bc152d71dd0d3edeab356d025552b5d76ff06a870848759c9d039b66725f4ef9"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eacb690f105b81247568baea2de1028fb346861f4e8d88d3ef5ece401ae49046"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4cf9b234c663370af5d6f8bca96ab4ced078c54e07e0849109112784c8e80bef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0456c38b47c1fe38e7d364228b29a6f14913990cfd1ef51ab1a8f4729e500917"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2717947a7ee39aa448030b4f0a9471a79d94b21eb7ee8973872a1a6ed3e27092"
    sha256 cellar: :any,                 x86_64_linux:      "144ca75c3cc6ba9cb43127332913323edb8c4c60840f2e5b686705600f97ff5b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
