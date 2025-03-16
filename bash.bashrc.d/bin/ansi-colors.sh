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
# ANSI Colors
echo "ANSI Colors"
echo
printf "%5s:" "FG/BG"
for clfg in {30..37} 39 {90..97}
do
  printf " \e[0;%dm%03d\e[0m" "${clfg}" "${clfg}"
done
echo
for clbg in {40..47} 49 {100..107}
do
  printf "%2s\e[0;%dm%03d\e[0m:" "" "${clbg}" "${clbg}"
  for clfg in {30..37} 39 {90..97}
  do
    printf " \e[0;%d;%dm%03d\e[0m" "${clfg}" "${clbg}" "${clfg}"
  done
  echo
done
echo
# End
exit 0
