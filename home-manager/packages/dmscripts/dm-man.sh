#!/usr/bin/env bash
#
# Script name: dm-man
# Description: Search for a manpage or get a random one.
# Dependencies: dmenu, xargs
# GitLab: https://www.gitlab.com/dwt1/dmscripts
# License: https://www.gitlab.com/dwt1/dmscripts/LICENSE
# Contributors: Derek Taylor
#               Simon Ingelsson

# Set with the flags "-e", "-u","-o pipefail" cause the script to fail
# if certain things happen, which is a good thing.  Otherwise, we can
# get hidden bugs that are hard to discover.
set -euo pipefail

function main() {
  # An array of options to choose.
  local _options=( "Search manpages" "Random manpage" "Quit")
  # Piping the above array into dmenu.
  # We use "printf '%s\n'" to format the array one item to a line.
  choice=$(printf '%s\n' "${_options[@]}" | ${DMENU} 'Manpages:' "$@")

  # What to do when/if we choose one of the options.
  case "$choice" in
    'Search manpages')
          # shellcheck disable=SC2086
          man -k . | awk '{$3="-"; print $0}' | \
          ${DMENU} 'Search for:' | \
          awk '{print $2, $1}' | tr -d '()' | xargs $DMTERM man
    ;;
    'Random manpage')
          # shellcheck disable=SC2086
          man -k . | cut -d' ' -f1 | shuf -n 1 | \
          ${DMENU} 'Random manpage:' | xargs $DMTERM man
    ;;
    'Quit')
      echo "Program terminated." && exit 0
    ;;
    *)
      exit 0
    ;;
  esac

}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
