# Aliases
alias dpkg_install="sudo dpkg -i"
alias dpkg_uninstall="sudo dpkg -r"
alias dpkg_purge="sudo dpkg --purge"
alias dpkg_clean="sudo dpkg --purge $(COLUMNS=300 dpkg -l "*" | egrep "^rc" | cut -d\  -f3)"

dpkg_list() {
    if [[ -n "${1}" ]]; then
        echo Searching packages...
        dpkg -l | awk -v pkg_var="^"${1} '${2} ~ pkg_var {print ${2}}'
    else
        sudo dpkg -l
    fi
}

dpkg_list_purge() {
    if [[ -n "${1}" ]]; then
        echo Purging packages...
        dpkg -l | awk -v pkg_var="^"${1} '${2} ~ pkg_var {print ${2}}' | xargs sudo dpkg --purge
    else
        echo No packages provided
    fi
}
