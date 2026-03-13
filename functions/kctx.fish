function kctx --description "Switch Kubernetes context using fzf"
    set -l current (kubectl config current-context 2>/dev/null)
    set -l contexts (kubectl config get-contexts -o name)

    set -l sorted
    for c in $contexts
        if test "$c" = "$current"
            set -p sorted $c
        else
            set -a sorted $c
        end
    end

    set -l ctx (printf '%s\n' $sorted | fzf --height=40% --prompt="K8s context> " --header="current: $current")
    if test -n "$ctx"
        kubectl config use-context $ctx
    end
end
