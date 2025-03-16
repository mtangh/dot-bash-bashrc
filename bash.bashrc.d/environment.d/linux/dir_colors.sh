# ${bashbashrc_dir}/environment.d/${ostype}/dir_colorls_config.sh
# shellcheck disable=SC2139

# Skip all for non-interactive shells.
[[ "$-" = *i* ]] && [ -t 0 ] || return 0

##
## color-ls For Linux
##

dir_colors=""

# Lookup the dircolors setting.
for dir_colors in \
"${bashrc_userdir:-X}"/{,.}dir{_,}colors{.d/$TERM,.$TERM,} \
"${bashrclocaldir:-X}"/{environment.d/,}DIR_COLORS{.$TERM,}
do
  [ -f "${dir_colors}" -a -r "${dir_colors}" ] &&
  break || dir_colors=""
done &>/dev/null || :

# Fallback: Apply the default settings.
if [ -z "${dir_colors:-}" -a -n "${BASH_SOURCE:-}" ]
then
  color_sz="$(/usr/bin/tty -s && /usr/bin/tput color)" || :
  [ -f "${BASH_SOURCE%/*}/DIR_COLORS.${TERM}" ] &&
  dir_colors="${BASH_SOURCE%/*}/DIR_COLORS.${TERM}" ||
  [ -f "${BASH_SOURCE%/*}/DIR_COLORS.${color_sz:-}color" ] &&
  dir_colors="${BASH_SOURCE%/*}/DIR_COLORS.${color_sz}color" ||
  dir_colors="${BASH_SOURCE%/*}/DIR_COLORS" || :
  unset color_sz
fi &>/dev/null || :

# ls options
ls_options="-Fq"
[ ${UID} -eq 0 ] &&
ls_options="-A ${ls_options}" || :

# LS_COLORS setting
if [ ! -f "${dir_colors:-X}" -o ! -r "${dir_colors:-X}" ] ||
   (grep -Ei "^COLOR.*none" "${dir_colors}" &>/dev/null)
then
  # LS_COLORS No configuration file or LS_COLORS is Off
  alias ls="ls ${ls_options}"
else
  # Build the DIR_COLORS setting and
  # set it in the LS_COLORS environment variable.
  eval "$(dircolors --sh "${dir_colors}")" &&
  [ -n "${LS_COLORS:-}" ] &&
  alias ls="ls ${ls_options} --color=tty" || :
fi &>/dev/null || :
unset ls_options dir_colors

# ls aliases
alias lll="ls -l --author --full-time --time-style='+%Y-%m-%d %H:%M:%S'"

# End
return 0
