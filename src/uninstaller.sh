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

    function Print_Success()
    {
        printf "\n\e[1;42m ${1}:\e[30;48;5;229m ${2} \e[0m \n"
    }

    function Ask_For_Confirmation()
    {
        local question="${1}"

        printf "\n\e[1;33m ${question} \e[0m [y/n] ?"
        read
        echo

        if [[ ! "${REPLY}" =~ ^[Yy]$ ]]
            then
                Print_Fatal_Error "Cancel" "Operation aborted by user."
        fi
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


########################################################################################################################
# Parameters
########################################################################################################################

    ([ -z "${1}" ] || [ "--help" == "${1}" ]) && cat "${script_dir}"/../docs/uninstaller-help.txt && exit 0

    ([ "--version" == "${1}" ]) && Print_Success "Version" "0.0.1.1" && echo && exit 0

    while getopts ':b:n:p:s:' flag; do
      case "${flag}" in
        b) bin_dir="${OPTARG}" ;;
        n) vendor_name="${OPTARG}" ;;
        p) package_name="${OPTARG}" ;;
        s) symlinks_list="${OPTARG}" ;;
        \?) Print_Fatal_Error "ERROR" "Parameter -${OPTARG} is not supported." ;;
        :) Print_Fatal_Error "ERROR" "Parameter -${OPTARG} requires a value." ;;
      esac
    done


########################################################################################################################
# Validations
########################################################################################################################

    [ -z "${bin_dir// }" ] && Print_Fatal_Error "Error" "Bin Dir can't be empty. Use Like: -b /bin/usr"
    [ -z "${vendor_name// }" ] && Print_Fatal_Error "Error" "Vendor Name can't be empty. Use Like: -v exadra37-bash"
    [ -z "${package_name// }" ] && Print_Fatal_Error "Error" "Package Name can't be empty. Use Like: -p package-manager"
    [ -z "${symlinks_list// }" ] && Print_Fatal_Error "Error" "Symlinks List can't be empty. Use Like: -s symlink1,symlink2"


########################################################################################################################
# Variables
########################################################################################################################

    package_dir="${bin_dir}"/vendor/"${vendor_name}"/"${package_name}"


########################################################################################################################
# Execution
########################################################################################################################

    IFS=',' read -ra symlinks <<< "${symlinks_list}"
    for symlink in "${symlinks[@]}"
        do
            if [ -z "${symlink}" ]
                then
                    Print_Fatal_Error "Error" "SymLink can't be empty."
                else
                    symlink_path="${bin_dir}"/"${symlink}"

                    Print_Info "Removing Symlink" "${symlink_path}"

                    Ask_For_Confirmation "Are you sure you want to DELETE symlink: ${symlink_path}"

                    rm -rvf "${symlink_path}"
            fi
    done

    if [ -z "${package_dir}" ]
        then
            Print_Fatal_Error "Error" "Package Dir can't be empty."
        else
            Print_Info "Removing Package From" "${package_dir}"

            Ask_For_Confirmation "Are you sure you want to DELETE package from: ${package_dir}"

            rm -rvf "${package_dir}"
    fi


    Print_Success "Success" "${vendor_name}/${package_name} package as been removed."

    Tweet_Me

    echo
