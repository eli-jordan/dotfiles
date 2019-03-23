
#function zaw-src-kube-context() { 
#	local contexts=$(kubectl config get-contexts -o 'name')
#
#    : ${(A)candidates::=${(f)contexts}}
#	: ${(A)cand_descriptions::=${(f)contexts}}
#    
#
#    actions=(zaw-src-kube-context-set)
#    act_descriptions=("Set current context")
#    src_opts=()
#}
#
#function zaw-src-kube-context-set() {
#	BUFFER="kubectl config set-context $1"
#    zle accept-line
#}
#
#function zaw-src-kube-workload() {
#  local options=(
#    Deployments
#    Namespaces
#    Pods
#    Services
#    ClusterRoles
#    ClusterRoleBindings
#  )
#  local workload=$(for o in $options; do
#    echo "$o"
#  done | fzf)
#  local header="Listing $workload in $(kubectl config current-context)"
#  local selected=$(kubectl get $workload | fzf --header="$header" | awk '{ print $1 }')
#  BUFFER="kubectl get pod $selected"
#  zle accept-line
#}
#
#zaw-register-src -n kube-context zaw-src-kube-context
#zaw-register-src -n kube-workload zaw-src-kube-workload#