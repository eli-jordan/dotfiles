
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse'

typeset -A MAIN_MENU_OPTIONS
MAIN_MENU_OPTIONS+=(kube-context kube-context-list)
MAIN_MENU_OPTIONS+=(kube-workload kube-workload-list)

fzf-main-menu() {
  local command=$(for c in ${(k)MAIN_MENU_OPTIONS}; do
    echo "$c"
  done | fzf)

  ${MAIN_MENU_OPTIONS[$command]}
}

kube-context-list() {
  local context=$(kubectl config get-contexts -o 'name' | fzf)
  BUFFER="kubectl config set-context $context"
  zle accept-line
}

kube-workload-list() {
  local options=(
    Deployment
    Namespace
    Pod
    Service
    ClusterRole
    ClusterRoleBinding
  )
  local workload=$(for o in $options; do
    echo "$o"
  done | fzf)
  local header="Listing $workload in $(kubectl config current-context)"
  local selected=$(kubectl get $workload | fzf --header="$header" | awk '{print $1}')
  BUFFER="kubectl get $workload $selected"
}

zle -N fzf-main-menu
bindkey '^@' fzf-main-menu