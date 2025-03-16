# ${bashbashrc_dir}/environment.d/${ostype}/diff.sh
# shellcheck disable=SC2139

# Skip all for non-interactive shells.
[[ "$-" = *i* ]] && [ -t 0 ] || return 0

# If the '--color' option is supported
if (diff --color=auto - - &>/dev/null) ||
   [ $? -le 1 ]
then

  # DIFF color configuration
  DIFF_COLOR_PALETTE='--palette="hd=0;1:ad=0;32:de=1;35:ln=1;36;46p"'

  # Colored DIFF aliases
  alias diff="diff --color=auto ${DIFF_COLOR_PALETTE}"
  alias diffc="diff --color=always ${DIFF_COLOR_PALETTE}"

fi &>/dev/null || :

# End
return 0
