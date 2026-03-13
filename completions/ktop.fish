complete -c ktop -s s -l sort -xa "cpu mem" -d "Sort by cpu or mem"
complete -c ktop -s i -l interval -x -d "Refresh interval in seconds"
complete -c ktop -f -a "(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}' 2>/dev/null | tr ' ' '\n')" -d "Namespace"
