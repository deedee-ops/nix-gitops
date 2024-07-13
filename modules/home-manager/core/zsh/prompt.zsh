function preexec() {
  timer=$(($(gdate +%s%0N 2> /dev/null || date +%s%0N)/1000000))
}

function precmd() {
  if [ $timer ]; then
    now=$(($(gdate +%s%0N 2> /dev/null || date +%s%0N)/1000000))
    elapsed=$(($now-$timer))

    export RPROMPT="%F{red}%(?..[%?] )%F{cyan}${elapsed}ms %{$reset_color%}"
    unset timer
  fi
}

function nix_prompt() {
  if [ -n "${IN_NIX_SHELL}" ]; then
    local nix_packages="";
    if [ -n "${NIX_SHELL_PACKAGES}" ]; then
      nix_packages=": ${NIX_SHELL_PACKAGES}"
    fi
    echo "%{$fg[green]%}($fg[red]nix${nix_packages}$fg[green])%{$reset_color%}"
  fi
}

setopt PROMPT_SUBST

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

local host="$(hostname -s 2> /dev/null || cat /etc/hostname)"

if [ "$UID" = "0" ]; then
  PROMPT='%{$bg[red]$fg[black]%} ${host:u} %{$reset_color%}$(nix_prompt)$(git_custom_status)%{$fg[red]%}[%~% ]%{$reset_color%}%B%(!.#.$)%b '
else
  PROMPT='%{$bg[${PROMPT_HOSTNAME_COLOR:-magenta}]$fg[black]%} ${host:u} %{$reset_color%}$(nix_prompt)$(git_custom_status)%{$fg[cyan]%}[%~% ]%{$reset_color%}%B%(!.#.$)%b '
fi
