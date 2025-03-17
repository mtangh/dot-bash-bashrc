# ${bashbashrc_dir}/11_prompt.sh
[ -n "$BASH" ] ||  return 0

# Skip all for non-interactive shells.
[[ "$-" = *i* ]] && [ -t 0 ] || return 0

# Default PS*

## PS* Prefix
[ ${UID:--1} -ne 0 ] &&
PSU='\u${SUDO_USER:+($SUDO_USER)}@\h' ||
PSU='\h'
[ ${SHLVL:-1} -gt 1 ] && 
PSU="${PSU}[${SHLVL}]" || :

# PS* for TERM
case "${TERM:-}" in
xterm*|screen*|tmux*|*-*color)
  # Set prompt color.
  [ ${UID:--1} -eq 0 ] && CLR='1;31' || CLR='1;34'
  CL1="\[\e[${CLR}m\]"
  CL2="\[\e[${CLR}m\]"
  CL3="\[\e[1;37m\]"
  CL4="\[\e[1;30m\]"
  CLE="\[\e[0;39m\]"
  unset CLR
  ;;
*)
  CL1=""
  CL2=""
  CL3=""
  CL4=""
  CLE=""
  ;;
esac || :

## Set PS*
PS0=''
PS1="${CL1)${PSU}${CLE} ${CL2}"'\W\$'"${CLE} "
PS2="${CL1}${PSU}${CLE} ${CL2}"'\W>'"${CLE} "
PS3=" ${CL3}Select # =>${CLE} "
PS4='+${BASH_SOURCE:+(${BASH_SOURCE##*/}${LINENO:+:$LINENO}):}'
PS4="${PS4}"'${FUNCNAME:+ $FUNCNAME():}'
PS4="${CL4}${PS4}${CLE} "

## Unset
unset PRU CL1 CL2 CL3 CL4 CLE

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
