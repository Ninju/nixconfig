{ config, lib, pkgs, ... }:
let
  mediaKeys = {
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
in
{
  xsession.windowManager.i3 = {
    enable = true;

    config = rec {
      terminal = "${pkgs.kitty}/bin/kitty";
      modifier = "Mod1"; # Left Alt
      keybindings = {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+Shift+q" = "kill";
        "${modifier}+d" = "exec ${pkgs.dmenu}/bin/dmenu_run -l 20";

        "${modifier}+Left" = "focus left";
        "${modifier}+Down" = "focus down";
        "${modifier}+Up" = "focus up";
        "${modifier}+Right" = "focus right";

        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Right" = "move right";

        "${modifier}+h" = "split h";
        "${modifier}+v" = "split v";
        "${modifier}+f" = "fullscreen toggle";

        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";

        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+space" = "focus mode_toggle";

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

        "${modifier}+Shift+1" =
          "move container to workspace number 1";
        "${modifier}+Shift+2" =
          "move container to workspace number 2";
        "${modifier}+Shift+3" =
          "move container to workspace number 3";
        "${modifier}+Shift+4" =
          "move container to workspace number 4";
        "${modifier}+Shift+5" =
          "move container to workspace number 5";
        "${modifier}+Shift+6" =
          "move container to workspace number 6";
        "${modifier}+Shift+7" =
          "move container to workspace number 7";
        "${modifier}+Shift+8" =
          "move container to workspace number 8";
        "${modifier}+Shift+9" =
          "move container to workspace number 9";
        "${modifier}+Shift+0" =
          "move container to workspace number 10";

        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+r" = "restart";

        # "${modifier}+Shift+e" =
        #   "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

        "${modifier}+r" = "mode resize";
        "${modifier}+Shift+z" = "exec ${pkgs.i3lock}/bin/i3lock -c 000000";

        "${mediaKeys.volume.mute}" = "exec amixer sset 'Master' toggle";
        "${mediaKeys.volume.down}" = "exec amixer sset 'Master' 5%-";
        "${mediaKeys.volume.up}" = "exec amixer sset 'Master' 5%+";

        "${modifier}+${mediaKeys.brightness.up}" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
        "${modifier}+${mediaKeys.brightness.down}" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";

        "${mediaKeys.brightness.up}" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +20%";
        "${mediaKeys.brightness.down}" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 20%-";

        "${modifier}+Ctrl+m" = "exec ${pkgs.pavucontrol}/bin/pavucontrol";
      };

      window = {
        titlebar = false;
        border = 1;
        hideEdgeBorders = "both";
        commands = [
          { command = "floating enable"; criteria = { class = "Pavucontrol"; }; }
          { command = "floating enable"; criteria = { class = "zoom"; }; }
        ];
      };

      assigns = {
        "1" = [{ class = "^Emacs$"; }];
        "8" = [{ class = "^[zZ]oom"; }];
        "9" = [{ class = "^Slack$"; }];
      };

      modes = {
        resize = {
          "Left" = "resize shrink width 10 px or 10 ppt";
          "Down" = "resize grow height 10 px or 10 ppt";
          "Up" = "resize shrink height 10 px or 10 ppt";
          "Right" = "resize grow width 10 px or 10 ppt";
          "Escape" = "mode default";
          "Return" = "mode default";
        };
      };
    };
  };
}
