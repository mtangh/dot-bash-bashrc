# ${bashbashrc_dir}/environment.d/${ostype}/grep.sh

# Skip all for non-interactive shells.
[[ "$-" = *i* ]] && [ -t 0 ] || return 0

# If the '--color' option is supported
if (grep --color=auto '' /dev/null &>/dev/null) ||
   [ $? -le 1 ]
then

  # Grep color configuration
  GREP_COLOR="1;33;44"
  export GREP_COLOR

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
