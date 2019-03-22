
source "$HOME/.zplug/init.zsh"

OHMY_ZSH_HASH="1e11a3c"
zplug "plugins/git", from:oh-my-zsh, as:plugin, at:"$OHMY_ZSH_HASH"
zplug "plugins/osx", from:oh-my-zsh, as:plugin, at:"$OHMY_ZSH_HASH"
zplug "robbyrussell/oh-my-zsh", use:"lib/*.zsh", at:"$OHMY_ZSH_HASH"

zplug "zsh-users/zsh-autosuggestions", as:plugin, at:"v0.5.0", defer:2
zplug "zsh-users/zsh-syntax-highlighting", as:plugin, at:"a109ab5", defer:2
zplug "zsh-users/zaw", ignore:"zaw-launcher.zsh", at:"c8e6e2a"
zplug "bhilburn/powerlevel9k", as:theme, at:"v0.6.7"

DOTFILES_ZSH="$HOME/dotfiles/zsh"
zplug "$DOTFILES_ZSH", from:local, use:"*.zsh"

zplug load