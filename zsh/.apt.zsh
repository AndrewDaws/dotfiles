# Aliases
alias pkg_update="sudo apt update && sudo apt upgrade"
alias pkg_install="sudo apt install --no-install-recommends"
alias pkg_uninstall="sudo apt remove"
alias pkg_autoremove="sudo apt autoremove"
alias pkg_fix="sudo apt --fix-broken install"
alias pkg_upgrade="sudo apt list --upgradeable"
alias pkg_dependency="sudo apt install -f --no-install-recommends"
alias pkg_name="apt-cache pkgnames | sort -bdf"

pkg_list() {
    if [[ -n "${1}" ]]; then
        sudo apt list --installed | grep -i ${1}
    else
        sudo apt list --installed
    fi
}

pkg_list_all() {
    if [[ -n "${1}" ]]; then
        sudo apt list --installed -a | grep -i ${1}
    else
        sudo apt list --installed -a
    fi
}

pkg_search() {
    apt-cache search ${1} | grep -i ${1}
}
