class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagucloud/dagu/archive/refs/tags/v2.16.5.tar.gz"
  sha256 "1cdf72d5aa16fe32a891636c829acbef4507134f43400a1c413c193b41a0ffd9"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f10455d1145a0a1af6bd6cd82085c4e33f3304c5d3c9550b5e66ee0c1e0e4411"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "abb0d4420c4695ffc76e6c819dd7604d4a6b6af65c10408f5b5ce0cffb320eb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c97eeed6b1798f5d77f651d56e41344ea6a782e5090ec552d8893e8be404a349"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5526d03a92be4012b73d4a661de4fe0d91420bd088fbbdb5ec24cf394b540d20"
    sha256 cellar: :any,                 x86_64_linux:      "b27235fd0cb7d2189a7bf053f16d0643a0bde5f5b669aac695ec98f00466c5e0"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "ui", "install", "--frozen-lockfile", "--ignore-scripts"
    system "pnpm", "with", "current", "--dir", "ui", "run", "build"
    (buildpath/"internal/service/frontend/assets").install (buildpath/"ui/dist").children

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd"
    generate_completions_from_executable(bin/"dagu", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"dagu", "start-all"]
    keep_alive true
    error_log_path var/"log/dagu.log"
    log_path var/"log/dagu.log"
    working_dir var
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dagu version 2>&1")

    (testpath/"hello.yaml").write <<~YAML
      steps:
        - name: hello
          command: echo "Hello from Dagu!"

        - name: world
          command: echo "Running step 2"
    YAML

    system bin/"dagu", "start", "hello.yaml"
    shell_output = shell_output("#{bin}/dagu status hello.yaml")
    assert_match "Result: Succeeded", shell_output
  end
end
