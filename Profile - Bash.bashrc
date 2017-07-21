# Bash History
export HISTSIZE=1000
export HISTFILESIZE=2000

# Add some color
export LS_COLORS='ow=34' #[Linux]

# Aliases
ls() { command ls --color -A -I NTUSER.\* -I ntuser.\* "$@"; } #[Linux]
alias ls='ls -G' #[macOS]
alias echo='echo -e' #[Linux]
alias docker='"/mnt/c/Program Files/Docker/Docker/resources/bin/docker.exe"' #[Linux]
# Currently this doesn't work becase of an encoding issue: https://github.com/docker/compose/issues/2775
# alias docker-compose='"/mnt/c/Program Files/Docker/Docker/resources/bin/docker-compose.exe"' #[Linux]
alias vc='open /Applications/"Visual Studio Code".app' #[macOS]

# Home Folders
export REAL_HOME=/mnt/c/Users/Ruiyang #[Linux]
export REAL_HOME=~ #[macOS]
export TS=$REAL_HOME/Projects/Tradeshift
export BWTS=$REAL_HOME/Projects/BWTS/

# Posh-Git
# Color reference: https://help.ubuntu.com/community/CustomizingBashPrompt
BLUE='\e[1;34m'
GREEN='\e[1;32m'
RESET='\e[0m'
source $REAL_HOME/Projects/Personal/posh-git-sh/git-prompt.sh
PROMPT_COMMAND='__posh_git_ps1 "" "${BLUE}\w\n${GREEN}\u@\h${RESET} > "'

# Java
JAVA_HOME=$(/usr/libexec/java_home -v 1.8) #[macOS]
