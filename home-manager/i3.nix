{ config, lib, pkgs, specialArgs, ... }:
let
  mkMenu = cmd: "${pkgs.rofi}/bin/rofi -show ${cmd}";

  i3blocksContribRev = specialArgs.i3blocks-contrib.rev;
  i3blocksContribDir = "~/.config/i3blocks-contrib";

  keys = {
    super = "Mod4";

    print = "Print";

    media = {
      brightness = {
        up = "XF86MonBrightnessUp";
        down = "XF86MonBrightnessDown";
      };

      volume = {
        up = "XF86AudioRaiseVolume";
        down = "XF86AudioLowerVolume";
        mute = "XF86AudioMute";
      };

      display = "XF86Display";
    };
  };

  menus = {
    runApps = mkMenu "drun";
    switchWindows = mkMenu "window";
    showMsg = mkMenu "window -e";
  };
in
{
  home.file.".config/rofi/config.rasi".source = ../dotfiles/.config/rofi/config.rasi;
  home.file.".config/i3blocks/config".source = ../dotfiles/.config/i3blocks/config;
  home.file.".conkyrc".source = ../dotfiles/.config/conky/doom-one.conkyrc;

  home.activation.link-i3blocks-contrib = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d ${i3blocksContribDir} ]; then
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone http://github.com/vivien/i3blocks-contrib ${i3blocksContribDir}
      $DRY_RUN_CMD pushd ${i3blocksContribDir}
      $DRY_RUN_CMD ${pkgs.git}/bin/git reset --hard ${i3blocksContribRev}
      $DRY_RUN_CMD popd
    fi
  '';

  home.packages = [
    # i3block-contrib
    ### Blocks require Python, but this is declared in home.nix
    pkgs.acpi # battery2

    pkgs.jetbrains-mono
    # For volume control pane
    pkgs.mate.mate-media

    pkgs.i3-easyfocus
    pkgs.i3-layouts
    pkgs.i3-workspace-groups
    pkgs.i3status
    pkgs.i3blocks

    pkgs.arandr

    pkgs.lxappearance

    pkgs.killall

    pkgs.nitrogen
    pkgs.brightnessctl
    pkgs.flameshot
    pkgs.blueman

    pkgs.rofi
  ];

  xsession.windowManager.i3 = {
    enable = true;

    package = pkgs.i3-gaps;

    config = rec {
      terminal = "${pkgs.kitty}/bin/kitty";
      modifier = "Mod1"; # Left Alt
      menu = menus.runApps;
      keybindings = {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+q" = "kill";
        "${modifier}+Shift+q" = "kill";

        "${modifier}+d" = "exec ${menus.runApps}";
        "${modifier}+Shift+d" = "exec ${menus.switchWindows}";
        "${modifier}+n" = "exec ${menus.runApps}";
        "${modifier}+Shift+n" = "exec ${menus.switchWindows}";

        "${modifier}+Left" = "focus left";
        "${modifier}+Down" = "focus down";
        "${modifier}+Up" = "focus up";
        "${modifier}+Right" = "focus right";

        "${modifier}+Shift+Left" = "$exec_i3l move left";
        "${modifier}+Shift+Down" = "$exec_i3l move down";
        "${modifier}+Shift+Up" = "$exec_i3l move up";
        "${modifier}+Shift+Right" = "$exec_i3l move right";

        "${modifier}+h" = "split h";
        "${modifier}+v" = "split v";
        "${modifier}+f" = "fullscreen toggle";

        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";

        "${modifier}+Shift+space" = "floating toggle";
        # "${modifier}+space" = "focus mode_toggle";
        "${modifier}+space" = "exec ${pkgs.i3-easyfocus}/bin/i3-easyfocus";

        "${modifier}+a" = "focus parent";

        "${modifier}+Shift+minus" = "move scratchpad";
        "${modifier}+minus" = "scratchpad show";

        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";

        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10";

        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+r" = "restart";

        # "${modifier}+Shift+e" =
        #   "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

        "${keys.print}" = "exec ${pkgs.flameshot}/bin/flameshot gui";
        "Shift+${keys.print}" = "exec ${pkgs.flameshot}/bin/flameshot screen";
        "Shift_R+${keys.print}" = "exec ${pkgs.flameshot}/bin/flameshot screen";
        "Ctrl+Shift+${keys.print}" = "exec ${pkgs.flameshot}/bin/flameshot full";
        "Ctrl+Shift_R+${keys.print}" = "exec ${pkgs.flameshot}/bin/flameshot full";

        "${keys.media.volume.mute}" = "exec amixer sset 'Master' toggle";
        "${keys.media.volume.down}" = "exec amixer sset 'Master' 5%-";
        "${keys.media.volume.up}" = "exec amixer sset 'Master' 5%+";

        "${modifier}+${keys.media.brightness.up}" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
        "${modifier}+${keys.media.brightness.down}" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";

        "${keys.media.brightness.up}" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +20%";
        "${keys.media.brightness.down}" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 20%-";

        "${keys.media.display}" = "exec ${pkgs.autorandr}/bin/autorandr --change";
        "Shift+${keys.media.display}" = "exec ${pkgs.arandr}/bin/arandr";

        "${modifier}+Ctrl+m" = "exec ${pkgs.mate.mate-media}/bin/mate-volume-control";
        "${modifier}+Shift+p" = "exec ${menus.showMsg} \"$(date '+%X   %A %d %B %Y   %-W/52   %-j/365')\"";

        "${modifier}+Shift+z" = "exec ${pkgs.i3lock}/bin/i3lock -c 000000";

        "${modifier}+Shift+x" = "mode lock";
        "${modifier}+r"       = "mode resize";
        "${keys.super}+d"     = "mode dmenu";
        "${keys.super}+l"     = "mode layouts";
      };

      gaps = {
        inner = 0;
        outer = 3;
      };

      window = {
        titlebar = false;
        border = 5;
        hideEdgeBorders = "smart";
        commands = [
          { command = "floating enable"; criteria = { class = "Sound Preferences"; }; }
          { command = "floating enable"; criteria = { class = "zoom"; }; }
          { command = "floating enable"; criteria = { class = "blueman-applet"; }; }
          { command = "floating enable sticky enable"; criteria = { class = "xpad"; }; }
        ];
      };

      assigns = {
        "8" = [{ class = "^[zZ]oom"; }];
        "9" = [{ class = "^Slack$"; }];
      };

      modes = {
        resize = {
          "Left" = "resize shrink width 10 px or 10 ppt";
          "Down" = "resize grow height 10 px or 10 ppt";
          "Up" = "resize shrink height 10 px or 10 ppt";
          "Right" = "resize grow width 10 px or 10 ppt";

          "Shift+Left" = "resize shrink width 50 px or 50 ppt";
          "Shift+Down" = "resize grow height 50 px or 50 ppt";
          "Shift+Up" = "resize shrink height 50 px or 50 ppt";
          "Shift+Right" = "resize grow width 50 px or 50 ppt";

          "Space" = "mode default";
          "Escape" = "mode default";
          "Return" = "mode default";
        };

        dmenu = {
          "c" = "exec ${pkgs.dm-colpick}/bin/dm-colpick";
          "i" = "exec ${pkgs.dm-ip}/bin/dm-ip";
          "k" = "exec ${pkgs.dm-kill}/bin/dm-kill";
          "m" = "exec ${pkgs.dm-man}/bin/dm-man";
          "s" = "exec ${pkgs.dm-websearch}/bin/dm-websearch";
          "t" = "exec ${pkgs.dm-translate}/bin/dm-translate";
          "w" = "exec ${pkgs.dm-wifi}/bin/dm-wifi";
          "Escape" = "mode default";
          "Return" = "mode default";
        };

        lock = {
          "z" = "exec ${pkgs.xlockmore}/bin/xlock -mode random";
          "x" = "exec ${pkgs.xlockmore}/bin/xlock -mode matrix";
          "c" = "exec ${pkgs.xlockmore}/bin/xlock -mode bomb -count 60";
          "b" = "exec ${pkgs.xlockmore}/bin/xlock -mode bomb -count 60";
          "s" = "exec ${pkgs.xlockmore}/bin/xlock -mode space";
          "m" = "exec ${pkgs.xlockmore}/bin/xlock -mode maze";
          "Escape" = "mode default";
          "Return" = "mode default";
        };

        layouts = {
          "v" = "$exec_i3l vstack";
          "h" = "$exec_i3l hstack";
          "s" = "$exec_i3l spiral";
          "c" = "$exec_i3l companion";
          "a" = "$exec_i3l autosplit";
          "2" = "$exec_i3l 2columns";
          "3" = "$exec_i3l 3columns";
          "Escape" = "mode default";
          "Return" = "mode default";
        };
      };

      bars = [{
        mode = "dock";
        position = "top";
        fonts = {
          names = [ "Source Code Pro" "monospace" ];
          size = 12.0;
        };
        statusCommand = "SCRIPT_DIR=${i3blocksContribDir} ${pkgs.i3blocks}/bin/i3blocks";
      }];

      startup = [
        { command = "${pkgs.i3-layouts}/bin/i3-layouts"; always = true; notification = true; }
        { command = "${pkgs.i3-workspace-groups}/bin/i3-workspace-groups"; always = true; notification = true; }
        { command = "${pkgs.gxkb}/bin/gxkb"; }
        { command = "nm-applet"; always = true; notification = true; }
        { command = "kwalletd5"; always = true; notification = true; }
        { command = "${pkgs.kwallet-pam}/libexec/pam_kwallet_init"; always = true; notification = true; }
        { command = "${pkgs.blueman}/bin/blueman-applet"; always = true; notification = true; }
        { command = "${pkgs.mate.mate-media}/bin/mate-volume-control-status-icon"; always = true; notification = true; }
        { command = "${pkgs.nitrogen}/bin/nitrogen --restore"; always = true; }
        { command = "${pkgs.killall}/bin/killall conky"; always = true; }
        { command = "sleep 2 && ${pkgs.conky}/bin/conky"; always = true; }
      ];
    };

    extraConfig = ''
    set $exec_i3l exec --no-startup-id ${pkgs.i3-layouts}/bin/i3l

    set $i3l vstack to workspace 1
    set $i3l vstack to workspace 2
    set $i3l vstack to workspace 3
    set $i3l vstack to workspace 4
    set $i3l vstack to workspace 5
    set $i3l vstack to workspace 6
    set $i3l vstack to workspace 7
    set $i3l vstack to workspace 8
    set $i3l vstack to workspace 9
    set $i3l vstack to workspace 10
    '';
  };
}
