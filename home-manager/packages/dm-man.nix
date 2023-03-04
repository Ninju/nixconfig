{ pkgs, ... }:

pkgs.writeShellScriptBin "dm-man" ''
function main() {
  # An array of options to choose.
  local _options=( "Search manpages" "Random manpage" "Quit")
  # Piping the above array into dmenu.
  # We use "printf '%s\n'" to format the array one item to a line.
  choice=$(printf '%s\n' "''${_options[@]}" | ${pkgs.dmenu}/bin/dmenu -i -l 20 -p 'Manpages:' "$@")

  # What to do when/if we choose one of the options.
  case "$choice" in
    'Search manpages')
          # shellcheck disable=SC2086
          man -k . | awk '{$3="-"; print $0}' | \
          ${pkgs.dmenu}/bin/dmenu -i -l 20 -p 'Search for:' | \
          awk '{print $2, $1}' | tr -d '()' | xargs ${pkgs.kitty}/bin/kitty man
    ;;
    'Random manpage')
          # shellcheck disable=SC2086
          man -k . | cut -d' ' -f1 | shuf -n 1 | \
          ${pkgs.dmenu}/bin/dmenu -i -l 20 -p 'Random manpage:' | xargs ${pkgs.kitty}/bin/kitty man
    ;;
    'Quit')
      echo "Program terminated." && exit 0
    ;;
    *)
      exit 0
    ;;
  esac

}

[[ "''${BASH_SOURCE[0]}" == "''${0}" ]] && main "$@"
''
