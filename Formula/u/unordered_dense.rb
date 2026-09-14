class UnorderedDense < Formula
  desc "Hashmap and hashset based on robin-hood backward shift deletion"
  homepage "https://github.com/martinus/unordered_dense"
  url "https://github.com/martinus/unordered_dense/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "0145e2a418fbb507b6a33f7d5b118430b044d2d04a0bd3ff9eee9471ae2213a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5a7d8c1fad0fbb175422976870a9639160c9e291f3f30afed2012142777c776c"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "example"
  end

  test do
    cp pkgshare/"example/main.cpp", testpath
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test"
    system "./test"
  end
end
