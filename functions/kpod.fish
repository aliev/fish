function kpod --description "Interactive pod manager: exec, logs, previous logs"
    set -l ns_args
    if test (count $argv) -gt 0
        set ns_args -n $argv[1]
    else
        set ns_args --all-namespaces
    end

    set -l current_ctx (kubectl config current-context 2>/dev/null; or echo "none")

    set -l helper (mktemp)
    if contains -- --all-namespaces $ns_args
        printf '#!/bin/sh\nNS=$(echo "$1" | awk "{print \\$1}")\nPOD=$(echo "$1" | awk "{print \\$2}")\nshift\nexec kubectl "$@" -n "$NS" "$POD"\n' >$helper
    else
        printf '#!/bin/sh\nPOD=$(echo "$1" | awk "{print \\$1}")\nshift\nexec kubectl "$@" %s "$POD"\n' "$ns_args" >$helper
    end
    chmod +x $helper

    set -l line (kubectl get pods $ns_args -o wide | fzf --height=50% \
        --prompt="Pod> " \
        --header-first \
        --header="ctx: $current_ctx | enter: exec | ctrl-l: logs | ctrl-p: prev logs" \
        --header-lines=1 \
        --preview-window="down:40%:wrap" \
        --preview="$helper {} logs --tail=50 --all-containers 2>/dev/null || echo no logs" \
        --bind "ctrl-l:execute($helper {} logs -f --tail=200 --all-containers)" \
        --bind "ctrl-p:execute($helper {} logs --previous --tail=200 --all-containers)")
    rm -f $helper
    if test -z "$line"
        return
    end

    if contains -- --all-namespaces $ns_args
        set -l ns (echo $line | awk '{print $1}')
        set -l pod (echo $line | awk '{print $2}')
        kubectl exec -it -n $ns $pod -- sh -c "command -v bash >/dev/null && exec bash || exec sh"
    else
        set -l pod (echo $line | awk '{print $1}')
        kubectl exec -it $ns_args $pod -- sh -c "command -v bash >/dev/null && exec bash || exec sh"
    end
end
