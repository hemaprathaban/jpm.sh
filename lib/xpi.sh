# -*- sh; tab-width: 4; coding: utf-8 -*-
# vim: ts=4 noet ai ft=sh

# Build a .xpi package.
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


# Dependencies
. "$gLibDir/tmpdir.sh"
. "$gLibDir/git.sh"
. "$gLibDir/xml.sh"
. "$gLibDir/crypto.sh"
. "$gLibDir/json.sh"

# jpmXpiGetId
jpmXpiGetId () {
	printf %s "@${addon_id}"
}

# jpmXpiBuild <isProdBuild> [<printPackageName>]
# Note: Intentional use of subshell
jpmXpiBuild () (
	isProdBuild=$1
	printPackageName=$2
	
	[ -d "$addon_src_dir" ] || {
		jpmConsoleError "xpi-build: No such directory: $addon_src_dir"
		exit 1 # Exits this subshell
	}
	srcDir=`cd "$addon_src_dir" ; pwd`
	
	# Normalize build environment
	unset LANGUAGE DISPLAY USER
	LANG=C
	LC_ALL=C
	
	[ "$addon_main_path" ] || addon_main_path=main.js
	
	tmpDir=`jpmTempDirCreate`
	[ -d "$tmpDir" ] || {
		jpmConsoleError "xpi-build: Failed to create a temporary directory"
		exit 1 # Exits this subshell
	}
	
	tmpHomeDir="$tmpDir/home"
	tmpTmpDir="$tmpDir/tmp"
	mkdir -p "$tmpHomeDir" "$tmpTmpDir" >&2
	
	TMP="$tmpTmpDir"
	TMPDIR="$tmpTmpDir"
	TEMP="$tmpTmpDir"
	TEMPDIR="$tmpTmpDir"
	HOME="$tmpHomeDir"
	export TMP TMPDIR TEMP TEMPDIR HOME
	
	# Create build directory
	buildDir="$tmpDir/build"
	mkdir -p "$buildDir" >&2
	cp -r "$srcDir"/* "$buildDir/" >&2
	
	versionGit=''
	gitHash=`jpmGitGetHash`
	[ "$gitHash" ] && {
		versionGit="+git.`printf %s "$gitHash" | head -c8`"
		uncomitted=''
		jpmGitUncomitted && {
			versionGit=${versionGit}+uncommitted
			uncomitted=+uncomitted
		}
		printf '//Build:git-%s%s' "$gitHash" "$uncomitted" \
			>> "$buildDir/${addon_main_path}"
		
		[ "$addon_release_phase" = stable ] && versionGit=''
	}
	version=${addon_version}${versionGit}
	
	[ "$isProdBuild" ] && {
		jpmConsoleLog "xpi-build: Excluding development files..."
		rm -fr "$buildDir/debug.js" "$buildDir/data/debug" >&2
		
		preprocess_sed='s|^\s\{0,\}/*!_DEBUGONLY_!*/.*||'
		find "$buildDir" -name '*.js' -exec \
			sh -c 'sed "$1" < "$2" > "$2.tmp" && mv -f "$2.tmp" "$2"' \
				-- "$preprocess_sed" {} \;
		
		# TODO: implement optional minification here
	:;} || jpmConsoleLog "xpi-build: Debugging build enabled."
	
	addon_preferences_json=''
	[ -f "${addon_preferences_json_path}" ] && \
		addon_preferences_json=`cat "${addon_preferences_json_path}"`
	
	addon_translators_json=''
	[ -f "${addon_translators_json_path}" ] && \
		addon_translators_json=`cat "${addon_translators_json_path}"`
	
	cd "$buildDir" >&2
	jpmConsoleLog "xpi-build: Generating the necessary files..."
	id=`jpmXpiGetId`
	jpmXpiGenInstallRdf "$id" "$version" > ./install.rdf
	cp "$gDepsDir/jpm-core/data/bootstrap.js" ./bootstrap.js >&2
	
	jpmXpiGenPackageJson "$id" "$version" > ./package.json
	
	
	jpmConsoleLog "xpi-build: Zipping files..."
	# Skipping directory entries
	# Assuming no space characters in file names
	zip ../build.zip `find . -type f` >/dev/null
	cd .. >&2
	
	
	[ "$isProdBuild" ] && {
		# Postprocessing
		which advzip >/dev/null && {
			jpmConsoleLog "xpi-build: Recompressing..."
			advzip -z -4 -i 500 ./build.zip >/dev/null
		:;} || jpmConsoleNotice "xpi-build: Skipping: AdvanceCOMP (not found)"
		
		which strip-nondeterminism >/dev/null && {
			jpmConsoleLog "xpi-build: Trying to strip nondeterminism (experimental)..."
			strip-nondeterminism -t zip ./build.zip >&2
		} || {
			jpmConsoleWarn "xpi-build: NOTE: Deterministic build disabled (strip-nondeterminism needed)..."
		}
		
		jpmConsoleNotice "xpi-build: SHA2-256: `jpmCryptoSha256 < ./build.zip`"
	}
	
	
	# Output the built package
	jpmConsoleLog "xpi-build: Streaming the built package..."
	cat ./build.zip
	
	
	# Clean up temporary files
	jpmConsoleLog "xpi-build: Cleaning up temporary files to build .xpi ..."
	cd "$srcDir/.." >&2
	rm -fr "$tmpDir" >&2
	
	
	# Print filename
	[ "$printPackageName" ] && printf %s "${id}-${version}" >&3
)

