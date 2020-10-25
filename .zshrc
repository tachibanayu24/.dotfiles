# ------------------------------
# Aliases
# ------------------------------

alias vim="nvim"
alias tree="tree -I node_modules -L 4"
alias code="code ."
alias ..='cd ..'
alias ~="cd ~"
alias mv='mv -i'
alias cp='cp -i'
alias c="clear"
alias ga='git add'
alias gc='git commit'
alias gpl='git pull'
alias gps='git push'
alias gs='git status'
alias gch="git checkout"
alias gb="git branch"
alias gl="git log"
alias dp="docker ps"
alias di="docker images"
alias dc="docker-compose"
alias to_base="cd /Users/yuto_tachibana/Projects/pring/pring-ts-base"
alias reload="exec $SHELL -l"

# ------------------------------
# PATHs
# ------------------------------

export PATH="$HOME/.rbenv/bin:$PATH"
export PATH=$PATH:./node_modules/.bin
export PATH="$HOME/bin:$PATH"

# ------------------------------
# Initialize Enviroments
# ------------------------------

eval "$(rbenv init -)"
eval "$(pyenv init -)"


# ------------------------------
# Load Themes
# ------------------------------

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# ------------------------------
# Avoiding dangerous commands
# ------------------------------

WARNING_MESSAGE="\e[31m[Dangerous Command] Check the command."

function check_dangerous_git_commands() {
  if [[ $2 = "git push origin master" ]]; then
      echo ${WARNING_MESSAGE}
      kill -INT 0
  elif [[ $2 = "git push origin develop" ]]; then
      echo ${WARNING_MESSAGE}
      kill -INT 0
  elif [[ $2 = "git push origin HEAD" ]]; then
      echo ${WARNING_MESSAGE}
      kill -INT 0
  fi
}

# ------------------------------
# display status of git
# ------------------------------

function rprompt-git-current-branch {
  local branch_name st branch_status

  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^not a git"` ]]; then
    branch_status="   no git"
  elif [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    branch_status="    %F{green}clean"
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    branch_status="  %F{red}untrack"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    branch_status="  %F{red}not stg"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    branch_status="%F{yellow}to commit"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    echo " %F{red}conflict"
    return
  else
    branch_status="%F{blue}status?"
  fi
  echo "${branch_status}"
}

CUSTOM_RPROMPT='`rprompt-git-current-branch`'

# ------------------------------
# Defining prompts, loading functions, etc.
# ------------------------------


PROMPT="%F{cyan}%n:%f%F{green}%d%f @ %F{magenta}%*%f $
"
setopt prompt_subst
autoload -Uz add-zsh-hook
add-zsh-hook preexec check_dangerous_git_commands

# ------------------------------
# Render Right Side Prompt
# ------------------------------

print_to_rprompt() {
	col=$(( COLUMNS - 8 ))
	print -Pn "\e7\e[1A\e[${col}G${CUSTOM_RPROMPT}\e8"
}

TMOUT=1
TRAPALRM() {
  print_to_rprompt
}
