class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "https://www.openexr.com/"
  url "https://download.savannah.nongnu.org/releases/openexr/ilmbase-2.2.1.tar.gz"
  sha256 "cac206e63be68136ef556c2b555df659f45098c159ce24804e9d5e9e0286609e"

  bottle do
    cellar :any
    sha256 "5621509767a95332eff8e26f7fe80c6bce9c3c271fa8521e234263b3c3d67454" => :high_sierra
    sha256 "7b40da5907be805067a7af87b5a5af2dac9e446478de06316a059fa9c4f9a9c0" => :sierra
    sha256 "402fe7453b9ca2c4c4a3fbdb9557156819e26c959e18c096dcceab8b1b6ce9a5" => :el_capitan
    sha256 "d2e681058d004b7d1df74154cd405e851ec935c82443cdffd29b32877a101f4f" => :x86_64_linux
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install %w[Half HalfTest Iex IexMath IexTest IlmThread Imath ImathTest]
  end

  test do
    cd pkgshare/"IexTest" do
      system ENV.cxx, "-I#{include}/OpenEXR", "-I./", "-c",
             "testBaseExc.cpp", "-o", testpath/"test"
    end
  end
end
