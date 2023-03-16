{}:
{
  overlay = (final: prev: {
    pbcopy = final.callPackage ../pkgs/pbcopy.nix {};
  });
}
