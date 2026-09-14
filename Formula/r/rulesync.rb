class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.30.1.tgz"
  sha256 "94eae5f3f8e4ccb64782665805fc4b2f35ce7c03fc70af5700111393946d08ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2796d750e4a2a96c5e5116bac2ccdc4c5de099222282c513f3f23b695f3a59ad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2796d750e4a2a96c5e5116bac2ccdc4c5de099222282c513f3f23b695f3a59ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2796d750e4a2a96c5e5116bac2ccdc4c5de099222282c513f3f23b695f3a59ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c122e3bd8c7a659a877d0cb29ecb414a03681c0770bba63c028c40d84e026044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c122e3bd8c7a659a877d0cb29ecb414a03681c0770bba63c028c40d84e026044"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
