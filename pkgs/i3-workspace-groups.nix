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
  src = buildPythonPackage { inherit src; };
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
