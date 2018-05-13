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


    function Abort_If_Url_Not_Available()
    {
        ### VARIABLES ARGUMENTS ###

            local _url="${1}"


        ### VARIABLES COMPOSITION ###

            local _http_status_code=$( curl -L -s -o /dev/null -w "%{http_code}" "${_url}")


        ### EXECCUTION ###

            if [ "${_http_status_code}" -gt 299 ]
                then
                    Print_Warning "Http Status Code" "${_http_status_code}"
                    Print_Fatal_Error "Url not Available" "${_url}"
            fi
    }

    function Abort_If_Sym_Link_Already_Exists()
    {
        ### VARIABLES ARGUMENTS ###

            local _sym_link_name="${1?}"


        ### EXECUTION ###

            if [ -L "${_sym_link_name}" ]
                then
                    Print_Fatal_Error "Sym Link already exists" "${_sym_link_name}"
            fi
    }

    function Abort_If_Already_Installed()
    {
        ### VARIABLES ARGUMENTS ###

            local _package_manager_script="${1:?}"


        ### EXECUTION ###

            if [ -f "${_package_manager_script}" ]
                then
                    Print_Fatal_Error "Bash Package Manager is already installed" "${_package_manager_script}"
            fi
    }

	function Install_Bash_Package_Manager()
	{
	    local bin_dir="${1?}"

	    local bash_package_manager_version="${2?}"

	    local bash_package_manager="${bin_dir}/vendor/exadra37-bash/package-manager/src/package-manager.sh"

	    local git_url="https://github.com/exadra37-bash/package-manager/raw/${bash_package_manager_version}/self-install.sh"

	    if [ ! -f "${bash_package_manager}" ]
	        then

	            Print_Info "Using Bash Package Manager self installer" "${git_url}"
	            Abort_If_Url_Not_Available "${git_url}"

	            curl -sL "${git_url}" | bash -s -- "${bash_package_manager_version}" "${bin_dir}"
	    fi
	}

	function Create_Sym_Link()
    {
        ### VARIABLES ARGUMENTS ###

            local _from_script="${1?}"

            local _sym_link="${2?}"


        ### EXECUTION ###

            Print_Info "${_sym_link} is a Sym Link pointing to" "${_from_script}"

            ln -s "${_from_script}" "${_sym_link}"
    }


    function Self_Install()
    {
    	local _version="${1?}"
    	local _install_dir="${2?}"
    	local _git_url="${3?}"

    	mkdir -p "${_install_dir}"
    	cd "${_install_dir}"
    	git clone -q --depth 1 -b "${_version}" "${_git_url}" . 

    	# when the version is a tag we want to create a new branch, otherwise want to ignore this 
        # type of errors:
        #   fatal: A branch named 'last-stable-release' already exists.
        git checkout -q -b "${package_version}" 2>/dev/null || true

        cd -
    }


########################################################################################################################
# Variables
########################################################################################################################

	version="${1:-last-stable-release}"
	bash_package_manager_version="${2:-last-stable-release}"
	bin_dir="${3:-/home/${USER}/bin}"

	install_dir="${bin_dir}"/vendor/exadra37-bash/bin-package-installer

	git_url=https://github.com/exadra37-bash/bin-package-installer.git

	bpi_sym_link="${bin_dir}"/bpi
	bpu_sym_link="${bin_dir}"/bpu


########################################################################################################################
# Execution
########################################################################################################################


	Abort_If_Url_Not_Available "${git_url}"

    Abort_If_Sym_Link_Already_Exists "${bpi_sym_link}"

    Abort_If_Sym_Link_Already_Exists "${bpu_sym_link}"

    Abort_If_Already_Installed "${install_dir}"/src/installer.sh

	Create_Sym_Link "${install_dir}"/src/installer.sh "${bpi_sym_link}"

	Create_Sym_Link "${install_dir}"/src/uninstaller.sh "${bpu_sym_link}"

	Self_Install "${version}" "${install_dir}" "${git_url}"

	Install_Bash_Package_Manager "${bin_dir}" "${bash_package_manager_version}" &&

	printf "\n\e[1;42m Installed Successfully:\e[30;48;5;229m Try bpi --help or bpu --help to see How to Use. \e[0m \n" &&
	echo
