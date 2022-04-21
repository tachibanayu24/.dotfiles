# ------------------------------
# Aliases
# ------------------------------

alias vim='nvim'
alias tree='(){tree -I $1 -L $2}'
alias ..='cd ..'
alias ~='cd ~'
alias mv='mv -i'
alias cp='cp -i'
alias c='clear'
alias gpl='git pull'
alias gps='git push'
alias gs='git status'
alias gc='git checkout'
alias gb='git branch'
alias gl='git log'
alias g-empty-commit='(){git commit --allow-empty -m $1}'
alias dc="docker compose"
alias workside='cd /Users/yuto/Workspace/workside'
alias first-automation='cd /Users/yuto/Workspace/first-automation'
alias tachibanayu24='cd /Users/yuto/Workspace/tachibanayu24'
alias reload='exec $SHELL -l'

# ------------------------------
# PATHs
# ------------------------------

export PATH="$HOME/.rbenv/bin:$PATH"
export PATH=$PATH:./node_modules/.bin
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.pyenv/bin:$PATH"
export CLOUDSDK_PYTHON="/usr/local/opt/python@3.8/bin/python3"




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
# Avoiding commands
# ------------------------------

WARNING_MESSAGE="\e[33m[Warn] If you want to run this command, escape it with a '\'."

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

function check_opening_vscode() {
  if [ $2 = "code /" ] || [ $2 = "code ," ] || [ "$2" = "code ,." ] || [ "$2" = "code .," ]; then
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
add-zsh-hook preexec check_opening_vscode

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


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/yuto/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/yuto/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/yuto/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/yuto/google-cloud-sdk/completion.zsh.inc'; fi
