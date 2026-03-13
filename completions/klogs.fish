complete -c klogs -s p -l previous -d "Show logs from previous crash"
complete -c klogs -f -a "(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}' 2>/dev/null | tr ' ' '\n')" -d "Namespace"
