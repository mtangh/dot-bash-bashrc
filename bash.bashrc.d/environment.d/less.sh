# ${bashbashrc_dir}/environment.d/less.sh

# less installed ?
[ -x "$(type -P less)" ] ||
  return 0

# Default options for less
LESS="-LMRgi -z-2 -x4"

# Exporting LESS variables to the environment
export LESS

# Charset for LESS
LESSCHARSET=utf-8
export LESSCHARSET

# Color settings when there is no interactive shell
if [ -t 0 ]
then
  LESS_TERMCAP_mb=$(printf '\e[1;31m');     export LESS_TERMCAP_mb
  LESS_TERMCAP_md=$(printf '\e[1;34m');     export LESS_TERMCAP_md
  LESS_TERMCAP_me=$(printf '\e[0m');        export LESS_TERMCAP_me
  LESS_TERMCAP_so=$(printf '\e[1;33;47m');  export LESS_TERMCAP_so
  LESS_TERMCAP_se=$(printf '\e[0m');        export LESS_TERMCAP_se
  LESS_TERMCAP_us=$(printf '\e[4;36m');     export LESS_TERMCAP_us
  LESS_TERMCAP_ue=$(printf '\e[0m');        export LESS_TERMCAP_ue
fi

# less preprocessor
if [ -x "$(type -P lesspipe)" ]
then
  eval "$(SHELL=/bin/sh lesspipe)"
elif [ -x "$(type -P lesspipe.sh)" ]
then
  LESSOPEN="$(type -P lesspipe.sh)"
  LESSOPEN="|${LESSOPEN} %s"
  export LESSOPEN
fi

# End
return 0
