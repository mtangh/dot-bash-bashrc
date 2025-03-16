# ${bashbashrc_dir}/14_completions.sh
[ -n "$BASH" ] ||  return 0

# Skip all for non-interactive shells.
[[ "$-" = *i* ]] && [ -t 0 ] || return 0

# Set bash.bashrc dir if undefined.
[ ! -d "${bashbashrc_dir:-X}" ] && {
  bashbashrc_dir=$([ -n "${BASH_SOURCE%/*}" ] &&
  cd "${BASH_SOURCE%/*}"; pwd); } || :

# User bash-completion dir
[ -n "${BASH_COMPLETION_USER_DIR:-}" ] &&
usercmpltdir="${BASH_COMPLETION_USER_DIR:-}" ||
usercmpltdir="${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion"

# completion dierctory
for completdir in \
/usr/{,local/}share/bash-completion/completions \
"${usercmpltdir:-X}"/completions
do
  [ -d "${completdir:-}" ] ||
    continue
  for complet_sh in \
  "${completdir}"{,"/${ostype:-OS}","/${vendor:-OV}"}/*.sh
  do
    [ -f "${complet_sh}" -a -x "${complet_sh}" ] && {
    set +u; . "${complet_sh}"; set +u; } || :
  done
  unset complet_sh
done 2>/dev/null || :
unset usercmpltdir completdir

# End
return 0
