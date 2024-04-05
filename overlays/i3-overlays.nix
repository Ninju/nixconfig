{
  buildPythonPackage
, i3-workspace-groups
, i3-layouts
}:

{
  overlay = (final: prev:
    {
      i3-layouts = final.callPackage ../pkgs/i3-layouts.nix {
        inherit buildPythonPackage;
        src = i3-layouts;
      };

      # i3-workspace-groups = final.callPackage ../pkgs/i3-workspace-groups.nix {
      #   inherit (final.stdenv) mkDerivation;
      #   inherit (final.lib) makeBinPath;
      #   inherit buildPythonPackage;
      #   src = i3-workspace-groups;
      # };
    });
}
