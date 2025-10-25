# ------------------------------
# Zsh基本設定
# ------------------------------

# Historyの重複を削除
setopt HIST_IGNORE_ALL_DUPS

# Emacsキーバインド
bindkey -e

# パス区切り文字をWORDCHARSから削除
WORDCHARS=${WORDCHARS//[\/]}

# ------------------------------
# ZIM Framework 初期化
# ------------------------------

ZIM_CONFIG_FILE=${ZDOTDIR:-$HOME}/.zimrc
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# モジュールが不足している場合はインストールし、init.zshを更新
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source /opt/homebrew/opt/zimfw/share/zimfw.zsh init
fi
source ${ZIM_HOME}/init.zsh

# ------------------------------
# ZIM モジュール設定
# ------------------------------

# zsh-autosuggestions
# 最後のモジュールの場合、自動ウィジェット再バインドを無効化
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# zsh-syntax-highlighting
# 使用するハイライターを設定
# @see https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# ------------------------------
# Post-init モジュール設定
# ------------------------------

# zsh-history-substring-search
# 矢印キーで履歴検索を可能にする
zmodload -F zsh/terminfo +p:terminfo
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key

# ------------------------------
# エイリアス
# ------------------------------

alias ..='cd ..'
alias ~='cd ~'
alias la='ls -la'
alias ll='ls -l'
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
alias vim='nvim'
alias cat='bat'
alias tree='(){tree -I $1 -L $2}'
alias dc="docker compose"
alias workside='cd /Users/yuto/Workspace/workside'
alias first-automation='cd /Users/yuto/Workspace/first-automation'
alias tachibanayu24='cd /Users/yuto/Workspace/tachibanayu24'
alias reload='exec $SHELL -l'

# ------------------------------
# PATH設定
# ------------------------------

export PATH="$PATH:/opt/homebrew/bin"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH=$PATH:./node_modules/.bin
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.pyenv/bin:$PATH"
export CLOUDSDK_PYTHON=/usr/bin/python3
export PATH="$PATH:/Users/yuto/flutter-sdk/flutter/bin"

# ------------------------------
# 言語環境初期化
# ------------------------------

# eval "$(rbenv init -)"
# eval "$(pyenv init -)"

# ------------------------------
# 外部ツール設定
# ------------------------------

# Google Cloud SDK
if [ -f '/Users/yuto/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/yuto/google-cloud-sdk/path.zsh.inc'; fi
if [ -f '/Users/yuto/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/yuto/google-cloud-sdk/completion.zsh.inc'; fi

# ------------------------------
# カスタム関数とフック
# ------------------------------

WARNING_MESSAGE="\e[33m[Warn] If you want to run this command, escape it with a '\'."

# 危険なgitコマンドを防止
function check_dangerous_git_commands() {
  if [[ $2 = "git push origin master" ]]; then
      echo ${WARNING_MESSAGE}
      kill -INT 0
  elif [[ $2 = "git push origin main" ]]; then
      echo ${WARNING_MESSAGE}
      kill -INT 0
  elif [[ $2 = "git push origin develop" ]]; then
      echo ${WARNING_MESSAGE}
      kill -INT 0
  elif [[ $2 = "git push origin staging" ]]; then
      echo ${WARNING_MESSAGE}
      kill -INT 0
  elif [[ $2 = "git push origin HEAD" ]]; then
      echo ${WARNING_MESSAGE}
      kill -INT 0
  fi
}

# 誤ったVSCode起動を防止
function check_opening_vscode() {
  if [ $2 = "code /" ] || [ $2 = "code ," ] || [ "$2" = "code ,." ] || [ "$2" = "code .," ]; then
      echo ${WARNING_MESSAGE}
      kill -INT 0
  fi
}

setopt prompt_subst
autoload -Uz add-zsh-hook
add-zsh-hook preexec check_dangerous_git_commands
add-zsh-hook preexec check_opening_vscode
