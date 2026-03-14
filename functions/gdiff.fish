function gdiff -d "Browse git diff with fzf"
    git rev-parse --git-dir >/dev/null 2>&1; or return
    set -l files (git diff $argv --name-only 2>/dev/null)
    test -z "$files"; and echo "No changes." && return

    printf '%s\n' $files | fzf -m --ansi \
        --preview "git diff $argv --color=always -- {-1}" \
        --bind "enter:execute(git diff $argv --color=always -- {-1} | fzf --ansi --no-sort --height=50% --preview-window=hidden)"
end
