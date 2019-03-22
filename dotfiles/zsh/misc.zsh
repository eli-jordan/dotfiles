
export PATH="$HOME/bin:$HOME/google-cloud-sdk/bin:$PATH"
export PATH="$HOME/anaconda2/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

source "$HOME/scripts/mart-framework-helper-functions.sh"


# Go development
export GOPATH="${HOME}/.go"
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
test -d "${GOPATH}" || mkdir "${GOPATH}"
test -d "${GOPATH}/src/github.com" || mkdir -p "${GOPATH}/src/github.com"

export SBT_CREDENTIALS="$HOME/.ivy2/.credentials"
export TERM="xterm-256color"


