# ${bashbashrc_dir}/12_aliases.sh

# Skip all for non-interactive shells.
[[ "$-" = *i* ]] && [ -t 0 ] || return 0

# Aliasses

## cd
alias ..='cd ..'
alias cdp='cd -P'

## cp, mv, rm
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

## history
alias hist=history

## ls
alias la="ls -a"
alias ll="ls -l"
alias lla="ls -la"
alias l.="ls -d .*"

## vim
: "vim" && {
  # Unset tmpid
  unset tmpid &>/dev/null || :
  # vim installed, and Privileged user
  if [ -x "$(type -P vim)" ] && [ $UID -le 500 ]
  then
    # for bash and zsh, only if no alias is already set
    alias vi 1>/dev/null 2>&1 || alias vi=vim
  fi
} # : "vim" &&

# Exit if this shell is not Bash
[ -n "$BASH" ] || return 0

## Set bash.bashrc dir if undefined.
[ ! -d "${bashbashrc_dir:-X}" ] && {
  bashbashrc_dir=$([ -n "${BASH_SOURCE%/*}" ] &&
  cd "${BASH_SOURCE%/*}"; pwd); } || :

## Reloading bashrc
if [ -n "${BASH_SOURCE}" ]
then
  ind_last=$(( ${#BASH_SOURCE[@]} - 1 ))
  sourcerc="${BASH_SOURCE[${ind_last:-0}]}"
  if [ ${ind_last:--1} -ge 0 -a -f "${sourcerc:-X}" ]
  then
    trap 'source "${sourcerc}" && echo OK.' USR1
    alias reload-bashrc-all="pkill -USR1 bash"
  fi
  unset sourcerc ind_last
fi

## load aliases
for aliases_file in \
"${bashrclocaldir:-X}/aliases" \
"${bashrclocaldir:-X}/aliases.d"/* \
"${bashrc_userdir:-X}"/{bash_,.bash_,}aliases \
"${bashrc_userdir:-X}"/{bash_,.bash_,}aliases.d/* \
"${bashrc_userdir:-X}"/{bash_,.bash_,}aliases.d/"${ostype:-OS}"/* \
"${bashrc_userdir:-X}"/{bash_,.bash_,}aliases.d/"${vendor:-OV}"/* \
"${bashrc_userdir:-X}"/{bash_,.bash_,}aliases.d/hosts/"${HOSTNAME%%.*}"/*
do
  [ -f "${aliases_file}" -a -r "${aliases_file}" ] && {
  set +u; . "${aliases_file}"; set -u; }
done || :
unset aliases_file

# End
return 0

