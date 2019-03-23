

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

##
# Config for powerlevel9k theme
##

ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_MODE='nerdfont-complete'

## Prompt configuration
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%F{blue}\u256D\u2500%f"
POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX="%F{blue}\u251C\u2500%f"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{blue}\u2570\uf460%f "
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)


##
# Config for zaw plugin
##

zstyle ':filter-select:highlight' selected "fg=8,bg=7"
zstyle ':filter-select:highlight' matched "fg=5,bg=8"
zstyle ':filter-select:highlight' marked "fg=6,bg=8"
zstyle ':filter-select:highlight' title "fg=4,bg=8"
zstyle ':filter-select:highlight' error "fg=1,bg=8"

zstyle ':filter-select' rotate-list yes # enable rotation for filter-select
zstyle ':filter-select' case-insensitive yes # enable case-insensitive search
zstyle ':filter-select' extended-search yes # see below
zstyle ':filter-select' hist-find-no-dups yes # ignore duplicates in history source
zstyle ':filter-select' escape-descriptions no # display literal newlines, not \n, etc
zstyle ':zaw:git-files' default zaw-callback-append-to-buffer # set default action for git-files
zstyle ':zaw:git-files' alt zaw-callback-edit-file # set the alt action for git-files


#bindkey '^@' zaw          # launch zaw with Ctrl+Space
#bindkey '^r' zaw-history  # launch zaw-history with Ctrl+R 
