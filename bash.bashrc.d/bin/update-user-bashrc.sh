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
# PATH
PATH=/usr/bin:/bin
export PATH
# Flags
fail=0
# Main
[ -d "${CDIR%/bin*}/skel.d" ] && {

  for skelfile in "${CDIR%/bin*}/skel.d"/*
  do
    basename="${skelfile##*/}"
    destname="${basename}"
    # filename
    case "${basename}" in
    dot-*)
      destname=".${basename#dot-}"
      ;;
    *)
      ;;
    esac
    # Check
    if [ -e "${HOME}/${destname}" ]
    then
      # if skelfile is older than ${HOME}/dotfiles
      [ "${skelfile}" -ot "${HOME}/${destname}" ] && {
        echo "${NAME}: The '${skelfile}' is older than '${HOME}/${destname}'."
        continue; } || :
      # Check diffs
      diff "${skelfile}" "${HOME}/${destname}" &>/dev/null && {
        echo "${NAME}: No differences '${skelfile}' and '${HOME}/${destname}'."
        continue; } || :
      # Rename
      mv -f "${HOME}/${destname}"{,"_$(date +'%s')"}
    fi
    # Update
    cp -prf "${skelfile}" "${HOME}/${destname}"
    if [ $? -eq 0 ]
    then
      echo "${NAME}: Copy from '${skelfile}' to '${HOME}/${destname}'."
    else
      echo "${NAME}: Copy failed, from='${skelfile}', to='${HOME}/${destname}'." 1>&2;
      fail=1
    fi
  done

} # [ -d "${CDIR%/bin*}/skel.d" ] &&
# end of shell
[ ${fail:-0} -eq 0 ]
exit $?
