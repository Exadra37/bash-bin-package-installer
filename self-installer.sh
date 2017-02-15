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

package_version="0.0.1.0"
home_bin_dir=/home/"${USER}"/bin
install_dir="${home_bin_dir}"/vendor/exadra37-bash
git_url=https://github.com/exadra37-bash/bin-package-installer.git

mkdir -p "${install_dir}" &&
cd "${install_dir}" &&
git clone -q --depth 1 -b "${package_version}" "${git_url}" . &&
git checkout -q -b "${package_version}" &&
ln -s "${install_dir}"/bin-package-installer/src/installer.sh "${home_bin_dir}"/bpi
