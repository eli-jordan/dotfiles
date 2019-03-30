
##
# fzf-kubectl is an interactive command line tool to interact with kubernetes.
#
# Usage: kube [workload-type-query] [-n=my-ns|--namespace=my-ns|-a|--all-namespaces] [query]
#   
#   workload-type-query -  the type of kubernetes object yo are interested in (e.g. pod)
#   -n|--name           - specify the namespace to look for pods in (defaults to "default")
#   -a|--all-namespaces - look in all namespaces
#   query               - the initial query passed to fzf
##

# TODO: make keybinding configurable

__fzf_kubectl_workloads=(
    context
    namespace
    pod 
    deployment 
    secret
    service 
    configmap 
    clusterrole 
    clusterrolebinding
)

kube() {
    local namespace workload_type_query workload_query
    local args=$(__fzf-kubectl::parse-find-workload-opts $@)

    IFS="|"; echo "$args" | read namespace workload_type_query workload_query; IFS=" ";

    local workload=$(echo ${__fzf_kubectl_workloads[*]} \
       | tr ' ' '\n' \
       | fzf -1 -q "$workload_type_query")

    case "$workload" in
        context)
        kubectx;;

        namespace)
        kubens;;

        *)
        __fzf-kubectl::kube-workload-selector "$workload" "$namespace" "$workload_query"
    esac
}

__fzf-kubectl::kube-workload-selector() {
    local workload="$1"
    local namespace="$2"
    local query="$3"

    # If no namespace was set then, set it using the current kube context
    if [[ -z "$namespace" ]]; then
        local cur_ctx=$(kubectl config current-context)
        local ns=$(kubectl config get-contexts $cur_ctx --no-headers | awk '{ print $5 }')
        namespace="$ns"
    fi

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
    local edit_bind=(
        'ctrl-e:execute('
           '__fzf-kubectl-edit' 
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
           '__fzf-kubectl-run-command-in-new-tab'
           '__fzf-kubectl-port-fwd'
           "$namespace"
           '{}'
        ')'
    )

           
        
    selector_bind_actions() {
        case "$workload" in
            pod)
            echo "$accept_bind,$describe_bind,$get_yaml_bind,$edit_bind,$tail_bind,$logs_bind,$port_fwd_bind";;
            
            deployment)
            echo "$accept_bind,$describe_bind,$get_yaml_bind,$edit_bind,$port_fwd_bind";;

            service)
            echo "$accept_bind,$describe_bind,$get_yaml_bind,$edit_bind,$port_fwd_bind";;

            configmap)
            echo "$accept_bind,$describe_bind,$get_yaml_bind,$edit_bind";;

            secret)
            echo "$accept_bind,$describe_bind,$get_yaml_bind,$edit_bind";;

            clusterrole)
            echo "$accept_bind,$describe_bind,$get_yaml_bind,$edit_bind";;

            clusterrolebinding)
            echo "$accept_bind,$describe_bind,$get_yaml_bind,$edit_bind";;

            *)
            echo "Unrecognised workload type $workload"
            exit 1
        esac
    }

    # Supports several key binding:
    #   * 'enter'  - get the resource as yaml
    #   * 'ctrl-d' - describes the currently selected resource
    #   * 'ctrl-e' - edit the selected resource
    #   * 'ctrl-t' - tails the logs for the selected resource
    #   * 'ctrl-l' - opens the logs for the selected resource
    #   * 'ctrl-p' - starts a port-forward for the selected resource
    start_selector() {
        local bind=$(selector_bind_actions)
        local namespaceOpt
        if [[ "$namespace" == "all" ]]; then
            namespaceOpt="--all-namespaces"
        else
            namespaceOpt="--namespace=$namespace"
        fi

        kubectl get "$workload" "$namespaceOpt" | \
            fzf-tmux --bind="$bind" \
                --header="type: ${workload}s namespace: $namespace" \
                --header-lines=1 \
                --query="$query"
    }

    start_selector
}

###
# Parses the options required to find.
# Parses flags: (workload type) [-a|--all-namespaces] [-n=my-ns|--namespace=my-ns] -- [query]
# 
###
__fzf-kubectl::parse-find-workload-opts() {
    set -- "$@"
    local all_namespaces_opt namespace_opt
    zparseopts -D -E \
        a=all_namespaces_opt \
        -all-namespaces=all_namespaces_opt \
        n:=namespace_opt \
        -namespace:=namespace_opt

    local namespace
    if [[ ! -z "$all_namespaces_opt" ]]; then
        namespace="all"
    elif [[ ! -z "$namespace_opt" ]]; then
        namespace=$(echo "${namespace_opt[2]}" | sed -e '/^=/s/^.//')
    else
        namespace=""
    fi

    local workload_query
    local workload_type_query=()
    for i in $@[*]; do
        if [[ "$i" == "--" || "$i" == "-" ]]; then
            shift
            workload_query=$@
            break
        else
            workload_type_query+=($i)
            shift
        fi
    done

    echo "$namespace|$workload_type_query|$workload_query"
}
