
##
# Usage: kube [workload] [-n=my-ns|--namespace=my-ns|-a|--all-namespaces] [query]
#   
#   workload            -  the type of kubernetes object yo are interested in (e.g. pod)
#   -n|--name           - specify the namespace to look for pods in (defaults to "default")
#   -a|--all-namespaces - look in all namespaces
#   query               - the initial query passed to fzf
##

# TODO: -a/--all-namespaces doesn't work, because it selects the wrong field to lookup the object
# TODO: make keybinding configurable

__fzf_kubectl_workloads=(
    context
    namespace
    pod 
    deployment 
    service 
    configmap 
    secret 
    clusterrole 
    clusterrolebinding
)

kube() {
    if [[ ${#@} == 0 ]]; then
        local workload=$(echo ${__fzf_kubectl_workloads[*]} | tr ' ' '\n' | fzf)
        __fzf-kubectl::dispatch-workload "$workload"
    else
        local workload="$1"
        shift
        __fzf-kubectl::dispatch-workload "$workload" $@
    fi 
}

__fzf-kubectl::dispatch-workload() {
    case "$workload" in
        context|ctx)
        kubectx;;

        namespace|ns)
        kubens;;

        *)
        __fzf-kubectl::kube-workload-selector $@
    esac
}

__fzf-kubectl::kube-workload-selector() {
    local workload="$1"
    shift

    local namespace pod_query
    IFS="|" && __fzf-kubectl::parse-find-pod-opts $@ | read namespace pod_query
    IFS=" "

    # If no namespace was set then, set it using the current kube context
    if [[ -z "$namespace" ]]; then
        local cur_ctx=$(kubectl config current-context)
        local ns=$(kubectl config get-contexts $cur_ctx --no-headers | awk '{ print $5 }')
        namespace="$ns"
    fi



    normalise_workload_name() {
        case "$1" in
            pod|pods)
            echo "pod";;
            
            deployment|deployments|deploy|deploys)
            echo "deployment";;

            service|services|svc|svcs)
            echo "service";;

            configmap|configmaps|cm|cms)
            echo "configmap";;

            secret|secrets)
            echo "secret";;

            clusterrole|clusterroles)
            echo "clusterrole";;

            clusterrolebinding|clusterrolebinding)
            echo "clusterrolebinding";;

            *)
            echo "Unrecognised workload type $workload"
            exit 1
        esac
    }

    workload="$(normalise_workload_name $workload)"

    local describe_bind=(
        'ctrl-d:execute('
           '__fzf-kubectl-describe' 
           "$namespace" 
           "$workload" 
           '{}'
        ')'
    )
    local get_yaml_bind=(
        'enter:execute('
           '__fzf-kubectl-get-yaml' 
           "$namespace" 
           "$workload" 
           '{}'
        ')'
    )
    local accept_bind=(
        'ctrl-space:accept'
    )
    local tail_bind=(
        'ctrl-t:execute('
           '__fzf-kubectl-pod-logs'
           "$namespace" 
           'tail'
           '{}'
        ')'
    )
    local logs_bind=(
        'ctrl-l:execute('
           '__fzf-kubectl-pod-logs'
           "$namespace" 
           'bat'
           '{}'
        ')'
    )
    local port_fwd_bind=(
        'ctrl-p:execute('
           '__fzf-kubectl-port-fwd'
           "$namespace" 
           '{}'
        ')'
    )
        
    selector_bind_actions() {
        case "$workload" in
            pod)
            echo "$accept_bind,$describe_bind,$get_yaml_bind,$tail_bind,$logs_bind,$port_fwd_bind";;
            
            deployment)
            echo "$accept_bind,$describe_bind,$get_yaml_bind,$port_fwd_bind";;

            service)
            echo "$accept_bind,$describe_bind,$get_yaml_bind,$port_fwd_bind";;

            configmap)
            echo "$accept_bind,$describe_bind,$get_yaml_bind";;

            secret)
            echo "$accept_bind,$describe_bind,$get_yaml_bind";;

            clusterrole)
            echo "$accept_bind,$describe_bind,$get_yaml_bind";;

            clusterrolebinding)
            echo "$accept_bind,$describe_bind,$get_yaml_bind";;

            *)
            echo "Unrecognised workload type $workload"
            exit 1
        esac
    }

    # The pos selector
    # Supports several key binding
    #   * 'ctrl-d' - describes the currently selected pod
    #   * 'ctrl-t' - tails the logs for the selected pod
    #   * 'ctrl-l' - opens the logs for the selected pod
    #   * 'ctrl-p' - starts a port-forward for the selected pod
    #   * 'enter' - get the resource as yaml
    start_selector() {
        local bind=$(selector_bind_actions)

        local namespaceOpt
        if [[ "$namespace" == "all" ]]; then
            namespaceOpt="--all-namespaces"
        else
            namespaceOpt="--namespace=$namespace"
        fi

        echo "bind=$bind"
        kubectl get "$workload" "$namespaceOpt" | \
            fzf --bind="$bind" \
                --header="type: ${workload}s namespace: $namespace" \
                --header-lines=1 \
                --query="$pod_query"
    }

    start_selector
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
	pod_query="$@"
	echo "$namespace|$pod_query"
}
