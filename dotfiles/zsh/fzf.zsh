

# Key for colours when using solarized-dark theme
#
# 1 - red
# 2 - yellow
# 3 - orange
# 4 - blue
# 5 - pink
# 6 - torquise
# 7 - white
# 8 - invisible

red="1"
yellow="2"
orange="3"
blue="4"
pink="5"
torquise="6"
white="7"
invisible="8"

export FZF_DEFAULT_OPTS="
    --height 60% --layout=reverse
    --color hl:$pink,hl+:$pink,fg+:$white,bg+:10
    --color info:$torquise,prompt:$yellow,pointer:$red,marker:$red,spinner:$yellow,header:$blue
"

# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="$PATH:/usr/local/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/usr/local/opt/fzf/shell/key-bindings.zsh"

    