# Bash History
HISTSIZE=1000
HISTFILESIZE=2000

# Colorful Prompt
PS1='$(__posh_git_ps1 "" " \[\033[01;34m\]\w\n\[\033[01;32m\]\u@\h\[\033[00m\] > ";)'

# Aliases
alias ls='ls --color=auto -A -I NTUSER.\* -I ntuser.\*' #[Linux]
alias ls='ls -G' #[macOS]
alias echo='echo -e' #[Linux]
alias vc='open /Applications/"Visual Studio Code".app' #[macOS]

# Home Folders
REAL_HOME=/mnt/c/Users/Ruiyang #[Linux]
REAL_HOME=~ #[macOS]
TS_HOME=$REAL_HOME/Projects/Tradeshift
BWTS_HOME=$REAL_HOME/Projects/BWTS/

# Posh-Git
source $REAL_HOME/Projects/Personal/posh-git-sh/git-prompt.sh
