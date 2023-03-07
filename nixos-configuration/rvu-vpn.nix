{ config, lib, pkgs, ... }:
let
  cfg = config.services.rvu-vpn;

  inherit (lib) mkIf mkEnableOption mkOption literalExample types;
in
{
  options.services.rvu-vpn = {
    enable = mkEnableOption "Enable the AWS VPN Client for RVU";
    configFile = mkOption {
      type = types.path;
      example = literalExample ''/etc/awsvpnclient/rvu_conf.ovpn'';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      # Provided by overlay via flake
      pkgs.awsvpnclient
    ];

    systemd.services.rvu-vpn = {
      description = "RVU VPN (using AWS VPN Client)";
      after = [ "network.target" ];
      restartIfChanged = true;

      serviceConfig = {
        Type = "simple";
        ExecStart = ''${pkgs.awsvpnclient}/bin/awsvpnclient --start --config ${cfg.configFile}'';
        Restart = "always";
      };
    };
  };
}
