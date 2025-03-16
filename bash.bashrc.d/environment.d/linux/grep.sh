# ${bashbashrc_dir}/environment.d/${ostype}/grep.sh

# Skip all for non-interactive shells.
[[ "$-" = *i* ]] && [ -t 0 ] || return 0

# If the '--color' option is supported
if (grep --color=auto '' /dev/null &>/dev/null) ||
   [ $? -le 1 ]
then

  # Grep color configuration
  GREP_COLORS="mt=1;34;44:ms=1;33;44:mc=1;31;44:sl=:cx=:fn=0;35:ln=1;33:bn=0:se=1;37"
  export GREP_COLORS

  # Colored GREP aliases
  alias grep="grep --color=auto"
  alias grepc="grep --color-always"
  alias egrep="egrep --color=auto"
  alias egrepc="egrep --color=always"
  alias fgrep="fgrep --color=auto"
  alias fgrepc="fgrep --color=always"

fi &>/dev/null || :

# End
return 0
