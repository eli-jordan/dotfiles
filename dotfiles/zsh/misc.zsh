
export PATH="$HOME/bin:$HOME/google-cloud-sdk/bin:$PATH"
export PATH="$HOME/anaconda2/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Go development
export GOPATH="${HOME}/go"
export GOROOT="$(which go)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
test -d "${GOPATH}" || mkdir "${GOPATH}"
test -d "${GOPATH}/src/github.com" || mkdir -p "${GOPATH}/src/github.com"

export SBT_CREDENTIALS="$HOME/.ivy2/.credentials"
export TERM="xterm-256color"

export DEV_ID="tapad-paas-elias"

mf() {
	local jar=$(ls $HOME/code/mart-framework/platform/cli/target/scala-2.12/cli-assembly-*)
	java -jar "$jar" $@
}

