# ${bashbashrc_dir}/02_bash_options.sh
[ -n "$BASH" ] ||  return 0

## Shell options

# The user file-creation mask is set to MODE.
if [ ${UID:-0} -gt 99 -a "$(id -un)" = "$(id -gn)" ]
then umask 0002
else umask 0022
fi

# Do not produce core dumps
ulimit -c 0

# Bash checks that a command found in the hash table exists before
# trying to execute it.
shopt -s checkhash

# Bash lists the status of any stopped and running jobs before
# exiting an interactive shell.
if ${teatsver} -ge 4.0
then
  shopt -s checkjobs
fi

# Bash checks the window size after each external (non-builtin)
# command and, if necessary, updates the values of LINES and
# COLUMNS.
shopt -s checkwinsize

# Shell error messages are written in the standard GNU error message
# format.
shopt -s gnu_errfmt

# Bash will attempt to perform hostname completion when a word
# containing a @ is being completed (see Completing under
# READLINE above).
shopt -s hostcomplete

# The source (.) builtin uses the value of PATH to find the directory
# containing the file supplied as an argument.
shopt -u sourcepath

# Bash will not attempt to search the PATH for possible completions
# when completion is attempted on an empty line.
shopt -s no_empty_cmd_completion

# The history list is appended to the file named by the value of the
# HISTFILE variable when the shell exits, rather than overwriting
# the file.
shopt -s histappend

# The results of history substitution are not immediately
# passed to the shell parser.
shopt -s histverify

# Bash attempts to save all lines of a multiple-line command in the
# same history entry.
shopt -s cmdhist

# Multi-line commands are saved to the history with embedded newlines
# rather than using semicolon separators where possible.
shopt -s lithist

# Controls the action of an interactive shell on receipt of an EOF
# character as the sole input.  If set, the value is the number of
# consecutive EOF characters which must be typed as the first
# characters on an input line before bash exits.
# If the variable exists but does not have a numeric value, or has no
# value, the default value is 10.
# If it does not exist, EOF signifies the end of input to the shell.
IGNOREEOF=10

## History

# A colon-separated list of values controlling how commands are saved
# on the history list.
# - ignorespace
#  lines which begin with a space character are not saved in the
#  history list.
# - ignoredups
#  causes lines which match the previous history entry to not be saved.
# - ignoreboth
#  shorthand for ‘ignorespace’ and ‘ignoredups’.
# - erasedups
#  causes all previous lines matching the current line to be removed
#  from the history list before that line is saved.
HISTCONTROL='ignoreboth:erasedups'

# The maximum number of commands to remember on the history list. If
# the value is 0, commands are not saved in the history list. Numeric
# values less than zero result in every command being saved on the
# history list (there is no limit).
# The shell sets the default value to 500 after reading any startup
# files.
if [ ${UID:-0} -gt 99 ]
then HISTSIZE=1024
else HISTSIZE=32
fi

# The maximum number of lines contained in the history file.
# When this variable is assigned a value, the history file is
# truncated, if necessary, to contain no more than that number of
# lines by removing the oldest entries. The history file is also
# truncated to this size after writing it when a shell exits.  If the
# value is 0, the history file is truncated to zero size. Non-numeric
# values and numeric values less than zero inhibit truncation.  The
# shell sets the default value to the value of HISTSIZE after reading
# any startup files.
if [ ${UID:-0} -gt 99 ]
then HISTFILESIZE=1024
else HISTFILESIZE=0
fi

# A colon-separated list of patterns used to decide which command
# lines should be saved on the history list. Each pattern is anchored
# at the beginning of the line and must match the complete line (no
# implicit ‘*’ is appended). Each pattern is tested against the line
# after the checks specified by HISTCONTROL are applied. In addition
# to the normal shell pattern matching characters, ‘&’ matches the
# previous history line. ‘&’ may be escaped using a backslash; the
# backslash is removed before attempting a match. The second and
# subsequent lines of a multi-line compound command are not tested,
# and are added to the history regardless of the value of HISTIGNORE.
HISTIGNORE='history:hist:exit'

# If this variable is set and not null, its value is used as a format
# string for strftime to print the time stamp associated with each
# history entry displayed by the history builtin.  If this variable is
# set, time stamps are written to the history file so they may be
# preserved across shell sessions. This uses the history comment
# character to distinguish timestamps from other history lines.
HISTTIMEFORMAT='%Y-%m-%dT%T%z '

# end
return 0
