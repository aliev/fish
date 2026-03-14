function dcon --description "Interactive Docker container manager: exec, logs"
    set -l helper (mktemp)
    printf '#!/bin/sh\nCID=$(echo "$1" | awk "{print \\$1}")\nshift\nexec docker "$@" "$CID"\n' >$helper
    chmod +x $helper

    set -l line (docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" | fzf --height=50% \
        --prompt="Container> " \
        --header-first \
        --header="enter: exec | ctrl-l: logs" \
        --header-lines=1 \
        --preview-window="down:40%:wrap" \
        --preview="$helper {} logs --tail=50 2>/dev/null || echo no logs" \
        --bind "ctrl-l:execute($helper {} logs -f --tail=200)")
    rm -f $helper
    if test -z "$line"
        return
    end

    set -l container (echo $line | awk '{print $1}')
    docker exec -it $container sh -c "command -v bash >/dev/null && exec bash || exec sh"
end
