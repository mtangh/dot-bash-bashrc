# ${bashbashrc_dir}/environment.d/${ostype}/lscolors.sh
# shellcheck disable=SC2139

# Skip all for non-interactive shells.
[[ "$-" = *i* ]] && [ -t 0 ] || return 0

##
## color-ls For Linux
##

# ls options
ls_options="-Fq"
[ ${UID} -eq 0 ] &&
ls_options="-A ${ls_options}" || :

# Enable color option if LS_COLORS is set.
[ -n "${LS_COLORS:-}" ] &&
ls_options="${ls_options} --color=tty" || :

# ls aliases
alias ls="ls ${ls_options}"
alias lll="ls -l --author --full-time --time-style='+%Y-%m-%d %H:%M:%S'"

# Unset shell variables.
unset ls_options

# End
return 0
