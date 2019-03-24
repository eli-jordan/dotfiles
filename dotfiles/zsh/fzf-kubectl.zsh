
kube-findpods() {
	local namespace pod_query namespaceOpt
	__fzf-kubectl::parse-find-pod-opts $@ | read namespace pod_query


	if [[ -z "$namespace" ]]; then
		namespaceOpt="--namespace=default"
	elif [[ "$namespace" == "all" ]]; then
		namespaceOpt="--all-namespaces"
	else
		namespaceOpt="--namespace=$namespace"
	fi

    local describe_bind='d:execute(kubectl describe pod $(echo {} | awk "{ print \$1 }") | less)'
    local tail_bind='t:execute(kubectl logs $(echo {} | awk "{ print \$1 }") | fzf)'
    #local execute_bind='x:execute(kubectl exec -it $(echo {} | awk "{ print \$1 }") -- bash | less)+abort'
	kubectl get pods "$namespaceOpt" | fzf --bind="$describe_bind,$tail_bind"

}

###
# Parses the options required to find.
# Parses flags: <cmd> [-n=my-ns|--namespace=my-ns] [pod query]
# 
###
__fzf-kubectl::parse-find-pod-opts() {
	local namespace pod_query

	for i in "$@"; do
		case "$i" in
    		-n=*|--namespace=*)
    		namespace="${i#*=}"
    		shift
    		;;

    		-n|--namespace)
            shift
    		namespace="$1"
    		shift
    		;;
    		
    		-a|--all-namespaces)
    		namespace="all"
    		shift
    		;;
    		
    		*) # unknow option
    		;;
		esac
	done
	pod_query="$1"
	echo "$namespace $pod_query"
}
