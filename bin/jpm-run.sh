#!/bin/sh
# -*- sh; tab-width: 4; coding: utf-8 -*-
# vim: ts=4 noet ai ft=sh

# Run an SDK-based Firefox add-on off the source code.
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


# Command line arguments
# May be empty
firefoxBinPath=$1
[ -x "$firefoxBinPath" ] && [ -f "$firefoxBinPath" ] || {
	which firefox >/dev/null && firefoxBinPath=`which firefox` || {
		jpmConsoleError "Firefox binary not found. Please specify a correct path."
		exit 1
	}
}


# JPM.sh directories
gBinDir=`dirname "$0"`
gBinDir=`cd "$gBinDir" ; pwd`
gLibDir=${gBinDir}/../lib
gDepsDir=${gBinDir}/../deps


# Add-on files
gManifestPath=./version_info


# Include needed scripts
. "$gLibDir/defaults.sh"
. "$gLibDir/console.sh"
. "$gLibDir/xpi.sh"
. "$gLibDir/runner.sh"


# Build a .xpi package

# Load manifest data
jpmConsoleNotice "Loading: $gManifestPath"
[ -f "$gManifestPath" ] || {
	jpmConsoleError "No such file: $gManifestPath"
	exit 1
}

. "$gManifestPath"
xpiId=`jpmXpiGetId`

# Debug build
isProdBuild=''

jpmConsoleNotice "Building .xpi and launching Firefox..."
jpmXpiBuild "$isProdBuild" | jpmFirefoxStart "$firefoxBinPath" "$xpiId"

jpmConsoleNotice "Done: jpm-run.sh"

