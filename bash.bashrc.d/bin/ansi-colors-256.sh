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
: "Title" && {
  echo
  echo "$(printf "\e[1;4m%s\e[0m" "ANSI 256 Colors")"
  echo
} # Title
echo "$(printf "\e[1m%s\e[0m" "Basic Colors (8x2)" )" && {
  csta=0
  cend=16
  colm=8
  blnk="$(( ( 72 / ${colm} ) - 3 ))"
  printf "%-8s" ""
  for (( coln=0; coln<${colm}; coln++ ))
  do
    printf "+%02d%-${blnk}s" "${coln}" ""
  done
  echo
  for (( rown=0; rown<${cend}; rown+=${colm} ))
  do
    printf "%03d-%03d " "${rown}" $(( ${rown} + ${colm} - 1 ))
    for (( coln=0; coln<${colm}; coln++ ))
    do
      bclr=$(( ${rown} + ${coln} ))
      fclr=$(( ${rown} + ${colm} - ${bclr} - 1 ))
      printf "\e[38;5;%d;48;5;%dm%03d%-${blnk}s\e[0m" "${fclr}" "${bclr}" "${bclr}" ""
    done
    echo
  done
  echo
} # Basic Color
echo "$(printf "\e[1m%s\e[0m" "Enhanced 8-bit Color (6x6x6)")" && {
  csta=16
  cend=232
  colm=6
  blnk="$(( ( 72 / ${colm} ) - 3 ))"
  for (( step=${csta}; step<${cend}; step+=$(( $colm * $colm )) ))
  do
    printf "%-8s" ""
    for (( coln=0; coln<${colm}; coln++ ))
    do
      printf "+%02d%-${blnk}s" "${coln}" ""
    done
    echo
    for (( rown=${step}; rown<$(( ${step} + ( $colm * $colm - 1 ) )); rown+=${colm} ))
    do
      printf "%03d-%03d " "${rown}" $(( ${rown} + ${colm} - 1 ))
      for (( coln=0; coln<${colm}; coln++ ))
      do
        bclr=$(( ${rown} + ${coln} ))
        fclr=$(( ${cend} - ( ${bclr} - ${csta} ) - 1 ))
        printf "\e[38;5;%d;48;5;%dm%03d%-${blnk}s\e[0m" "${fclr}" "${bclr}" "${bclr}" ""
      done
      echo
    done
  done
  echo
} # Enhanced 8-bit Color
echo "$(printf "\e[1m%s\e[0m" "Gray-Scale")" && {
  csta=232
  cend=256
  colm=6
  blnk="$(( ( 72 / ${colm} ) - 3 ))"
  printf "%-8s" ""
  for (( coln=0; coln<${colm}; coln++ ))
  do
    printf "+%02d%-${blnk}s" "${coln}" ""
  done
  echo
  for (( rown=${csta}; rown<${cend}; rown+=${colm} ))
  do
    printf "%03d-%03d " "${rown}" $(( ${rown} + ${colm} - 1 ))
    fclr=$([ ${rown} -eq ${csta} ] && echo $(( ${cend} - 1 )) || echo ${csta};)
    for (( coln=0; coln<${colm}; coln++ ))
    do
      bclr=$(( ${rown} + ${coln} ))
      printf "\e[38;5;%d;48;5;%dm%03d%-${blnk}s\e[0m" "${fclr}" "${bclr}" "${bclr}" ""
    done
    echo
  done
  echo
} # Gray-Scale
echo
# End
exit 0
