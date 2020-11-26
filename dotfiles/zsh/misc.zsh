
export PATH="$HOME/bin:$HOME/google-cloud-sdk/bin:$PATH"
export PATH="$HOME/anaconda2/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export SBT_CREDENTIALS="$HOME/.ivy2/.credentials"
export TERM="xterm-256color"

export DEV_ID="tapad-paas-elias"


export MANPAGER=sh -c 'col -bx | bat -l man -p'

source "$HOME/.sdkman/bin/sdkman-init.sh"


export GOROOT="/usr/local/opt/go/libexec"
export PATH="$PATH:$GOPATH/bin"
test -d "${GOPATH}" || mkdir "${GOPATH}"
test -d "${GOPATH}/src/github.com" || mkdir -p "${GOPATH}/src/github.com"

export PATH="$PATH:/Applications/Xcode.app/Contents/Developer/usr/bin" 

