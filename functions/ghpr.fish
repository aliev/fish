function ghpr -d "Browse pull requests with fzf"
    set -l cwd (pwd)
    set -l previewer (mktemp)
    printf '#!/bin/sh\nexport PATH="/opt/homebrew/bin:$PATH"\ncd "%s"\nNUM=$(echo "$1" | awk "{print \\$1}")\ngh pr view "$NUM" --json title,state,body,comments --jq '\''\"# \" + .title + \"\\n\\nState: \" + .state + \"\\n\\n\" + .body + (.comments | if length > 0 then \"\\n\\n---\\n## Comments\\n\" + (map(\"\\n**\" + .author.login + \":**\\n\" + .body) | join(\"\\n\")) else \"\" end)'\'' 2>&1\n' "$cwd" >$previewer
    chmod +x $previewer

    set -l pr (gh pr list --limit 50 | fzf --ansi --preview "$previewer {}")
    rm -f $previewer
    or return

    set -l pr_number (echo $pr | awk '{print $1}')
    test -z "$pr_number"; and return

    gh pr view $pr_number --web
end
