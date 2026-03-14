complete -c kpod -f -a "(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}' 2>/dev/null | tr ' ' '\n')" -d "Namespace"
