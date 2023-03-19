{ config, lib, pkgs, ... }:
{
  home.file.".config/gxkb/gxkb.cfg".source = pkgs.writeText "gxkb.cfg" ''
    [xkb config]
    group_policy=2
    default_group=0
    never_modify_config=false
    model=pc104
    layouts=gb,de,ua,ru
    variants=,,,
    toggle_option=,,,
    compose_key_position=;
  '';

  home.packages = [
    pkgs.gxkb
  ];

  # TODO: Do <something> about the hidden coupling between i3 start-up commands
  #       and programs such as this...
}
