#!/bin/sh
# -*- sh; tab-width: 4; coding: utf-8 -*-
# vim: ts=4 noet ai ft=sh

# Build an SDK-based Firefox add-on.
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
printPackageName=$1


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


# Build a .xpi package

# Load manifest data
jpmConsoleLog "Loading: $gManifestPath"
[ -f "$gManifestPath" ] || {
	jpmConsoleError "No such file: $gManifestPath"
	exit 1
}

. "$gManifestPath"

# Production build
isProdBuild=1

jpmConsoleLog "Building .xpi ..."
# The package is streamed into STDOUT
# And the package name into fd #3 (if requested)
jpmXpiBuild "$isProdBuild" "$printPackageName"

jpmConsoleNotice "Done: jpm-build.sh"

# name=`{ jpm-build.sh 1 > tmp.zip ; } 3>&1`
# mv tmp.zip "$name.xpi"

