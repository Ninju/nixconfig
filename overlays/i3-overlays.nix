{
  buildPythonPackage
, i3-workspace-groups
, i3-layouts
}:

{
  overlay = (final: prev:
    {
      i3-layouts = buildPythonPackage { src = i3-layouts; };

      i3-workspace-groups = final.stdenv.mkDerivation {
        name = "i3-workspace-groups-wrapped";
        src = buildPythonPackage { src = i3-workspace-groups; };
        buildInputs = [ final.makeWrapper final.coreutils ];
        installPhase = ''
                                      mkdir -p $out
                                      cp -R $src/bin $out/bin
                                    '';
        postFixup = ''
                                      for i in `ls $out/bin`; do
                                        wrapProgram $out/bin/$i \
                                          --set PATH ${final.lib.makeBinPath [
                                            final.rofi
                                            final.coreutils
                                            final.gnugrep
                                            final.gnused
                                            "$out/bin"
                                          ]}
                                      done
                                    '';
      };
    });
}
