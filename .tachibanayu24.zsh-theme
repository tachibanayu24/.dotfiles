# vim:et sts=2 sw=2 ft=zsh
#
# tachibanayu24 theme
# Based on Zim's sorin theme with newline before command prompt
#
# Requires the `prompt-pwd` and `git-info` zmodules to be included in the .zimrc file.

typeset -g VIRTUAL_ENV_DISABLE_PROMPT=1

setopt nopromptbang prompt{cr,percent,sp,subst}

zstyle ':zim:prompt-pwd:fish-style' dir-length 1

typeset -gA git_info
if (( ${+functions[git-info]} )); then
  # Set git-info parameters.
  zstyle ':zim:git-info' verbose yes
  zstyle ':zim:git-info:action' format '%F{default}:%F{1}%s'
  zstyle ':zim:git-info:ahead' format ' %F{5}⬆'
  zstyle ':zim:git-info:behind' format ' %F{5}⬇'
  zstyle ':zim:git-info:branch' format ' %F{2} %b'
  zstyle ':zim:git-info:commit' format ' %F{3}%c'
  zstyle ':zim:git-info:indexed' format ' %F{2}✚'
  zstyle ':zim:git-info:unindexed' format ' %F{4}✱'
  zstyle ':zim:git-info:position' format ' %F{5}%p'
  zstyle ':zim:git-info:stashed' format ' %F{6}✭'
  zstyle ':zim:git-info:untracked' format ' %F{default}◼'
  zstyle ':zim:git-info:keys' format \
    'status' '%b$(coalesce %p %c)%s%A%B%S%i%I%u'

  # Add hook for calling git-info before each command.
  autoload -Uz add-zsh-hook && add-zsh-hook precmd git-info
fi

# Precmd hook to display first line with right-aligned git info
_prompt_tachibanayu24_precmd() {
  # Calculate lengths without color codes
  local path_part="$(prompt-pwd)"
  local ssh_part="${SSH_TTY:+"%n@%m "}"
  local git_part="${(e)git_info[status]}"

  # Get plain text lengths by expanding prompt sequences and removing ANSI codes
  local ssh_len=${#${(%):-%n@%m }}
  [[ -z "$SSH_TTY" ]] && ssh_len=0

  local path_len=${#path_part}

  # Remove prompt color codes from git_part to calculate length
  # This removes %F{n}, %f, %B, %b etc.
  local git_plain="${git_part}"
  git_plain="${git_plain//\%F\{[0-9]##\}}"
  git_plain="${git_plain//\%(f|B|b|K\{*\})}"
  local git_len=${#git_plain}

  # Calculate spacing
  local spacing=$((COLUMNS - ssh_len - path_len - git_len - 1))

  if [[ -n "$git_part" && $spacing -gt 1 ]]; then
    # Print with spacing for right alignment
    print -P "%B%F{4}${ssh_part}${path_part}%f%b${(l:spacing:: :)}%B${git_part}%f%b"
  else
    # Not enough space, just print path
    print -P "%B%F{4}${ssh_part}${path_part}%f%b"
  fi
}

# Add precmd hook
autoload -Uz add-zsh-hook
add-zsh-hook precmd _prompt_tachibanayu24_precmd

# Define prompts.
PS1='%(!.%F{1}#%f.%F{2}%%%f) '
RPS1='${VIRTUAL_ENV:+"%F{3}(${VIRTUAL_ENV:t})"}%(?:: %F{1}✘ %?)'
SPROMPT='zsh: correct %F{1}%R%f to %F{2}%r%f [nyae]? '
