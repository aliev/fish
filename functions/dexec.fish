function dexec --description "Select a Docker container with fzf and exec into it"
    set -l line (docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" | fzf --height=50% --prompt="Container> " --header-lines=1 --preview-window=hidden)
    if test -z "$line"
        return
    end

    set -l container (echo $line | awk '{print $1}')
    docker exec -it $container sh -c "command -v bash >/dev/null && exec bash || exec sh"
end
