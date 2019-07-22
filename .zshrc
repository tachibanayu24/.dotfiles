# Alias
alias vim="nvim"
alias tree="tree -I node_modules -L 5"
alias code="code ."
alias ..='cd ..'
alias ~="cd ~"
alias mv='mv -i'
alias cp='cp -i'
alias c="clear"
alias gs='git status'
alias gc="git checkout"
alias gb="git branch"
alias gl="git log"
alias dp="docker ps"
alias di="docker images"
alias dcom="docker-compose" # dcにするとcdとうち間違えたときめんどくさい

# PATH
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH=$PATH:./node_modules/.bin

# Initialize Enviromnent
eval "$(rbenv init -)"
eval "$(pyenv init -)"

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi


# プロンプト
PROMPT="%F{cyan}%n:%f%F{green}%d%f $
"

# git push origin master回避
function disable_git_push_origin_master() {
  if [[ $2 = "git push origin master" ]]; then
      echo "Please stop push to master😨"
      kill -INT 0
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook preexec disable_git_push_origin_master

# gitのstatusを色付きで表示する
function rprompt-git-current-branch {
  local branch_name st branch_status

  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^not a git"` ]]; then
    # gitなし
    branch_status="no git"
  elif [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    # 全てcommitされてクリーンな状態
    branch_status="%F{green}clean"
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    # gitに管理されていないファイルがある状態
    branch_status="%F{red}untrack"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    # git addされていないファイルがある状態
    branch_status="%F{red}not stg"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    # git commitされていないファイルがある状態
    branch_status="%F{yellow}to commit"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    # コンフリクトが起こった状態
    echo "%F{red}conflict"
    return
  else
    branch_status="%F{blue}status?"
  fi
  echo "🐥 ${branch_status}"
}

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst

# プロンプトの右側(RPROMPT)にメソッドの結果を表示させる
RPROMPT='`rprompt-git-current-branch`'
