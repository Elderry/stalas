
### Custom configuration for Linux ###

# Disable colored background for ls in WSL
export LS_COLORS='ow=34'

# Aliases
ls() { command ls --color=auto -I NTUSER.\* -I ntuser.\* "$@"; }

# AutoJump
# https://github.com/wting/autojump/issues/568
if [[ -f /usr/share/autojump/autojump.bash ]]; then
    . /usr/share/autojump/autojump.bash
fi
