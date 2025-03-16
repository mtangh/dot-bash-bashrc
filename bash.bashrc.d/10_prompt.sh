# ${bashbashrc_dir}/11_prompt.sh
[ -n "$BASH" ] ||  return 0

# Skip all for non-interactive shells.
[[ "$-" = *i* ]] && [ -t 0 ] || return 0

# Default PS*
PS1=$([ ${UID:--1} -ne 0 ] && echo '\u${SUDO_USER:+($SUDO_USER))}@' || :)
PS1="${PS1}"'\h'"$([ ${SHLVL:-1} -gt 1 ] && echo "[${SHLVL}]" || :;)"' \W\$ '
PS2='> '
PS3='=> '
PS4='+${BASH_SOURCE:+(${BASH_SOURCE##*/}${LINENO:+:$LINENO}):} ${FUNCNAME:+$FUNCNAME(): }'

# PS* for TERM
[ -t 0 ] &&
case "${TERM:-}" in
xterm*|screen*|tmux*)
  CLR=$([ ${UID:--1} -eq 0 ] && echo '1;31' || echo '1;34')
  CL1="${CLR}"
  CL2="${CLR}"
  CL3="${CLR}"
  CL4="1;30"
  PS1="\[\e[${CL1}m\]${PS1}\[\e[0;39m\]"
  PS2="\[\e[${CL2}m\]${PS2}\[\e[0;39m\]"
  PS3="\[\e[${CL3}m\]${PS3}\[\e[0;39m\]"
  PS4="\[\e[${CL4}m\]${PS4}\[\e[0;39m\]"
  unset CLR CL1 CL2 CL3 CL4
  ;;
*)
  ;;
esac || :

# Set bash.bashrc dir if undefined.
[ ! -d "${bashbashrc_dir:-X}" ] && {
  bashbashrc_dir=$([ -n "${BASH_SOURCE%/*}" ] &&
  cd "${BASH_SOURCE%/*}"; pwd); } || :

# Initialize PROMPT_COMMAND
PROMPT_COMMAND=""

# Lookup PROMPT_COMMAND
for promptsdir in \
"${bashrc_userdir:-X}"/{,.}promptcommand.d/{$TERM/,} \
"${bashrclocaldir:-X}"/promptcommand.d/{$TERM/,} \
"${bashbashrc_dir}"/promptcommand.d/{$TERM/,}
do
  [ -d "${promptsdir:-}" ] || continue
  for prompts_sh in "${promptsdir}"/[0-9][0-9]*.sh
  do
    [ -f "${prompts_sh}" -a -x "${prompts_sh}" ] && {
    set +u; . "${prompts_sh}"; set -u; } &&
    [ -n "${PROMPT_COMMAND:-}" ] && break 2 || :
  done
  unset prompts_sh
done 2>/dev/null || :
unset promptsdir

# PROMPT_COMMAND
if [ -z "${PROMPT_COMMAND}" ]
then
  for prompt_cmd in $(
    declare -F |grep 'declare -f _pc_' |while read -r _fnc
    do echo "${_fnc##* -f }"; done; )
  do
    PROMPT_COMMAND="${PROMPT_COMMAND}${PROMPT_COMMAND:+;}"
    PROMPT_COMMAND="${PROMPT_COMMAND}${prompt_cmd}"
  done
  unset prompt_cmd
fi &>/dev/null || :

# End
return 0
