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
alias g='git'
alias vim='nvim'
alias cat='bat'
alias tree='(){tree -I $1 -L $2}'
alias dc="docker compose"
alias reload='exec $SHELL -l'

# ------------------------------
# PATH設定
# ------------------------------

export PATH="$PATH:/opt/homebrew/bin"
export PATH=$PATH:./node_modules/.bin
export PATH="$HOME/bin:$PATH"
export CLOUDSDK_PYTHON=/usr/bin/python3
export PATH="$PATH:/Users/yuto/flutter-sdk/flutter/bin"
export PATH=~/.npm-global/bin:$PATH

# ------------------------------
# 外部ツール設定
# ------------------------------

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Google Cloud SDK
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

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

# 危険なrmコマンドを防止
function check_dangerous_rm_commands() {
  # ホームディレクトリやルートディレクトリの削除を防ぐ
  if [[ $2 =~ "rm -rf /" ]] || [[ $2 =~ "rm -fr /" ]] || [[ $2 =~ "rm -f -r /" ]] || [[ $2 =~ "rm -r -f /" ]]; then
      echo ${WARNING_MESSAGE}
      kill -INT 0
  elif [[ $2 =~ "rm -rf ~" ]] || [[ $2 =~ "rm -fr ~" ]] || [[ $2 =~ "rm -f -r ~" ]] || [[ $2 =~ "rm -r -f ~" ]]; then
      echo ${WARNING_MESSAGE}
      kill -INT 0
  elif [[ $2 =~ "rm -rf /*" ]] || [[ $2 =~ "rm -fr /*" ]] || [[ $2 =~ "rm -f -r /*" ]] || [[ $2 =~ "rm -r -f /*" ]]; then
      echo ${WARNING_MESSAGE}
      kill -INT 0
  elif [[ $2 =~ "rm -rf \$HOME" ]] || [[ $2 =~ "rm -fr \$HOME" ]] || [[ $2 =~ "rm -f -r \$HOME" ]] || [[ $2 =~ "rm -r -f \$HOME" ]]; then
      echo ${WARNING_MESSAGE}
      kill -INT 0
  elif [[ $2 =~ "rm -rf ." ]] && [[ $PWD = "/" ]]; then
      echo ${WARNING_MESSAGE}
      kill -INT 0
  elif [[ $2 = "rm -rf *" ]] && [[ $PWD = "/" ]]; then
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
add-zsh-hook preexec check_dangerous_rm_commands
add-zsh-hook preexec check_opening_vscode
