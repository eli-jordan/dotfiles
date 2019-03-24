
# Bootstrap script for use with YADM (Yet Another Dotfiles Manager) 
# Ref: https://github.com/TheLocehiliosan/yadm

install_homebrew() {
	/usr/bin/ruby -e \
	  "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"	
}

install_homebrew

brew install bat
brew install zsh
brew install tree
brew install scala
brew install sbt
brew install jq
brew install kubernetes-cli
brew install exa
brew install kubectx

brew install fzf
$(brew --prefix)/opt/fzf/install

# Install nerdfonts for use with the terminal
brew tap caskroom/fonts
brew cask install font-meslo-nerd-font