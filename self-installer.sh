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


function Abort_If_Url_Not_Available()
{
    local url="${1}"

    local http_status_code=$( curl -L -s -o /dev/null -w "%{http_code}" "${url}")

    if [ "${http_status_code}" -gt 299 ]
        then
            Print_Warning "Http Status Code" "${http_status_code}"
            Print_Fatal_Error "Url not Available" "${url}"
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

checkout_to="${1:-last-stable-release}"
bin_dir="${2:-/home/${USER}/bin}"
bash_package_manager_version="${3:-last-stable-release}"

install_dir="${bin_dir}"/vendor/exadra37-bash/bin-package-installer

git_url=https://github.com/exadra37-bash/bin-package-installer.git


mkdir -p "${install_dir}" &&
cd "${install_dir}" &&
git clone -q --depth 1 -b "${checkout_to}" "${git_url}" . &&
ln -s "${install_dir}"/src/installer.sh "${bin_dir}"/bpi &&
ln -s "${install_dir}"/src/uninstaller.sh "${bin_dir}"/bpu &&
Install_Bash_Package_Manager "${bin_dir}" "${bash_package_manager_version}" &&
printf "\n\e[1;42m Installed Successfully:\e[30;48;5;229m Try bpi --help or bpu --help to see How to Use. \e[0m \n" &&
echo
