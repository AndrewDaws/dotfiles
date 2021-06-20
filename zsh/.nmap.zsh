# Aliases
netscan() {
    echo Starting Nmap scan...
    sudo nmap -sn ${1} | awk '!/Host is up|Starting Nmap|done/{gsub(/[()]/,""); if ("${6}" == "") {print ${5}} else {print ${6} " " ${5}}}'
}
