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
# ANSI 256 Colors
echo "ANSI 256 Colors" &&
echo &&
for fgbg in FG BG
do
  case "${fgbg}" in
  FG) prfx="38;5" ;;
  BG) prfx="48;5" ;;
  esac
  for mode in 0 1
  do
    case "${mode}" in
    0) font="None" ;;
    1) font="Bold" ;;
    esac
    printf "\e[1m%s(%s) - %s\e[0m" "${fgbg}" "ESC[${prfx}:" "${font}"; echo
    for (( xclr=0; xclr<256; xclr++ ))
    do
      modn=$(( ${xclr}-((${xclr}/16)*16) ))
      [ "${modn}" = "0" ] &&
      printf "%03d-%03d: " "${xclr}" $(( ${xclr} + 15 )) || :
      printf "\e[%d;${prfx};%dm%03d\e[000m " "${mode}" "${xclr}" "${xclr}"
      [ "${modn}" = "15" ] &&
      echo || :
    done
    echo
  done
done
# End
exit 0
