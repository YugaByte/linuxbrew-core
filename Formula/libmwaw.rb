class Libmwaw < Formula
  desc "Library for converting legacy Mac document formats"
  homepage "https://sourceforge.net/p/libmwaw/wiki/Home/"
  url "https://downloads.sourceforge.net/project/libmwaw/libmwaw/libmwaw-0.3.14/libmwaw-0.3.14.tar.xz"
  sha256 "aca8bf1ce55ed83adbea82c70d4c8bebe8139f334b3481bf5a6e407f91f33ce9"

  bottle do
    cellar :any
    sha256 "560cf0431ce0404f25c2f5cc35be0f075419342ee31002bd0cdbc8deaedab4f0" => :high_sierra
    sha256 "5a99c929ca6737472d990294729e666eb1e8a1ba98f95d8c7aa667f7d07a3ade" => :sierra
    sha256 "ce9e272ecd44be8276faa76ea9084f34e22082074b85a929cc2fcd64ac87e5c2" => :el_capitan
    sha256 "ddb30af10b7767e8bd452f04e58273f6b653ceb570e8816fd351c44f1aaacf1a" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "librevenge"

  resource "test_document" do
    url "https://github.com/openpreserve/format-corpus/raw/825c8a5af012a93cf7aac408b0396e03a4575850/office-examples/Old%20Word%20file/NEWSSLID.DOC"
    sha256 "df0af8f2ae441f93eb6552ed2c6da0b1971a0d82995e224b7663b4e64e163d2b"
  end

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j4" if ENV["CIRCLECI"]

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testpath.install resource("test_document")
    # Test ID on an actual office document
    assert_equal shell_output("#{bin}/mwawFile #{testpath}/NEWSSLID.DOC").chomp,
                 "#{testpath}/NEWSSLID.DOC:Microsoft Word 2.0[pc]"
    # Control case; non-document format should return an empty string
    assert_equal shell_output("#{bin}/mwawFile #{test_fixtures("test.mp3")}").chomp,
                 ""
  end
end
