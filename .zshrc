# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && . "$HOME/.fig/shell/zshrc.pre.zsh"
# ------------------------------
# Fig pre block
# ------------------------------

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
export PATH="$PATH:/Users/yuto/flutter-sdk/flutter/bin"


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
# Prompt
# @see https://spaceship-prompt.sh/options
# ------------------------------

SPACESHIP_PROMPT_ORDER=(dir git node gcloud exec_time line_sep jobs exit_code char)
SPACESHIP_PACKAGE_SHOW=false
SPACESHIP_CHAR_SYMBOL="> "
SPACESHIP_GIT_PREFIX=""
SPACESHIP_AWS_PREFIX=""
SPACESHIP_GCLOUD_PREFIX=""

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
# Defining prompts, loading functions, etc.
# ------------------------------

setopt prompt_subst
autoload -Uz add-zsh-hook
add-zsh-hook preexec check_dangerous_git_commands
add-zsh-hook preexec check_opening_vscode


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/yuto/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/yuto/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/yuto/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/yuto/google-cloud-sdk/completion.zsh.inc'; fi

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && . "$HOME/.fig/shell/zshrc.post.zsh"
