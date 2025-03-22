# ${bashbashrc_dir}/environment.d/dircolors.sh

# Skip all for non-interactive shells.
[[ "$-" = *i* ]] && [ -t 0 ] || return 0

##
## LS_COLORS
##

dir_colors=""

# If the dircolors command exists,
# Locate the DIR_COLORS file and apply its contents.
if [ -x "$(type -P dircolors)" ]
then

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

fi

# If LS_COLORS is not set,
# the default settings will be applied.
if [ -z "${LS_COLORS:-}" ]
then
  LS_COLORS=""
  LS_COLORS="${LS_COLORS:-}no=00:fi=00:rs=0:di=01;34:ln=01;36:"
  LS_COLORS="${LS_COLORS:-}so=01;35:do=01;35:pi=33;40:"
  LS_COLORS="${LS_COLORS:-}bd=34;43:cd=31;43:"
  LS_COLORS="${LS_COLORS:-}ex=32:mi=01;37;41:or=01;05;37;41:"
  LS_COLORS="${LS_COLORS:-}su=01;32;41:sg=01;32;45:"
  LS_COLORS="${LS_COLORS:-}tw=34;41:ow=34;45:st=37;44:"
  export LS_COLORS
fi

# Unset shell variables.
unset dir_colors

# End
return 0
