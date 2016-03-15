# -*- sh; tab-width: 4; coding: utf-8 -*-
# vim: ts=4 noet ai ft=sh

# Create a temporary directory.
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


# jpmTempDirCreate [<prefix>]
jpmTempDirCreate () {
	[ -d "$TMPDIR" ] && [ -w "$TMPDIR" ] && [ -x "$TMPDIR" ] && {
		_tmpBaseDir=$TMPDIR
	} || {
		[ -d /dev/shm ] && [ -w /dev/shm ] && [ -x /dev/shm ] \
			&& _tmpBaseDir=/dev/shm || _tmpBaseDir=/tmp
	}
	[ "$1" ] && _prefix=_$1
	
	mktemp -d "${_tmpBaseDir}"/.jpm-sh"${_prefix}".XXXXXX
}

