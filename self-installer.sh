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

checkout_to="last-release"
home_bin_dir=/home/"${USER}"/bin
install_dir="${home_bin_dir}"/vendor/exadra37-bash/bin-package-installer
git_url=https://github.com/exadra37-bash/bin-package-installer.git

mkdir -p "${install_dir}" &&
cd "${install_dir}" &&
git clone -q --depth 1 -b "${checkout_to}" "${git_url}" . &&
ln -s "${install_dir}"/src/installer.sh "${home_bin_dir}"/bpi &&
ln -s "${install_dir}"/src/uninstaller.sh "${home_bin_dir}"/bpu &&
printf "\n\e[1;42m Installed Successfully:\e[30;48;5;229m Try bpi --help or bpu --help to see How to Use. \e[0m \n" &&
echo
