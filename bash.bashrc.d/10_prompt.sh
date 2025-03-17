# ${bashbashrc_dir}/11_prompt.sh
[ -n "$BASH" ] ||  return 0

# Skip all for non-interactive shells.
[[ "$-" = *i* ]] && [ -t 0 ] || return 0

# Default PS*
## PS* Prefix
PRE='\h'
[ ${UID:--1} -ne 0 ] &&
PRE='\u${SUDO_USER:+($SUDO_USER)}@'"${PRE}" ||
PRE="${PRE}"
[ ${SHLVL:-1} -gt 1 ] && 
PRE="${PRE}[${SHLVL}]" ||
PRE="${PRE}"
PRE="${PRE}"' \W'
## Set PS*
PS0=''
PS1="${PRE}"'\$ '
PS2="${PRE}"'> '
PS3=' Select # => '
PS4='+${BASH_SOURCE:+(${BASH_SOURCE##*/}${LINENO:+:$LINENO}):}'
PS4="${PS4}"' ${FUNCNAME:+$FUNCNAME(): }'
## Unset
unset PRE

# PS* for TERM
[ -t 0 ] &&
case "${TERM:-}" in
xterm*|screen*|tmux*|*-*color)
  # Load the prompt color setting.
  set +u
  for ps_color in \
  "${bashrc_userdir:-X}"/{,.}PS_COLOR{".$TERM",} \
  "${bashrclocaldir:-X}"/PS_COLOR{".$TERM",}
  do
    [ -f "${ps_color}" ] &&
    . "${ps_color}" &&
    break || :
  done &>/dev/null
  unset ps_color
  set -u
  # Set prompt color.
  [ ${UID:--1} -eq 0 ] && CLR='1;31' || CLR='1;34'
  PS1="\[\e[${PS1COLOR:-$CLR}m\]${PS1}\[\e[0;39m\]"
  PS2="\[\e[${PS2COLOR:-$CLR}m\]${PS2}\[\e[0;39m\]"
  PS3="\[\e[${PS3COLOR:-1;37}m\]${PS3}\[\e[0;39m\]"
  PS4="\[\e[${PS4COLOR:-1;30}m\]${PS4}\[\e[0;39m\]"
  unset CLR
  unset PS1COLOR PS2COLOR PS3COLOR PS4COLOR
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
"${bashrc_userdir:-X}"/{,.}prompt{command,}.d/{$TERM/,} \
"${bashrclocaldir:-X}"/prompt{command,}.d/{$TERM/,} \
"${bashbashrc_dir}"/promptcommand.d/{$TERM/,}
do
  if [ -d "${promptsdir:-}" ]
  then
    set +u
    for prompts_sh in "${promptsdir}"/[0-9][0-9]*.sh
    do
      [ -f "${prompts_sh}" -a \
        -x "${prompts_sh}" ] &&
      . "${prompts_sh}" &&
      [ -n "${PROMPT_COMMAND:-}" ] &&
      break 2 || :
    done
    unset prompts_sh
    set -u
  fi
done || :
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
fi || :

# End
return 0
