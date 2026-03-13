function fblame -d "Browse git blame with fzf"
    git rev-parse --git-dir >/dev/null 2>&1; or return

    while true
        set -l file (git ls-files | fzf --ansi \
            --preview "git blame --color-by-age --color-lines {} | head -100")
        or return

        git blame $file | fzf --ansi \
            --preview "echo {} | awk '{print \$1}' | tr -d '^' | xargs -I% git show --color=always % | head -200"
        # esc → back to file list
    end
end
