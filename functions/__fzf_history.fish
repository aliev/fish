function __fzf_history
    set -l cmd (history | fzf --query=(commandline) --scheme=history)
    if test -n "$cmd"
        commandline -r -- $cmd
    end
    commandline -f repaint
end
