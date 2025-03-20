# ${bashbashrc_dir}/environment.d/dircolors.sh

# Skip all for non-interactive shells.
[[ "$-" = *i* ]] && [ -t 0 ] || return 0

##
## LS_COLORS
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
  /usr/bin/tty -s &&
  color_sz="$(/usr/bin/tput colors)" &>/dev/null ||
  color_sz=""
  if [ -f "${BASH_SOURCE%/*}/DIR_COLORS.${TERM}" ]
  then dir_colors="${BASH_SOURCE%/*}/DIR_COLORS.${TERM}"
  elif [ -f "${BASH_SOURCE%/*}/DIR_COLORS.${color_sz:-X}color" ]
  then dir_colors="${BASH_SOURCE%/*}/DIR_COLORS.${color_sz}color"
  else dir_colors="${BASH_SOURCE%/*}/DIR_COLORS"
  fi
  unset color_sz
fi || :

# Color settings are disabled?
grep -Ei "^[[:space:]]*COLOR[[:space:]]+no(ne$|$)" \
"${dir_colors:-X}" &>/dev/null && dir_colors="" || :

# Build the DIR_COLORS setting and
# set it in the LS_COLORS environment variable.
[ -f "${dir_colors:-X}" -a -r "${dir_colors:-X}" ] &&
eval "$(dircolors --sh "${dir_colors}")" || :

# Unset shell variables.
unset dir_colors

# End
return 0
