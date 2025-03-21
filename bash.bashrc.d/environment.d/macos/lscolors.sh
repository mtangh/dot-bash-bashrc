# ${bashbashrc_dir}/environment.d/${ostype}/lscolors.sh

# Skip all for non-interactive shells.
[[ "$-" = *i* ]] && [ -t 0 ] || return 0

##
## color-ls For macOS
##

# Lookup the LSCOLORS setting.
for lscolors in \
"${bashrc_userdir:-X}"/{,.}lscolors{.d/$TERM,.$TERM,} \
"${bashrclocaldir:-X}"/{environment.d/,}LSCOLORS{.$TERM,}
do
  [ -f "${lscolors}" -a -r "${lscolors}" ] &&
  break || lscolors=""
done || :

# Fallback: Apply the default settings.
if [ -z "${lscolors:-}" -a -n "${BASH_SOURCE:-}" ]
then
  for lscolors in "${BASH_SOURCE%/*}/LSCOLORS"{.${TERM},}
  do
    [ -f "${lscolors}" -a -r "${lscolors}" ] &&
    break || lscolors=""
  done || :
fi

# Set the LSCOLORS environment variable from the lookup file.
if [ -x "${lscolors:-X}" ]
then
  LSCOLORS="$(bash "${lscolors}")" || :
elif [ -f "${lscolors:-X}" ]
then
  LSCOLORS=$(grep -Ev '^[[:space:]]*#' "${lscolors}" |tr -d '[[:space:]]' )
fi
unset lscolors

# Export the LSCOLORS environment variable.
[ -n "${LSCOLORS:-}" ] && export LSCOLORS || :

# Setup ls aliases
alias ls="ls -FGq"
alias le="ls -le"
alias l@="ls -l@"
alias lll="ls -lTO"
alias lsacl="ls -le"
alias lsattr="ls -l@"

# End
return 0
