function notes -d "Browse notes with fzf or open vault in Helix"
    set -l notes_dir ~/notes

    if test "$argv[1]" = vault
        hx $notes_dir
        return
    end

    set -l files (find $notes_dir -name '*.md' -type f | sort -r | string replace "$notes_dir/" "")
    if test (count $files) -eq 0
        echo "No notes found. Create one with: note <topic>"
        return 1
    end

    if command -q bat
        set -l preview_cmd "bat --style=plain --color=always --language=md $notes_dir/{}"
    else
        set -l preview_cmd "cat $notes_dir/{}"
    end

    set -l selected (printf '%s\n' $files | fzf \
        --height=80% \
        --prompt="Notes> " \
        --header="Enter: edit | Esc: quit" \
        --preview "$preview_cmd" \
        --preview-window "right:60%:wrap")

    if test -n "$selected"
        hx $notes_dir/$selected
    end
end
