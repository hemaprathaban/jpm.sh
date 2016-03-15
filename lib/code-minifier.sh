# -*- sh; tab-width: 4; coding: utf-8 -*-
# vim: ts=4 noet ai ft=sh

# Minify various code
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


# jpmMinifyHtml <dir>
jpmMinifyHtml () {
	aDir=$1
	jpmConsoleLog "Minifying HTML files..."
	
	# Remove empty lines
	html_egrep_v='^\s*$|vim:'
	find "$aDir" -type f -name '*.html' -execdir \
		sh -c 'egrep -v "$2" "$1" > "$1.tmp" && mv -f "$1.tmp" "$1"' \
			-- {} "$html_egrep_v" \;
}

# jpmMinifyCss <dir>
jpmMinifyCss () {
	aDir=$1
	# CSS minifier is aggressive.
	jpmConsoleLog "Minifying CSS files..."
	css_egrep_v='^\s*$|vim:'
	css_sed='s/\s\{1,\}/ /g ; s/\s*\([{:>+,;]\)\s*/\1/g ; s/;}/}/g'
	find "$aDir" -type f -name '*.css' -execdir \
		sh -c \
		'egrep -v "$2" "$1" | tr -d "\t\n" | sed "$3" > "$1.tmp" && mv -f "$1.tmp" "$1"' \
			-- {} "$css_egrep_v" "$css_sed" \;
}

# jpmMinifyJs <dir>
jpmMinifyJs () {
	aDir=$1
	# This new JS minifier tries to preserve line numbers.
	# It just removes some spaces and comments.
	jpmConsoleLog "Minifying JS files..."
	js_sed='s/^\s*$//'
	find "$aDir" -type f -name '*.js' -execdir \
		sh -c \
		'sed "$1" < "$2" > "$2.tmp" && mv -f "$2.tmp" "$2"' \
			-- "$js_sed" {} \;
}

