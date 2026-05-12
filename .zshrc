# ------------------------------
# Zsh基本設定
# ------------------------------

# History設定
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS

# ディレクトリ移動
setopt AUTO_CD              # cdなしでディレクトリ移動
setopt AUTO_PUSHD           # cd履歴をスタックに保存
setopt PUSHD_IGNORE_DUPS    # 重複したディレクトリをスタックに追加しない

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

# カスタムプロンプトテーマの読み込み
source ${ZDOTDIR:-$HOME}/.tachibanayu24.zsh-theme

# 補完設定
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
if (( $+commands[fzf] )); then
  # Recommended fzf-tab configuration (per https://github.com/Aloxaf/fzf-tab)
  zstyle ':completion:*:git-checkout:*' sort false
  zstyle ':completion:*:descriptions' format '[%d]'
  [[ -n ${LS_COLORS-} ]] && zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
  zstyle ':completion:*' menu no
  zstyle ':fzf-tab:*' use-fzf-default-opts yes
  zstyle ':fzf-tab:*' switch-group '<' '>'
  zstyle ':fzf-tab:*' fzf-flags --bind=tab:accept
  (( $+functions[enable-fzf-tab] )) && enable-fzf-tab
  if (( $+commands[eza] )); then
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
  else
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 $realpath'
  fi
fi
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
alias ls='eza --icons --git'
alias ll='eza -l --icons --git'
alias la='eza -la --icons --git'
alias lt='eza -T -L 2 --icons --git'    # ツリー、深さ 2
alias lta='eza -Ta -L 2 --icons --git'  # ツリー + hidden、深さ 2
alias ltt='eza -T -L 3 --icons --git'   # ツリー、深さ 3
alias ltta='eza -Ta -L 3 --icons --git' # ツリー + hidden、深さ 3
alias mv='mv -i'
alias cp='cp -i'
alias mkdir='mkdir -p'
alias c='clear'
alias g='git'
alias vim='nvim'
alias cat='bat'
alias grep='grep --color=auto'
alias dc="docker compose"
alias reload='exec $SHELL -l'
alias python='python3'
alias claude-rc='claude --dangerously-load-development-channels server:cc-remote'
alias claude-yolo='claude --dangerously-skip-permissions'
alias claude-rc-yolo='claude-rc --dangerously-skip-permissions'
alias claude-yolo-rc='claude-rc --dangerously-skip-permissions'
alias ports='lsof -iTCP -sTCP:LISTEN -n -P'  # listen 中のポートと PID を一覧


# tree関数（除外パターンと深さを指定）。eza バックエンド。
# 使い方: tree                    → depth 2、フィルタなし
#         tree node_modules       → depth 2、node_modules を除外
#         tree node_modules 3     → depth 3、node_modules を除外
tree() {
  local depth="${2:-2}"
  if [[ -n "$1" ]]; then
    eza -T -L "$depth" -I "$1" --icons --git
  else
    eza -T -L "$depth" --icons --git
  fi
}

# ------------------------------
# PATH設定
# ------------------------------

export PATH="$PATH:/opt/homebrew/bin"
export PATH=$PATH:./node_modules/.bin
export PATH="$HOME/bin:$PATH"
export CLOUDSDK_PYTHON=/usr/local/bin/python3
export PATH="$PATH:$HOME/flutter-sdk/flutter/bin"
export PATH=~/.npm-global/bin:$PATH
export N_PREFIX=$HOME/.n
export PATH=$N_PREFIX/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"

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

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/yuto/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/yuto/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/yuto/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/yuto/google-cloud-sdk/completion.zsh.inc'; fi

# Added by Antigravity
export PATH="/Users/yuto/.antigravity/antigravity/bin:$PATH"
