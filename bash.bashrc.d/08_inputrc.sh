# ${bashbashrc_dir}/08_inputrc.sh
[ -n "$BASH" ] ||  return 0

# Skip all for non-interactive shells.
[[ "$-" = *i* ]] && [ -t 0 ] || return 0

# Set bash.bashrc dir if undefined.
[ ! -d "${bashbashrc_dir:-X}" ] && {
  bashbashrc_dir=$([ -n "${BASH_SOURCE%/*}" ] &&
  cd "${BASH_SOURCE%/*}"; pwd); } || :

# Lookup inputrc file in
for INPUTRC in \
"${bashrc_userdir:-X}"/{,.}inputrc{.d/"$TERM",."$TERM",} \
"${bashrclocaldir:-X}"/inputrc{.d/"$TERM",."$TERM",} \
"${bashbashrc_dir}"/inputrc.d/"${TERM}"
do
  [ -r "${INPUTRC}" ] &&
  break || INPUTRC=""
done

# Fallback
[ -z "${INPUTRC:-}" ] &&
[ -f "${bashbashrc_dir}/inputrc.d/default" ] &&
INPUTRC="${bashbashrc_dir}/inputrc.d/default" || :

# Export
[ -n "${INPUTRC:-}" ] &&
export INPUTRC || :

# end
return 0
