# ${bashbashrc_dir}/environment.d/${ostype}/diff.sh
# shellcheck disable=SC2139

# Skip all for non-interactive shells.
[[ "$-" = *i* ]] && [ -t 0 ] || return 0

# If gcc is installed
if [ -x "$(type -P gcc)" ]
then

  # GCC color configuration
  GCC_COLORS=""
  GCC_COLORS="${GCC_COLORS}${GCC_COLORS:+:}error=01;31"
  GCC_COLORS="${GCC_COLORS}${GCC_COLORS:+:}warning=01;33"
  GCC_COLORS="${GCC_COLORS}${GCC_COLORS:+:}note=01;36"
  GCC_COLORS="${GCC_COLORS}${GCC_COLORS:+:}range1=32"
  GCC_COLORS="${GCC_COLORS}${GCC_COLORS:+:}range2=34"
  GCC_COLORS="${GCC_COLORS}${GCC_COLORS:+:}locus=01"
  GCC_COLORS="${GCC_COLORS}${GCC_COLORS:+:}quote=01"
  GCC_COLORS="${GCC_COLORS}${GCC_COLORS:+:}path=01;36"
  GCC_COLORS="${GCC_COLORS}${GCC_COLORS:+:}fixit-insert=32"
  GCC_COLORS="${GCC_COLORS}${GCC_COLORS:+:}fixit-delete=31"
  GCC_COLORS="${GCC_COLORS}${GCC_COLORS:+:}diff-filename=01"
  GCC_COLORS="${GCC_COLORS}${GCC_COLORS:+:}diff-hunk=32"
  GCC_COLORS="${GCC_COLORS}${GCC_COLORS:+:}diff-delete=31"
  GCC_COLORS="${GCC_COLORS}${GCC_COLORS:+:}diff-insert=32"
  GCC_COLORS="${GCC_COLORS}${GCC_COLORS:+:}type-diff=01;32"
  GCC_COLORS="${GCC_COLORS}${GCC_COLORS:+:}fnname=01;32"
  GCC_COLORS="${GCC_COLORS}${GCC_COLORS:+:}targs=35"
  GCC_COLORS="${GCC_COLORS}${GCC_COLORS:+:}valid=01;31"
  GCC_COLORS="${GCC_COLORS}${GCC_COLORS:+:}invalid=01;32"

  # Export gcc color configuration to environment.
  export GCC_COLORS

fi &>/dev/null || :

# End
return 0
