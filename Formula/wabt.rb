class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt/archive/1.0.1.tar.gz"
  sha256 "720a1e68eddbacc2106d4db8056460488c96a7ff1bf0f5ec8dd8424f7a457ce4"

  bottle do
    cellar :any_skip_relocation
    sha256 "456ff14ecd21adbe9c8c5947f984940bdf87a3a0707ca88264eec5a92570352e" => :high_sierra
    sha256 "e0f6b5920135fadb829643738d1364a2eb2c13681832e2c63abb36e2eabb6c5a" => :sierra
    sha256 "4a7ceb54efc5c65127dc488d5251c02b528ed6e88a395e72699c5e0aa952aca8" => :el_capitan
    sha256 "193b2840240d259a10631903b0987b67ce1810fa2a8901523e14c1bb1c32afed" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "python@2" => :build unless OS.mac?

  def install
    # Reduce memory usage for CircleCI.
    ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]

    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTS=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"sample.wast").write("(module (memory 1) (func))")
    system "#{bin}/wat2wasm", testpath/"sample.wast"
  end
end
