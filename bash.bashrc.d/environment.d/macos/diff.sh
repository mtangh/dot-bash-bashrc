# ${bashbashrc_dir}/environment.d/${ostype}/diff.sh

# Skip all for non-interactive shells.
[[ "$-" = *i* ]] && [ -t 0 ] || return 0

# If the '--color' option is supported
if (diff --color=auto - - &>/dev/null) ||
   [ $? -le 1 ]
then

  # DIFF color configuration
  DIFFCOLORS="0;32:0;35"
  export DIFFCOLORS

  # Colored DIFF aliases
  alias diff="diff --color=auto"
  alias diffc="diff --color-always"

fi &>/dev/null || :

# End
return 0
