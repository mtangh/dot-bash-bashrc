# ${bashbashrc_dir}/promptcommand.d/00synchist.sh
_pc_synchist() {
  [ -s "${HISTFILE:-${HOME}/.bash_history}" \
    -a ${HISTFILESIZE:-0} -gt 0 ] && {
    history -a; history -c; history -r; } || :
  return $?
} 2>/dev/null