# jpmXpiGenPackageJson <id> <version>
jpmXpiGenPackageJson () {
	printf '{"title":%s,"name":%s,"id":%s,"version":%s' \
		"`jpmJsonArgToStringValue "$addon_name"`" \
		"`jpmJsonArgToStringValue "$addon_id"`" \
		"`jpmJsonArgToStringValue "$1"`" \
		"`jpmJsonArgToStringValue "$2"`"
	
	printf ',"description":%s,"main":%s,"author":%s,"license":%s' \
		"`jpmJsonArgToStringValue "$addon_description"`" \
		"`jpmJsonArgToStringValue "$addon_main_path"`" \
		"`jpmJsonArgToStringValue "$addon_author"`" \
		"`jpmJsonArgToStringValue "$addon_license_id"`"
	
	printf ',"engines":{"firefox":%s' \
		"`jpmJsonArgToStringValue "$addon_firefox_version"`"
	
	[ "$addon_fennec_version" ] && printf ',"fennec":%s' \
		"`jpmJsonArgToStringValue "$addon_fennec_version"`"
	
	[ "$addon_thunderbird_version" ] && printf ',"thunderbird":%s' \
		"`jpmJsonArgToStringValue "$addon_thunderbird_version"`"
	
	[ "$addon_seamonkey_version" ] && printf ',"seamonkey":%s' \
		"`jpmJsonArgToStringValue "$addon_seamonkey_version"`"
	
	printf '}'
	printf ',"permissions":{"multiprocess":true'
	[ "$addon_support_private_browsing" ] && printf ',"private-browsing":true'
	printf '}'
	
	[ "$addon_preferences_json" ] && printf ',"preferences":%s' \
		"`jpmJsonNormalizeArg "$addon_preferences_json"`"
	
	[ "$addon_translators_json" ] && printf ',"translators":%s' \
		"`jpmJsonNormalizeArg "$addon_translators_json"`"
	
	[ "$addon_unpack" ] && printf ',"unpack":true'
	
	printf '}'
}

# @private
# jpmXpiGenInstallRdfTarget <uuid> <minVersion> <maxVersion>
jpmXpiGenInstallRdfTarget () {
	cat <<RDF
<em:targetApplication><Description>
<em:id>${1}</em:id>
<em:minVersion>${2}</em:minVersion>
<em:maxVersion>${3}</em:maxVersion>
</Description></em:targetApplication>
RDF
}

# jpmXpiGenInstallRdf <id> <version>
jpmXpiGenInstallRdf () {
	uuidFirefox='{ec8030f7-c20a-464f-9b0e-13a3a9e97384}'
	uuidFennec='{aa3c5121-dab2-40e2-81ca-7ea25febc110}'
	uuidThunderbird='{3550f703-e582-4d05-9a08-453d09bdfdc6}'
	uuidSeamonkey='{92650c4d-4b8e-4d2a-b7eb-24ecf4f6b63a}'
	
	# XXX: hardcoded
	targetFirefox=`jpmXpiGenInstallRdfTarget "$uuidFirefox" '38.0a1' '43.0'`
	targetFennec=''
	targetThunderbird=''
	targetSeamonkey=''
	[ "${addon_fennec_version}" ] && \
		targetFennec=`jpmXpiGenInstallRdfTarget "$uuidFennec" '38.0a1' '43.0'`
	[ "${addon_thunderbird_version}" ] && \
		targetThunderbird=`jpmXpiGenInstallRdfTarget "$uuidThunderbird" '38.0' '43.0'`
	[ "${addon_seamonkey_version}" ] && \
		targetSeamonkey=`jpmXpiGenInstallRdfTarget "$uuidSeamonkey" '2.38' '2.43'`
	
	cat <<RDF
<?xml version="1.0" encoding="utf-8"?>
<RDF xmlns="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:em="http://www.mozilla.org/2004/em-rdf#">
<Description about="urn:mozilla:install-manifest">
<em:id>`jpmXmlEscapeArg "$1"`</em:id>
<em:type>2</em:type>
<em:bootstrap>true</em:bootstrap>
<em:unpack>`jpmToBoolValue "${addon_unpack}"`</em:unpack>
<em:version>`jpmXmlEscapeArg "$2"`</em:version>
<em:name>${addon_name}</em:name>
<em:description>${addon_description}</em:description>
<em:creator>${addon_author}</em:creator>
<em:optionsURL>data:text/xml,&lt;placeholder/&gt;</em:optionsURL>
<em:optionsType>2</em:optionsType>
<em:multiprocessCompatible>true</em:multiprocessCompatible>
${targetFirefox}${targetFennec}${targetThunderbird}${targetSeamonkey}
</Description>
</RDF>
RDF
}

