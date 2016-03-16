# JPM.sh
Hack **SDK-based Firefox add-ons without Node.js**. Yes, Node.js and 
a huge tree of dependencies in NPM is quite a bit painful.

Pure `/bin/sh` solution to Firefox add-on development!
We carefully maintain this package to keep it as compatible as possible with 
the official Node.js-based `JPM`.

This is part of the Desktopd project.

## Usage
	$ cat <<EOF > version_info
	addon_src_dir=src
	addon_main_path=main.js
	
	addon_id='foobar-addon'
	addon_version='0.1.0~a2'
	addon_release_phase='stable'
	addon_name='FooBar Add-on'
	addon_author='FooBar Add-on Foundation, Inc'
	addon_description='This is an example add-on.'
	addon_website_uri='https://optional.example/'
	EOF
	$ export PATH=/path/to/jpm.sh/bin:$PATH
	$ jpm-run.sh /path/to/firefox
or ...

	$ jpm-build.sh > package.xpi

See [Used by](#used-by) for real-world examples.

* Only multiprocess (e10s) compatible add-ons can be built using this tool.

## Requirements
* POSIX-compatible `/bin/sh`
* Common POSIX command-line utilities: `grep`, `sed`, ...
* For actually building a `.xpi`: `zip` command-line tool (which is widely
available)
* (Optional) Time-consuming good compression with AdvanceCOMP utility.
* (Optional) Integration with `git`

## Used by
* [Zombie Navigator](https://addons.mozilla.org/en-US/firefox/addon/zombie-navigator/)
* [ClickGuard](https://addons.mozilla.org/en-US/firefox/addon/clickguard/)

## TODO
* More documentation work needed.
* Unimplemented: em:translator

## License
Please consult [FSF](https://www.fsf.org/) for whether using this program to
build your add-ons makes them fall under the GNU (A)GPL 
(which is probably not).

To avoid confusion, we explicitly allow licensing built add-ons under GNU GPL, 
version 3 or later.

Using this program as part of an online application makes the whole 
application under the GNU AGPLv3 or later. This is a good thing, so we 
encourage anyone interested to use that way.


	JPM.sh -- Hack SDK-based Firefox add-ons without Node.js
	Copyright (C) 2016 the Desktopd developers

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU Affero General Public License as
	published by the Free Software Foundation, either version 3 of the
	License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Affero General Public License for more details.

	You should have received a copy of the GNU Affero General Public License
	along with this program.  If not, see <https://www.gnu.org/licenses/>.


This program uses the tiny package `jpm-core`, which is available under the
terms of the Mozilla Public License, version 2.0. Since the MPL is compatible
with the GNU GPL (unless otherwise stated), which allows embedding inside a GNU
AGPL-licensed work, the program as a whole is available under the GNU AGPL
version 3 or later.

<!-- vim: ts=4 noet ai -->
