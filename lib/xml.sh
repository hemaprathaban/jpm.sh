# -*- mode: sh; tab-width: 4; coding: utf-8 -*-
# vim: ts=4 noet ai ft=sh

# XML generation
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


jpmXmlEscape () {
	# No &apos; don't use inside '...'
	sed 's/&/\&amp;/g ; s/</\&lt;/g ; s/>/\&gt;/g ; s/"/\&quot;/g ; s/'"'"'/\&apos;/g'
}

jpmXmlEscapeArg () {
	printf %s "$1" | jpmXmlEscape
}

