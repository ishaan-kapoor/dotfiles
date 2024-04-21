# Setup fzf
# ---------
if [[ ! "$PATH" == */home/ishaan/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/ishaan/.fzf/bin"
fi

eval "$(fzf --bash)"

_fzf_setup_completion path v
_fzf_setup_completion dir dora

# -- Use fd instead of fzf --
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'tree -L 4 -C {} | head -200'"
export FZF_DEFAULT_OPTS="
  --color=fg:-1,fg+:#d0d0d0,bg:-1,bg+:#262626
  --color=hl:#5f87af,hl+:#5fd7ff,info:#afaf87,marker:#87ff00
  --color=prompt:#d7005f,spinner:#af5fff,pointer:#af5fff,header:#87afaf
  --color=border:#262626,label:#aeaeae,query:#d9d9d9
  --border='rounded' --border-label='' --preview-window='border-rounded' --prompt='> '
  --marker='󰛂' --pointer='' --separator='' --scrollbar='|'
  --info='right'"

_fzf_compgen_path() { fd --hidden --exclude .git . "$1"; }
_fzf_compgen_dir() { fd --type=d --hidden --exclude .git . "$1"; }
