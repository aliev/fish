function ktop --description "Live pod status monitor (-s cpu|mem, -i interval)"
    argparse 's/sort=?!string match -qr "^(cpu|mem)\$" "$_flag_value"' 'i/interval=?!string match -qr "^\d+\$" "$_flag_value"' -- $argv
    or return

    set -l sort_by (test -n "$_flag_sort" && echo $_flag_sort || echo cpu)
    set -l interval (test -n "$_flag_interval" && echo $_flag_interval || echo 3)

    set -l ns_args
    if test (count $argv) -gt 0
        set ns_args -n $argv[1]
    else
        set ns_args --all-namespaces
    end

    set -l current_ctx (kubectl config current-context 2>/dev/null; or echo "none")
    set -l has_metrics false
    if kubectl top pods $ns_args --no-headers 2>/dev/null | read -l _test_line
        set has_metrics true
    end

    set -l allns 0
    contains -- --all-namespaces $ns_args && set allns 1

    while true
        set -l buf

        if test "$has_metrics" = true
            set -l sort_flag
            if test "$sort_by" = mem
                set sort_flag --sort-by=memory
            else
                set sort_flag --sort-by=cpu
            end

            set buf (begin
                echo "---TOP---"
                kubectl top pods $ns_args $sort_flag --no-headers 2>/dev/null
                echo "---PODS---"
                kubectl get pods $ns_args --no-headers -o custom-columns='NS:.metadata.namespace,NAME:.metadata.name,STATUS:.status.phase,RESTARTS:.status.containerStatuses[0].restartCount' 2>/dev/null
            end | awk -v allns=$allns '
            /^---TOP---/ { section="top"; next }
            /^---PODS---/ { section="pods"; next }
            section=="top" {
                if (allns) {
                    tns[NR]=$1; tpod[NR]=$2; tcpu[NR]=$3; tmem[NR]=$4
                    tkey[$1"/"$2]=NR
                } else {
                    tns[NR]=""; tpod[NR]=$1; tcpu[NR]=$2; tmem[NR]=$3
                    tkey["/"$1]=NR
                }
                tc++; tord[tc]=NR
            }
            section=="pods" {
                k=$1"/"$2
                pst[k]=$3; prs[k]=$4
                pc++; pall[pc]=k
                pns[k]=$1; pname[k]=$2
            }
            END {
                if (allns) {
                    printf "H|%-20s %-45s %8s %8s  %-12s %s\n","NAMESPACE","NAME","CPU","MEM","STATUS","RESTARTS"
                } else {
                    printf "H|%-45s %8s %8s  %-12s %s\n","NAME","CPU","MEM","STATUS","RESTARTS"
                }
                for (i=1; i<=tc; i++) {
                    r=tord[i]
                    k=tns[r]"/"tpod[r]
                    s=(k in pst)?pst[k]:"?"
                    re=(k in prs)?prs[k]:"?"
                    c="Y"
                    if (s=="Running") { c="G" }
                    if (s~/CrashLoopBackOff|Error|Failed/) { c="R" }
                    if (allns) {
                        printf "%s|%-20s %-45s %8s %8s  %-12s %s\n",c,tns[r],tpod[r],tcpu[r],tmem[r],s,re
                    } else {
                        printf "%s|%-45s %8s %8s  %-12s %s\n",c,tpod[r],tcpu[r],tmem[r],s,re
                    }
                }
                uc=0
                for (i=1; i<=pc; i++) {
                    k=pall[i]
                    if (pst[k]!="Running" && pst[k]!="Succeeded" && !(k in tkey)) {
                        uc++
                        if (uc==1) {
                            printf "\nH|--- unhealthy pods ---\n"
                            if (allns) {
                                printf "H|%-20s %-45s  %-25s %s\n","NAMESPACE","NAME","STATUS","RESTARTS"
                            } else {
                                printf "H|%-45s  %-25s %s\n","NAME","STATUS","RESTARTS"
                            }
                        }
                        if (allns) {
                            printf "R|%-20s %-45s  %-25s %s\n",pns[k],pname[k],pst[k],prs[k]
                        } else {
                            printf "R|%-45s  %-25s %s\n",pname[k],pst[k],prs[k]
                        }
                    }
                }
            }')
        else
            set buf (kubectl get pods $ns_args -o wide 2>/dev/null)
        end

        clear
        set_color brwhite
        if test "$has_metrics" = true
            echo "ktop | ctx: $current_ctx | sort: $sort_by | refresh: {$interval}s | ctrl+c to exit"
        else
            echo "ktop | ctx: $current_ctx | refresh: {$interval}s | no metrics-server | ctrl+c to exit"
        end
        set_color normal
        echo

        for line in $buf
            switch (string sub -l 2 $line)
                case 'H|'
                    set_color brwhite
                case 'G|'
                    set_color green
                case 'R|'
                    set_color red
                case 'Y|'
                    set_color yellow
                case '*'
                    echo $line
                    continue
            end
            echo (string sub -s 3 $line)
            set_color normal
        end

        sleep $interval
    end
end
