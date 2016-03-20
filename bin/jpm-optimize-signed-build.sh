#!/bin/sh
# -*- mode: sh; tab-width: 4; coding: utf-8 -*-
# vim: ts=4 noet ai ft=sh

# The state-of-the-art optimization against a signed Firefox add-on without
# breaking the signature.
#
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


# JPM.sh directories
gBinDir=`dirname "$0"`
gBinDir=`cd "$gBinDir" ; pwd`
gLibDir=${gBinDir}/../lib
gDepsDir=${gBinDir}/../deps


# Include needed scripts
. "$gLibDir/console.sh"

[ -f "$1" ] || {
	jpmConsoleError "No such file: $1"
	exit 1
}

which advzip >/dev/null 2>&1 && {
	jpmConsoleNotice "Recompressing the archive with 'advzip'..."
	
	# Insanely slow `deflate` compression
	advzip -k -z -4 -i 2000 "$1"
:;} || {
	jpmConsoleError "Required but not found: advzip (AdvanceCOMP)"
	exit 1
}

