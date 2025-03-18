# ${bashbashrc_dir}/11_prompt.sh
[ -n "$BASH" ] ||  return 0

# Skip all for non-interactive shells.
[[ "$-" = *i* ]] && [ -t 0 ] || return 0

# Default PS* Settings.

## PS[12] Settings.
[ ${UID:--1} -ne 0 ] &&
PSU='\u${SUDO_USER:+($SUDO_USER)}@\h' ||
PSU='\h'
[ ${SHLVL:-1} -gt 1 ] && 
PSU="${PSU}[${SHLVL}]" || :
PSO='\W'

## Prompt Color Settings.
CL1=""
CL2=""
CL3=""
CL4=""
CLE=""
case "${TERM:-}" in
xterm*|screen*|tmux*|*-*color)
  [ ${UID:--1} -eq 0 ] &&
  CL1="\[\e[1;31m\]" ||
  CL1="\[\e[1:34m\]"
  CL2="${CL1}"
  CL3="\[\e[1;37m\]"
  CL4="\[\e[1;30m\]"
  CLE="\[\e[0;39m\]"
  ;;
*)
  ;;
esac

## Displayed by interactive shells after reading
## a command and before the command is executed.
PS0=''
## The primary prompt string. 
PS1="${CL1}${PSU}${CLE} ${CL2}${PSO}"'\$'"${CLE} "
## The secondary prompt string.
PS2="${CL1}${PSU}${CLE} ${CL2}${PSO}>${CLE} "
## The prompt for the select command
PS3='Select # =>'
PS3="${CL3}${PS3}${CLE} "
## DEBUG
PS4='+'
PS4="${PS4}"'${BASH_SOURCE:+'
PS4="${PS4}"'(${BASH_SOURCE##*/}${LINENO:+:$LINENO}):'
PS4="${PS4}"'}${FUNCNAME:+ $FUNCNAME():}'
PS4="${CL4}${PS4}${CLE} "

## Unset used variables.
unset PSU PSO
unset CL1 CL2 CL3 CL4 CLE

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
