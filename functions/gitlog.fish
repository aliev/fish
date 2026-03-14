function gitlog -d "Browse git log with fzf"
    git rev-parse --git-dir >/dev/null 2>&1; or return

    git log --oneline --color=always $argv | fzf --ansi --no-sort \
        --preview "echo {} | awk '{print \$1}' | xargs git show --color=always | head -200" \
        --bind "enter:execute(echo {} | awk '{print \$1}' | xargs git show --color=always | fzf --ansi --no-sort --height=99% --preview-window=hidden)"
end
