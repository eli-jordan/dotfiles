
function zaw-src-kube-context() { 
	local contexts=$(kubectl config get-contexts -o 'name')

    : ${(A)candidates::=${(f)contexts}}
	: ${(A)cand_descriptions::=${(f)contexts}}
    

    actions=(zaw-src-kube-context-set)
    act_descriptions=("Set current context")
    src_opts=()
}

function zaw-src-kube-context-set() {
	BUFFER="kubectl config set-context $1"
    zle accept-line
}

function zaw-src-kube-workload() {
	local workloads=(Pod Deployment Service ServiceAccount ClusteRole ClusterRoleBinding)

	candidates=(Pod Deployment Service ServiceAccount ClusteRole ClusterRoleBinding)
	cand_descriptions=(Pod Deployment Service ServiceAccount ClusteRole ClusterRoleBinding)

	actions=(zaw-src-kube-get-pods)
    act_descriptions=()
    src_opts=()
}

function zaw-src-kube-get-pods() {
	# local workloads=$(kubectl get pod)
	# zaw-callback-replace-buffer "$workloads"
 #    fill-vars-or-accept

	# : ${(A)candidates::=${(f)workloads}}
	# : ${(A)cand_descriptions::=${(f)workloads}}

	# actions=()
 #    act_descriptions=()
 #    src_opts=()
}


zaw-register-src -n kube-context zaw-src-kube-context

#zaw-register-src -n kube-workload zaw-src-kube-workload