

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
POWERLEVEL9K_MODE="nerdfont-complete"

prompt_kube_context() {
  local kubectl_version="$(kubectl version --client 2>/dev/null)"

  if [[ -n "$kubectl_version" ]]; then
    # Get the current Kuberenetes context
    local cur_ctx=$(kubectl config current-context)
    local ns=$(kubectl config get-contexts $cur_ctx --no-headers | awk '{ print $5 }')
    local segment="$cur_ctx"
    if [[ ! -z "$ns" ]]; then
    	segment="$segment / $ns"
    fi
    "$1_prompt_segment" "$0" "$2" "white" "$DEFAULT_COLOR" "$segment" "KUBERNETES_ICON"
  fi
}

## Prompt configuration
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%F{blue}\u256D\u2500%f"
POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX="%F{blue}\u251C\u2500%f"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{blue}\u2570\uf460%f "
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(kube_context dir vcs)