function note -d "Create a note in ~/notes and open in Helix"
    set -l notes_dir ~/notes

    if test (count $argv) -eq 0
        echo "usage: note idea <topic>      → ideas/"
        echo "       note daily             → daily note for today"
        echo "       note project <name>    → projects/"
        echo "       note person <name>     → people/"
        echo "       note learn <topic>     → learning/"
        return 1
    end

    switch $argv[1]
        case daily
            set -l file $notes_dir/daily/(date +%Y-%m-%d).md
            if not test -f $file
                printf '# %s\n\n## done\n\n\n## thoughts\n\n\n## tomorrow\n\n' (date +%Y-%m-%d) >$file
            end
            hx $file
        case project
            if test (count $argv) -lt 2
                echo "usage: note project <name>"
                return 1
            end
            set -l slug (string join '-' $argv[2..] | string lower | string replace -ra '[^a-z0-9-]' '-' | string replace -ra -- '-+' '-' | string trim --chars='-')
            set -l file $notes_dir/projects/$slug.md
            if not test -f $file
                printf '# %s\n\n## context\n\n\n## decisions\n\n\n## links\n\n' (string join ' ' $argv[2..]) >$file
            end
            hx $file
        case person
            if test (count $argv) -lt 2
                echo "usage: note person <name>"
                return 1
            end
            set -l slug (string join '-' $argv[2..] | string lower | string replace -ra '[^a-z0-9-]' '-' | string replace -ra -- '-+' '-' | string trim --chars='-')
            set -l file $notes_dir/people/$slug.md
            if not test -f $file
                printf '# %s\n\n## role\n\n\n## 1:1 notes\n\n\n## context\n\n' (string join ' ' $argv[2..]) >$file
            end
            hx $file
        case learn
            if test (count $argv) -lt 2
                echo "usage: note learn <topic>"
                return 1
            end
            set -l slug (string join '-' $argv[2..] | string lower | string replace -ra '[^a-z0-9-]' '-' | string replace -ra -- '-+' '-' | string trim --chars='-')
            set -l file $notes_dir/learning/$slug.md
            if not test -f $file
                printf '# %s\n\n## key ideas\n\n\n## notes\n\n\n## links\n\n' (string join ' ' $argv[2..]) >$file
            end
            hx $file
        case idea
            if test (count $argv) -lt 2
                echo "usage: note idea <topic>"
                return 1
            end
            set -l slug (string join '-' $argv[2..] | string lower | string replace -ra '[^a-z0-9-]' '-' | string replace -ra -- '-+' '-' | string trim --chars='-')
            set -l file $notes_dir/ideas/$slug.md
            if not test -f $file
                printf '# %s\n\n' (string join ' ' $argv[2..]) >$file
            end
            hx $file
        case '*'
            echo "Unknown command: $argv[1]"
            note
            return 1
    end
end
