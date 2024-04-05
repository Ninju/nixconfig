{
  mkDerivation
, buildPythonPackage
, rofi
, coreutils
, gnugrep
, gnused
, makeBinPath
, makeWrapper
, src
}:

mkDerivation {
  name = "i3-workspace-groups-wrapped";
  src = buildPythonPackage {
    pname = "i3-workspace-groups";
    version = "github-dd73289e6c89efd574413c3d4d76879878aaa0ca";
    inherit src;
    format = "pyproject";
    requirements = builtins.readFile "${src}/req/base.in";
  };
  buildInputs = [ makeWrapper coreutils ];
  installPhase = ''
    mkdir -p $out
    cp -R $src/bin $out/bin
  '';
  postFixup = ''
    for i in `ls $out/bin`; do
      wrapProgram $out/bin/$i \
        --set PATH ${makeBinPath [
          rofi
          coreutils
          gnugrep
          gnused
          "$out/bin"
        ]}
    done
  '';
}
