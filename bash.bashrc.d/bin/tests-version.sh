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
# Variables
oper="-eq"
lver=""
rver=""
_ret=0
# Function
## ver_str2num
ver_str2num() {
  local str="${1:-}"
  local maj=""
  local min=""
  local rev=""
  : && {
    echo "${str}" |
    ( IFS=. read -r maj min rev;
      expr "${maj:-0}" + 0 &>/dev/null || maj=0
      expr "${min:-0}" + 0 &>/dev/null || min=0
      expr "${rev:-0}" + 0 &>/dev/null || rev=0
      printf "%d%04d" ${maj:-0} ${min:-0} ${rev:-0} )
  } 2>/dev/null
  return $?
}
## usage
usage() {
cat - <<_EOF_
Usage: ${NAME} VERSION
       ${NAME} OPE VERSION
       ${NAME} VERSION1 OPE VERSION2

_EOF_
  return 0    
}
# Options
while [ $# -gt 0 ]
do
  case "${1:-}" in
  -eq|-ne|-gt|-lt|-ge|-le)
    oper="${1:-}"
    [ -n "${lver:-}" ] ||
    lver="${BASH_VERSION:-}"
    ;;
  -*)
    echo "${NAME:-}: ERROR: Invalid argument, args='${1:-}'." 1>&2
    exit 22
    ;;
  *)
    if [ -z "${lver:-}" ]
    then lver="${1:-}"
    elif [ -z "${rver:-}" ]
    then rver="${1:-}"
    fi
    ;;
  esac
  shift
done
# Validation
{ [ -n "${lver:-}" ] &&
  lver="$(ver_str2num "${lver}")"; } || {
  echo "${NAME:-}: ERROR: Invalid argument, lver='${lver:-}'." 1>&2
  exit 22; }
{ [ -n "${rver:-}" ] &&
  rver="$(ver_str2num "${rver}")"; } || {
  echo "${NAME:-}: ERROR: Invalid argument, rver='${rver:-}'." 1>&2
  exit 22; }
# Test
test "${lver}" "${oper}" "${rver}"; _ret=$?
# End
exit ${_ret:-1}
