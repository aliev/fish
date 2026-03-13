function klogs --description "Select a pod with fzf and view its logs (-p for previous crash logs)"
    argparse p/previous -- $argv
    or return

    set -l ns_args
    if test (count $argv) -gt 0
        set ns_args -n $argv[1]
    else
        set ns_args --all-namespaces
    end

    set -l log_args -f --tail=200 --all-containers
    if set -q _flag_previous
        set -a log_args --previous
    end

    set -l current_ctx (kubectl config current-context 2>/dev/null; or echo "none")
    set -l line (kubectl get pods $ns_args -o wide | fzf --height=50% --prompt="Pod> " --header-first --header="ctx: $current_ctx" --header-lines=1 --preview-window=hidden)
    if test -z "$line"
        return
    end

    if contains -- --all-namespaces $ns_args
        set -l ns (echo $line | awk '{print $1}')
        set -l pod (echo $line | awk '{print $2}')
        kubectl logs $log_args -n $ns $pod
    else
        set -l pod (echo $line | awk '{print $1}')
        kubectl logs $log_args $ns_args $pod
    end
end
