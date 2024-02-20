{ config, lib, pkgs, ... }:
let
  cfg = config.services.kmonad;

  # Per-keyboard options:
  keyboard = { name, ... }: {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        example = "laptop-internal";
        description = "Keyboard name.";
      };

      device = lib.mkOption {
        type = lib.types.path;
        example = "/dev/input/by-id/some-dev";
        description = "Path to the keyboard's device file.";
      };

      extraGroups = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "openrazer" ];
        description = ''
          Extra permission groups to attach to the KMonad instance for
          this keyboard.

          Since KMonad runs as an unprivileged user, it may sometimes
          need extra permissions in order to read the keyboard device
          file.  If your keyboard's device file isn't in the input
          group you'll need to list its group in this option.
        '';
      };

      defcfg = {
        enable = lib.mkEnableOption ''
          Automatically generate the defcfg block.

          When this is option is set to true the config option for
          this keyboard should not include a defcfg block.
        '';

        compose = {
          key = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = "ralt";
            description = "The (optional) compose key to use.";
          };

          delay = lib.mkOption {
            type = lib.types.int;
            default = 5;
            description = "The delay (in milliseconds) between compose key sequences.";
          };
        };

        fallthrough = lib.mkEnableOption "Reemit unhandled key events.";

        allowCommands = lib.mkEnableOption "Allow keys to run shell commands.";
      };

      config = lib.mkOption {
        type = lib.types.lines;
        description = "Keyboard configuration.";
      };
    };

    config = {
      name = lib.mkDefault name;
    };
  };


  # START -- Copied verbatim from github.com/kmonad/kmonad
  mkCfg = keyboard:
    let defcfg = ''
      (defcfg
        input  (device-file "${keyboard.device}")
        output (uinput-sink "kmonad-${keyboard.name}")
    '' +
    lib.optionalString (keyboard.defcfg.compose.key != null) ''
      cmp-seq ${keyboard.defcfg.compose.key}
      cmp-seq-delay ${toString keyboard.defcfg.compose.delay}
    '' + ''
        fallthrough ${lib.boolToString keyboard.defcfg.fallthrough}
        allow-cmd ${lib.boolToString keyboard.defcfg.allowCommands}
      )
    '';
    in
    pkgs.writeTextFile {
      name = "kmonad-${keyboard.name}.cfg";
      text = lib.optionalString keyboard.defcfg.enable (defcfg + "\n") + keyboard.config;
      checkPhase = "${cfg.package}/bin/kmonad -d $out";
    };

  mkService = keyboard:
    let
      cmd = [
        "${cfg.package}/bin/kmonad"
        "--input"
        ''device-file "${keyboard.device}"''
      ] ++ cfg.extraArgs ++ [
        "${mkCfg keyboard}"
      ];

      groups = [
        "input"
        "uinput"
      ] ++ keyboard.extraGroups;
    in
    {
      name = "kmonad-${keyboard.name}";
      value = {
        Unit = { Description = "KMonad for ${keyboard.device}"; };
        Service = {
          Type = "exec";
          ExecStart = lib.escapeShellArgs cmd;
          Restart = "always";
          User = "kmonad";
          SupplementaryGroups = groups;
          Nice = -20;
        };
      };
    };

  # Build a systemd path config that starts the service below when a
  # keyboard device appears:
  mkPath = keyboard: rec {
    name = "kmonad-${keyboard.name}";
    value = {
      description = "KMonad trigger for ${keyboard.device}";
      wantedBy = [ "default.target" ];
      pathConfig.Unit = "${name}.service";
      pathConfig.PathExists = keyboard.device;
    };
  };

  # END -- Copied verbatim from github.com/kmonad/kmonad

  serviceName = keyboard: "kmonad-${keyboard.name}";

  pathDef = keyboard: ''
    [Unit]
    Description=KMonad trigger for ${keyboard.device}

    [Path]
    PathExists=${keyboard.device}
    Unit=${serviceName keyboard}.service
    '';

  serviceDef = keyboard: ''
    [Service]
    ExecStart='${cfg.package}' '--input' 'device-file "${keyboard.device}"' '${keyboard.config}'
    Nice=-20
    Restart=always
    SupplementaryGroups=input
    SupplementaryGroups=uinput
    Type=exec
    User=kmonad

    [Unit]
    Description=KMonad for ${keyboard.device}

    [Install]
    DefaultInstance=config
    WantedBy=default.target
  '';

  kmonadCfg = keyboard: pkgs.writeText (serviceName keyboard) keyboard.config;

  servicesAndPaths = pkgs.writeText "kmonad-systemd-files" ''
    ${serviceDef cfg.keyboard}

    ---

    ${pathDef cfg.keyboard}
  '';

  showServicesAndPaths = pkgs.writeShellScriptBin "kmonad-systemd-paths" ''
    echo Systemd files: ${servicesAndPaths}
    echo Keyboard config: ${kmonadCfg cfg.keyboard}
  '';

in
{
  options.services.kmonad = {
    enable = lib.mkEnableOption "KMonad: An advanced keyboard manager.";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.kmonad;
      example = "pkgs.haskellPackages.kmonad";
      description = "The KMonad package to use.";
    };

    keyboard = lib.mkOption {
      type = lib.types.submodule keyboard;
      default = { };
      description = "Keyboard configuration.";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "--log-level" "debug" ];
      description = "Extra arguments to pass to KMonad.";
    };
  };



  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
      showServicesAndPaths
    ];

    # users.groups.uinput = { };
    # users.groups.kmonad = { };

    # users.users.kmonad = {
    #   description = "KMonad system user.";
    #   group = "kmonad";
    #   isSystemUser = true;
    # };

    # no
    # services.udev.extraRules = ''
    #   # KMonad user access to /dev/uinput
    #   KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
    # '';

    # systemd.user.paths =
    #   builtins.listToAttrs
    #     (map mkPath (builtins.attrValues cfg.keyboards));

  #   systemd.user.services =
  #     builtins.listToAttrs
  #       (map mkService (builtins.attrValues cfg.keyboards));
  };
}
