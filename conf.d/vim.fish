if status is-interactive
    # Vi mode by default
    fish_vi_key_bindings

    # V (Shift+V) selects entire line, repeat V to deselect
    bind -M default -m visual V beginning-of-line begin-selection end-of-line
    bind -M visual -m default V end-selection repaint-mode

    # ctrl-r for fzf history search
    bind -M insert ctrl-r __fzf_history
    bind -M default ctrl-r __fzf_history

    # Emacs-style ctrl-a/ctrl-e in insert and normal mode
    bind -M insert ctrl-e end-of-line
    bind -M insert ctrl-a beginning-of-line
    bind -M default ctrl-e end-of-line
    bind -M default ctrl-a beginning-of-line
end
