require 'formula'

class Rivet < Formula
  homepage 'http://rivet.hepforge.org/'
  url 'http://www.hepforge.org/archive/rivet/Rivet-2.0.0.tar.gz'
  sha1 '92ead69e98463254a4d035c0db38a5e488b63798'

  head do
    url 'http://rivet.hepforge.org/hg/rivet', :using => :hg, :branch => 'tip'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
    depends_on 'cython' => :python
  end

  depends_on 'hepmc'
  depends_on 'fastjet'
  depends_on 'gsl'
  depends_on 'boost'
  depends_on 'yoda'
  depends_on 'yaml-cpp'
  depends_on :python
  option 'with-check', 'Test during installation'

  def patches
    # Fix compilation bug, correct rivet-config for Mac
    DATA
  end unless build.head?

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? 'check'
    system "make", "install"

    prefix.install 'test'
    bash_completion.install share/'Rivet/rivet-completion'
  end

  test do
    system "cat #{prefix}/test/testApi.hepmc | rivet -a D0_2008_S7554427"
    ohai "Successfully ran dummy HepMC file through Drell-Yan analysis"
  end
end

__END__
diff --git a/bin/rivet-config.in b/bin/rivet-config.in
index 5108b36..2cc4fcf 100644
--- a/bin/rivet-config.in
+++ b/bin/rivet-config.in
@@ -71,7 +71,7 @@ fi
 
 tmp=$( echo "$*" | egrep -- '--\<ldflags\>')
 if test -n "$tmp"; then
-    OUT="$OUT -Wl,--no-as-needed"
+    OUT="$OUT"
     lrivet="@libdir@"
     test -n "$lrivet" && OUT="$OUT -L${lrivet}"
     lhepmc="@HEPMCLIBPATH@"
diff --git a/include/Rivet/ProjectionHandler.hh b/include/Rivet/ProjectionHandler.hh
index 2483a9a..7d42d60 100644
--- a/include/Rivet/ProjectionHandler.hh
+++ b/include/Rivet/ProjectionHandler.hh
@@ -49,7 +49,7 @@ namespace Rivet {
 
     /// @brief Typedef for the structure used to contain named projections for a
     /// particular containing Analysis or Projection.
-    typedef map<const string, ProjHandle> NamedProjs;
+    typedef map<string, ProjHandle> NamedProjs;
 
     /// Enum to specify depth of projection search.
     enum ProjDepth { SHALLOW, DEEP };
