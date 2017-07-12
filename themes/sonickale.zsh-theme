#!/usr/bin/env zsh 
#local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"#
# Based on sonic radish Geoffrey Grosenbach's peepcode zsh theme from
# https://github.com/topfunky/zsh-simple
#

if [[ -z $ZSH_THEME_ADMIN_PREFIX ]]; then
    ZSH_THEME_ADMIN_PREFIX='☁'
fi

setopt promptsubst

autoload -U add-zsh-hook
ROOT_ICON_COLOR=$FG[111]
MACHINE_NAME_COLOR=$FG[208]
PROMPT_SUCCESS_COLOR=$FG[56]
PROMPT_FAILURE_COLOR=$FG[124]
PROMPT_VCS_INFO_COLOR=$FG[242]
PROMPT_PROMPT=$FG[208]
GIT_DIRTY_COLOR=$FG[124]
GIT_CLEAN_COLOR=$FG[148]
GIT_PROMPT_INFO=$FG[148]

# Hash

if [[ $EUID -ne 0 ]] ; then
	USER_ICON="%(?,%{$PROMPT_SUCCESS_COLOR%} ☺ %{$reset_color%},%{$PROMPT_FAILURE_COLOR%} ☹ %{$reset_color%})"
elif [[ $EUID == 0 ]] ; then
	USER_ICON="$fg_bold[red]%}$ZSH_THEME_ADMIN_PREFIX{$reset_color%} "
fi
git_repo_path() {
  git rev-parse --git-dir 2>/dev/null
}

git_commit_id() {
  git rev-parse --short HEAD 2>/dev/null
}

git_mode() {
  if [[ -e "$repo_path/BISECT_LOG" ]]; then
    echo "+bisect"
  elif [[ -e "$repo_path/MERGE_HEAD" ]]; then
    echo "+merge"
  elif [[ -e "$repo_path/rebase" || -e "$repo_path/rebase-apply" || -e "$repo_path/rebase-merge" || -e "$repo_path/../.dotest" ]]; then
    echo "+rebase"
  fi
}


git_prompt() {
  local cb=$(git_current_branch)
  if [ -n "$cb" ]; then
    local repo_path=$(git_repo_path)
    echo " %{$fg_bold[grey]%}$cb %{$fg[white]%}$(git_commit_id)%{$reset_color%}$(git_mode)$(git_dirty)"
  fi
}

git_dirty() {
  if [[  `git ls-files -m` != "" ]]; then
    echo " %{$fg_bold[red]%}✗ %{$reset_color%}"
  fi
}

PROMPT='
%{$MACHINE_NAME_COLOR%}%m➜  %{$reset_color%}%{$PROMPT_SUCCESS_COLOR%}%c%{$reset_color%}
$USER_ICON '

RPROMPT='%{$fg[white]%} $(git_prompt) %{$reset_color%} '


