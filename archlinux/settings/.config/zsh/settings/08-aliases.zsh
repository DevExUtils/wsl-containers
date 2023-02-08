#!/bin/zsh

# Aliases

# File related commands
alias cat="bat -p"

# Exa
alias l="exa --long --header --all --sort type --git"
alias ls="exa --long --header --all --sort type --git --group"

# Zoxide
alias j="__zoxide_zi"

# Python
alias pip="python -m pip"

# wget default save file in data folder instead of home
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"

# FZF Paru 
##  Search and install packages with fzf
pi() { 
	SELECTED_PKGS="$(paru -Slq | fzf --header='Install packages' -m --preview 'paru -Si {1}')"
	if [ -n "$SELECTED_PKGS" ]; then
		paru -S "$SELECTED_PKGS"
	fi
}

## Search and remove packages with fzf
pr() { 
	SELECTED_PKGS="$(paru -Qsq | fzf --header='Remove packages' -m --preview 'paru -Si {1}')"
	if [ -n "$SELECTED_PKGS" ]; then
		paru -Rns "$SELECTED_PKGS"
	fi
}

# Helps quickly search in $PATH to validate if folder is available
check-path() { 
  if [[ "$#" -eq 0 ]]; then
    echo -e ${PATH//:/\\n} | fzf --header='Directories in PATH'
  elif [[ "$#" -eq 1 ]]; then
    echo -e ${PATH//:/\\n} | fzf -q ${1} --select-1 --exit-0 --header='Directories matching search word in PATH'
  fi
}