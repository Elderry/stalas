# Bash History
export HISTSIZE=1000
export HISTFILESIZE=2000

# Add some color
export LS_COLORS='ow=34'

# Aliases
ls() { command ls --color -A -I NTUSER.\* -I ntuser.\* "$@"; } #[Linux]
alias ls='ls -G' #[macOS]
alias echo='echo -e' #[Linux]
alias docker='"/mnt/c/Program Files/Docker/Docker/resources/bin/docker.exe"' #[Linux]
alias docker-compose='"/mnt/c/Program Files/Docker/Docker/resources/bin/docker-compose.exe"' #[Linux]
alias vc='open /Applications/"Visual Studio Code".app' #[macOS]

# Home Folders
export REAL_HOME=/mnt/c/Users/Ruiyang #[Linux]
export REAL_HOME=~ #[macOS]
export TS_HOME=$REAL_HOME/Projects/Tradeshift
export BWTS_HOME=$REAL_HOME/Projects/BWTS/

# Posh-Git
source $REAL_HOME/Projects/Personal/posh-git-sh/git-prompt.sh
PROMPT_COMMAND='__posh_git_ps1 "" " \[\033[01;34m\]\w\n\[\033[01;32m\]\u@\h\[\033[00m\] > "'$PROMPT_COMMAND
