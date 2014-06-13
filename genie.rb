require "formula"
class Genie < Formula
  homepage "http://genie.hepforge.org"

  # Version 2.6.8
  # url "https://www.hepforge.org/archive/genie/Genie-2.6.8.tar.gz"
  # sha1 "0bb76cc04430aaffdf815ab0aaf44e6566b0f2fe"

  # Version 2.8.0
  url "http://www.hepforge.org/archive/genie/Genie-2.8.0.tar.gz"
  sha1 "05dc62cd001f380121aa0b206e09a6dd8a493216"


  depends_on "cmake" => :build
  depends_on "homebrew/science/root"
  depends_on "davidchall/hep/pythia8"
  depends_on "davidchall/hep/lhapdf"
  depends_on "log4cpp"
  depends_on "libxml2"

  def install
    ENV['ROOTSYS'] = Formula["root"].prefix
    ENV.deparallelize

    temp_path_for_the_installation = `pwd`.gsub("\n", "")
    ENV['GENIE'] = temp_path_for_the_installation

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-pythia6-lib=#{Formula['pythia8'].lib}"
                          
    # The g++ parameter `-ffriend-injection` is not recognized on Max OS X 10.9 Mavericks.
    inreplace "src/make/Make.include", "-ffriend-injection", ""
    
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/genie-config"
  end
end
