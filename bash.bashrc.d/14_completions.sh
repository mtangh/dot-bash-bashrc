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

# completion scripts
for complet_sh in \
/usr/{,local/}share/bash-completion/completions/*.sh \
"${usercmpltdir:-X}/completions"/*.sh \
"${usercmpltdir:-X}/completions/${ostype:-OS}"/*.sh \
"${usercmpltdir:-X}/completions/${vendor:-OV}"/*.sh \
"${usercmpltdir:-X}/completions/hosts/${HOSTNAME%%.*}"/*.sh
do
  [ -f "${complet_sh}" -a -x "${complet_sh}" ] && {
  set +u; . "${complet_sh}"; set -u; }
done || :
unset usercmpltdir complet_sh

# End
return 0
