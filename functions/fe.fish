function fe -d "Browse and edit files with fzf"
    set -l files (git ls-files --cached --others --exclude-standard 2>/dev/null; or find . -type f)
    printf '%s\n' $files | fzf --ansi \
        --preview "cat -n {}" \
        --bind "enter:execute($EDITOR {})"
end
