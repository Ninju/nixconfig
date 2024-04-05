{ buildPythonPackage, src }:
buildPythonPackage {
  pname = "i3-layouts";
  version = "github-f74f1922052239851d502235fc09cefdd632a73e";

  inherit src;
}
