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
: "Title" && {
  echo
  echo "$(printf "\e[1;4m%s\e[0m" "ANSI Colors")"
  echo
} # Title
echo "$(printf "\e[1m%s\e[0m" "Default / Default (3n;4n)")" && {
  for clbg in {40..47}
  do
    for clfg in {30..37}
    do
      printf "\e[0;%d;%dm%03d;%03d%-3s\e[0m" "${clfg}" "${clbg}" "${clfg}" "${clbg}" ""
    done
    echo
  done
}
echo
echo "$(printf "\e[1m%s\e[0m" "High-brightness / Default (9n;4n)")" && {
  for clbg in {40..47}
  do
    for clfg in {90..97}
    do
      printf "\e[0;%d;%dm%03d;%03d%-3s\e[0m" "${clfg}" "${clbg}" "${clfg}" "${clbg}" ""
    done
    echo
  done
}
echo
echo "$(printf "\e[1m%s\e[0m" "Default / High-brightness (3n;10n)")" && {
  for clbg in {100..107}
  do
    for clfg in {30..37}
    do
      printf "\e[0;%d;%dm%03d;%03d%-3s\e[0m" "${clfg}" "${clbg}" "${clfg}" "${clbg}" ""
    done
    echo
  done
}
echo
echo "$(printf "\e[1m%s\e[0m" "High-brightness / High-brightness (9n;10n)")" && {
  for clbg in {100..107}
  do
    for clfg in {90..97}
    do
      printf "\e[0;%d;%dm%03d;%03d%-3s\e[0m" "${clfg}" "${clbg}" "${clfg}" "${clbg}" ""
    done
    echo
  done
}
echo
# End
exit 0
