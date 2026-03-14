function dcon --description "Interactive Docker container manager: exec, logs"
    set -l helper (mktemp)
    printf '#!/bin/sh\nCID=$(echo "$1" | awk "{print \\$1}")\nshift\ncase "$1" in\n  stats) docker stats --no-stream --format "CPU: {{.CPUPerc}}  MEM: {{.MemUsage}}" "$CID" 2>/dev/null;;\n  *) exec docker "$@" "$CID";;\nesac\n' >$helper
    chmod +x $helper

    set -l line (docker ps --format "table {{.ID}}\t{{printf \"%.30s\" .Names}}\t{{.Image}}\t{{.Status}}" | fzf --height=50% \
        --prompt="Container> " \
        --header-first \
        --header="enter: exec | ctrl-l: logs" \
        --header-lines=1 \
        --preview-window="down:40%:wrap" \
        --preview="$helper {} stats; echo '---'; $helper {} logs --tail=50 2>/dev/null || echo no logs" \
        --bind "ctrl-l:execute($helper {} logs -f --tail=200)")
    rm -f $helper
    if test -z "$line"
        return
    end

    set -l container (echo $line | awk '{print $1}')
    docker exec -it $container sh -c "command -v bash >/dev/null && exec bash || exec sh"
end
