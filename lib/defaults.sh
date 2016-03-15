# -*- sh; tab-width: 4; coding: utf-8 -*-
# vim: ts=4 noet ai ft=sh

# Default values of add-on manifest variables.
# This file is part of JPM.sh.
# Copyright (C) 2016 the Desktopd developers
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


# Basic information

addon_id=''
addon_version=''
addon_release_phase='stable'
addon_name=''
addon_license_id='GPL-3.0+'


# Additional information

addon_author=''
addon_description=''
addon_website_uri=''


# Source code structure

addon_src_dir='src'
addon_main_path='main.js'

# JPM.sh does not check JSON syntax.
# Ignored if no such files exist.
addon_preferences_json_path='preferences.json'
addon_translators_json_path='translators.json'


# Compatibility options

addon_firefox_version='>=38.0a1'
addon_fennec_version=''
addon_thunderbird_version=''
addon_seamonkey_version=''
addon_unpack=''
addon_support_private_browsing=''


# Build options
addon_minify_html=''
addon_minify_css=''
addon_minify_js=''


# Utility functions

jpmToBoolValue () {
	[ "$1" ] || {
		printf 'false'
		return
	}
	
	case "$1" in
		0|false|no|No|NO|False|FALSE|off|Off|OFF)
			printf 'false'
			return
			;;
	esac
	
	printf 'true'
}

