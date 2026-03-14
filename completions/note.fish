complete -c note -f

complete -c note -n "test (count (commandline -opc)) -eq 1" -a idea -d "Create idea note"
complete -c note -n "test (count (commandline -opc)) -eq 1" -a daily -d "Open today's daily note"
complete -c note -n "test (count (commandline -opc)) -eq 1" -a project -d "Create project note"
complete -c note -n "test (count (commandline -opc)) -eq 1" -a person -d "Create person note"
complete -c note -n "test (count (commandline -opc)) -eq 1" -a learn -d "Create learning note"

# Suggest existing notes for each subcommand
complete -c note -n "test (count (commandline -opc)) -ge 2; and test (commandline -opc)[2] = project" -a "(for f in ~/notes/projects/*.md; basename $f .md | string replace -a '-' ' '; end)"
complete -c note -n "test (count (commandline -opc)) -ge 2; and test (commandline -opc)[2] = person" -a "(for f in ~/notes/people/*.md; basename $f .md | string replace -a '-' ' '; end)"
complete -c note -n "test (count (commandline -opc)) -ge 2; and test (commandline -opc)[2] = learn" -a "(for f in ~/notes/learning/*.md; basename $f .md | string replace -a '-' ' '; end)"
complete -c note -n "test (count (commandline -opc)) -ge 2; and test (commandline -opc)[2] = idea" -a "(for f in ~/notes/ideas/*.md; basename $f .md | string replace -a '-' ' '; end)"
