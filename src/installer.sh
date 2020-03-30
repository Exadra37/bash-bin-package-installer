#!/bin/bash
# @package exadra37-bash/bin-package-installer
# @link    https://gitlab.com/exadra37-bash/bin-package-installer
# @since   2017/02/12
# @license MIT
# @author  Exadra37(Paulo Silva) <exadra37ingmailpointcom>
#
# Social Links:
# @link    Author:   https://exadra37.com
# @link    Gitlab:   https://gitlab.com/Exadra37
# @link    Github:   https://github.com/Exadra37
# @link    Linkedin: https://uk.linkedin.com/in/exadra37
# @link    Twitter:  https://twitter.com/Exadra37

set -e

########################################################################################################################
# Functions
########################################################################################################################

    function Print_Fatal_Error()
    {
        printf "\n \e[1;101m ${1}: \e[30;48;5;229m ${2} \e[0m \n"
        echo
        exit 1
    }

    function Print_Info()
    {
        printf "\n\e[1;36m ${1}:\e[0m ${2} \n"
    }

    function Print_Warning()
    {
        printf "\n\e[1;33m ${1}:\e[0m ${2} \n"
    }

    function Print_Success()
    {
        printf "\n\e[1;42m ${1}:\e[30;48;5;229m ${2} \e[0m \n"
    }

    function Tweet_Me()
    {
        local message="All #Developers, #DevOps and #SysAdmins should try #Bash_Package_Installer by @exadra37."
        local message="${message// /\%%20}"
        local message="${message//#/\%%23}"

        local twitter_url="https://twitter.com/home?status=${message}"

        Print_Info "Share Me On Twitter" "${twitter_url}"
    }


########################################################################################################################
# Defaults
########################################################################################################################

    script_dir=$(dirname $(readlink -f $0))
    bin_dir=/home/$(id -un)/bin
    domain="github.com"


########################################################################################################################
# Parameters
########################################################################################################################

    ([ -z "${1}" ] || [ "--help" == "${1}" ]) && cat "${script_dir}"/../docs/installer-help.txt && exit 0

    ([ "-v" == "${1}" ] || [ "--version" == "${1}" ]) && cd ${script_dir} && (git describe --exact-match 2> /dev/null || git rev-parse --abbrev-ref HEAD) && exit 0

    while getopts ':b:d:n:p:s:t:' flag; do
      case "${flag}" in
        b) bin_dir="${OPTARG}" ;;
        d) domain="${OPTARG}" ;;
        n) vendor_name="${OPTARG}" ;;
        p) package_name="${OPTARG}" ;;
        s) symlinks_map="${OPTARG}" ;;
        t) package_tag="${OPTARG}" ;;
        \?) Print_Fatal_Error "ERROR" "Parameter -${OPTARG} is not supported." ;;
        :) Print_Fatal_Error "ERROR" "Parameter -${OPTARG} requires a value." ;;
      esac
    done


########################################################################################################################
# Validations
########################################################################################################################

    [ -z "${bin_dir// }" ] && Print_Fatal_Error "Error" "Bin Dir can't be empty. Use Like: -b /bin/usr"
    [ -z "${vendor_name// }" ] && Print_Fatal_Error "Error" "Vendor Name can't be empty. Use Like: -n exadra37-bash"
    [ -z "${package_name// }" ] && Print_Fatal_Error "Error" "Package Name can't be empty. Use Like: -p package-manager"
    [ -z "${package_tag// }" ] && Print_Fatal_Error "Error" "Package Tag can't be empty. Use Like: -t 1.0.0.0"
    [ -z "${symlinks_map// }" ] && Print_Fatal_Error "Error" "Symlinks Map can't be empty. Use Like: -s symlink:bash-script.sh"
    [ -z "${domain// }" ] && Print_Fatal_Error "Error" "Domain Name can't be empty. Use Like: -d gitlab.com"


########################################################################################################################
# Variables
########################################################################################################################

    new_symlinks=""
    install_dir="${bin_dir}"/vendor/"${vendor_name}"/"${package_name}"


########################################################################################################################
# Execution
########################################################################################################################

    # Needed for when we source the script directly from the repository, just
    #  like we do inside the `if` with the `self-installer.sh`.
    if [ ! -f "${bin_dir}"/vendor/exadra37-bash/bin-package-installer/self-installer.sh ]; then
        curl -fsSL https://gitlab.com/exadra37-bash/bin-package-installer/raw/master/self-installer.sh | bash -s "last-stable-release" "${bin_dir}"
    fi

    cd "${bin_dir}" &&
    # bpm require exadra37-bash git-helpers 1.0.0.0
    bpm require "${vendor_name}" "${package_name}" "${package_tag}" "${domain}"

    # symlinks map is like 'symlink:bash-script.sh' or 'symlink:bash-script.sh,symlink2:bash-script2.sh'
    IFS=',' read -ra maps <<< "${symlinks_map}"
    for map in "${maps[@]}"
        do
            # Get everything before first occurrence of ':' in the $map var.
            # Like return demo from 'demo:bash-script.sh'.
            symlink=${map%%:*}

            # Get everything after last occurrence of ':' in the $map var.
            # Like returning 'bash-script.sh' from 'demo:bash-script.sh'.
            script_to_link=${map#*:}

            # Path like: /home/$USER/bin/vendor/vendor-name/package-name/scr/bash-script.sh
            symlink_to="${install_dir}"/"${script_to_link}"

            # symlynks list like:
            #  - 'symlink1,'
            #  - 'symlink1, symlink2,'
            new_symlinks="${symlink},${new_symlinks}"

            if [ -z "${symlink}" ] || [ -z "${script_to_link}" ]
                then
                    Print_Fatal_Error "Invalid SymLink map: ${map}"

                    exit 1
            fi

            Print_Info "${symlink} is a SymLink pointing to" "${symlink_to}"

            ln -s "${symlink_to}" "${bin_dir}"/"${symlink}"
    done

    # remove comma from the end of the string 'symlink1, symlink2,'
    new_symlinks=${new_symlinks%,*}

    Print_Warning "Package Installed in" "${install_dir}"

    Print_Success "Try your new SymLinks" "${new_symlinks}"

    Tweet_Me

    echo
