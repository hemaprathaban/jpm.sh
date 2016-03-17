# -*- sh; tab-width: 4; coding: utf-8 -*-
# vim: ts=4 noet ai ft=sh

# Run Firefox with an (unpackless) add-on.
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


# @private
jpmFirefoxGenPrefsJs () {
	cat <<EOF
user_pref("app.update.auto", false);
user_pref("app.update.enabled", false);
user_pref("app.update.lastUpdateTime.browser-cleanup-thumbnails", 0);
user_pref("app.update.lastUpdateTime.xpi-signature-verification", 0);
user_pref("browser.EULA.3.accepted", true);
user_pref("browser.EULA.override", true);
user_pref("browser.bookmarks.restore_default_bookmarks", false);
user_pref("browser.cache.disk.filesystem_reported", 1);
user_pref("browser.cache.disk.smart_size.first_run", false);
user_pref("browser.cache.frecency_experiment", 3);
user_pref("browser.dom.window.dump.enabled", true);
user_pref("browser.download.manager.showWhenStarting", false);
user_pref("browser.laterrun.enabled", true);
user_pref("browser.link.open_external", 2);
user_pref("browser.link.open_newwindow", 2);
user_pref("browser.migration.version", 36);
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.newtabpage.enhanced", false);
user_pref("browser.offline", false);
user_pref("browser.pagethumbnails.storage_version", 3);
user_pref("browser.places.smartBookmarksVersion", 7);
user_pref("browser.safebrowsing.enabled", false);
user_pref("browser.safebrowsing.malware.enabled", false);
user_pref("browser.safebrowsing.provider.0.gethashURL", "data:,safebrowsing-dummy-gethash");
user_pref("browser.safebrowsing.provider.0.keyURL", "data:,safebrowsing-dummy-newkey");
user_pref("browser.safebrowsing.provider.0.updateURL", "data:,safebrowsing-dummy-update");
user_pref("browser.search.suggest.enabled", false);
user_pref("browser.search.update", false);
user_pref("browser.sessionstore.resume_from_crash", false);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.startup.homepage", "about:blank");
user_pref("browser.startup.page", 0);
user_pref("browser.tabs.warnOnClose", false);
user_pref("browser.tabs.warnOnOpen", false);
user_pref("devtools.chrome.enabled", true);
user_pref("devtools.debugger.remote-enabled", true);
user_pref("devtools.errorconsole.enabled", true);
user_pref("dom.apps.reset-permissions", true);
user_pref("dom.disable_open_during_load", false);
user_pref("dom.max_script_run_time", 30);
user_pref("dom.mozApps.used", true);
user_pref("experiments.activeExperiment", false);
user_pref("extensions.autoDisableScopes", 10);
user_pref("extensions.blocklist.enabled", false);
user_pref("extensions.blocklist.pingCountVersion", 0);
user_pref("extensions.blocklist.url", "data:,extensions-dummy-blocklistURL");
user_pref("extensions.enabledScopes", 5);
user_pref("extensions.getAddons.cache.enabled", false);
user_pref("extensions.installDistroAddons", false);
user_pref("extensions.pendingOperations", false);
user_pref("extensions.sdk.console.logLevel", "info");
user_pref("extensions.systemAddonSet", "{\"schema\":1,\"addons\":{}}");
user_pref("extensions.ui.dictionary.hidden", true);
user_pref("extensions.ui.experiment.hidden", true);
user_pref("extensions.ui.lastCategory", "addons://list/extension");
user_pref("extensions.ui.locale.hidden", true);
user_pref("extensions.update.enabled", false);
user_pref("extensions.update.notifyUser", false);
user_pref("extensions.update.url", "data:,extensions-dummy-updateURL");
user_pref("extensions.webservice.discoverURL", "data:,extensions-dummy-discoveryURL");
user_pref("network.cookie.prefsMigrated", true);
user_pref("network.http.max-connections-per-server", 10);
user_pref("network.http.phishy-userpass-length", 255);
user_pref("network.manage-offline-status", false);
user_pref("network.predictor.cleaned-up", true);
user_pref("prompts.tab_modal.enabled", false);
user_pref("security.fileuri.origin_policy", 3);
user_pref("security.fileuri.strict_origin_policy", false);
user_pref("security.warn_entering_secure", false);
user_pref("security.warn_entering_secure.show_once", false);
user_pref("security.warn_entering_weak", false);
user_pref("security.warn_entering_weak.show_once", false);
user_pref("security.warn_leaving_secure", false);
user_pref("security.warn_leaving_secure.show_once", false);
user_pref("security.warn_submit_insecure", false);
user_pref("security.warn_viewing_mixed", false);
user_pref("security.warn_viewing_mixed.show_once", false);
user_pref("signon.importedFromSqlite", true);
user_pref("signon.rememberSignons", false);
user_pref("startup.homepage_welcome_url", "about:blank");
user_pref("toolkit.networkmanager.disable", true);
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.prompted", 2);
user_pref("toolkit.telemetry.rejected", true);
user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);
user_pref("urlclassifier.updateinterval", 172800);
user_pref("webdriver_accept_untrusted_certs", true);
user_pref("webdriver_assume_untrusted_issuer", true);
user_pref("webdriver_enable_native_events", true);
user_pref("xpinstall.signatures.required", false);
EOF
}


# jpmFirefoxStart <firefoxBinPath> <xpiId>
# Note: Intentional use of subshell
jpmFirefoxStart () (
	aFirefoxBin=$1
	aXpiId=$2
	
	jpmConsoleLog "runner: Preparing a temporary profile..."
	tmpDir=`jpmTempDirCreate`
	[ -d "$tmpDir" ] || {
		jpmConsoleError "runner: Failed to create a temporary directory"
		exit 1 # Exits this subshell
	}
	
	tmpHomeDir=$tmpDir/home
	tmpTmpDir=$tmpDir/tmp
	mkdir -p "$tmpHomeDir" "$tmpTmpDir" >&2
	
	TMP=$tmpTmpDir
	TMPDIR=$tmpTmpDir
	TEMP=$tmpTmpDir
	TEMPDIR=$tmpTmpDir
	HOME=$tmpHomeDir
	export TMP TMPDIR TEMP TEMPDIR HOME
	
	# Create profile directory
	profileDir=$HOME/profile.default
	extDir=$profileDir/extensions
	mkdir -p "$extDir" >&2
	[ -d "$extDir" ] || {
		jpmConsoleError "runner: Failed to create a profile directory"
		exit 1 # Exits this subshell
	}
	
	jpmFirefoxGenPrefsJs > "$profileDir/prefs.js"
	
	jpmConsoleLog "runner: Installing .xpi, receiving data..."
	[ "$aXpiId" ] && {
		cat > "$extDir/$aXpiId.xpi"
	}
	
	jpmConsoleLog "runner: Profile set up. Starting $gBrowserName..."
	
	#cd "$HOME"
	"$aFirefoxBin" -no-remote -profile "$profileDir"
	cd /
	
	jpmConsoleLog "runner: $gBrowserName finished. Deleting the temporary profile..."
	rm -rf "$tmpDir"
)

