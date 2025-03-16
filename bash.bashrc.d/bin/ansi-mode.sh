#!/bin/bash
[ "$0" = "$BASH_SOURCE" ] 1>/dev/null 2>&1 || {
echo "Run it directory." 1>&2; exit 1; }
THIS="${BASH_SOURCE}"
NAME="${THIS##*/}"
BASE="${NAME%.*}"
CDIR=$([ -n "${THIS%/*}" ] && cd "${THIS%/*}" &>/dev/null || :; pwd)
# Prohibits overwriting by redirect and use of undefined variables.
set -Cu
# The return value of a pipeline is the value of the last command to
# exit with a non-zero status.
set -o pipefail
# ANSI modeibutes
echo "ANSI Mode"
for mode in 0 1 2 3 4 5 6 7 8 9
do
  case "${mode}" in
  0) name="reset" ;;
  1) name="bold" ;;
  2) name="dim/faint" ;;
  3) name="italic" ;;
  4) name="underline" ;;
  5) name="blinking" ;;
  6) name="????????????????" ;;
  7) name="inverse/reverse" ;;
  8) name="hidden/invisible" ;;
  9) name="strikethrough" ;;
  esac
  printf "ESC[%1dm: %-16s \e[%dm%s\e[0m" "${mode}" "${name}" "${mode}" "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  echo
done
echo
# End
exit 0
