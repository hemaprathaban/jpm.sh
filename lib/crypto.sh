# -*- mode: sh; tab-width: 4; coding: utf-8 -*-
# vim: ts=4 noet ai ft=sh

# Cryptography functions for JPM.sh
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


jpmCryptoSha256 () {
	# GNU Coreutils first
	which sha256sum >/dev/null && {
		sha256sum | awk '{print $1}'
	} || {
		# If installed as a system library...
		openssl sha256 | awk '{print $2}'
	}
}

