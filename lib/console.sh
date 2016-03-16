# -*- sh; tab-width: 4; coding: utf-8 -*-
# vim: ts=4 noet ai ft=sh

# Console logging helper functions
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


# TODO: Colors not good
TERM_OKBLUE='\033[2;94m' #'\033[94m'
TERM_OKGREEN='\033[2;3;32m'
TERM_WARNING='\033[2;7;93m' #'\033[4;33m'
TERM_FAIL='\033[101;97m' #'\033[4;91m'
TERM_UNIMPORTANT='\033[95m'
TERM_IMPORTANT='\033[1;35m'
TERM_BOLD='\033[1m'
TERM_BOLDLINE='\033[1;4m'

TERM_ENDC='\033[0m'


# @deprecated
progressFilter () {
	[ -t 2 ] && tr '\n' '\r' >&2 || cat >&2
}

jpmConsoleLog () {
	[ "$JPM_SILENT" ] && return
	[ -t 2 ] && [ -z "$ZOMBIE_NOCOLOR" ] && {
		printf "${TERM_UNIMPORTANT}[%s]${TERM_ENDC} ${TERM_OKBLUE}%s${TERM_ENDC}\n"	"`date`" "$@" >&2
	:;} || {
		echo "[`date`] $@" >&2
	}
}

jpmConsoleNotice () {
	[ -t 2 ] && [ -z "$JPMSH_NOCOLOR" ] && {
		printf "${TERM_UNIMPORTANT}[%s]${TERM_ENDC} ${TERM_BOLD}Notice:${TERM_ENDC} ${TERM_OKGREEN}%s${TERM_ENDC}\n"	"`date`" "$@" >&2
	:;} || {
		echo "[`date`] Notice: $@" >&2
	}
}

jpmConsoleWarn () {
	[ -t 2 ] && [ -z "$JPMSH_NOCOLOR" ] && {
		printf "${TERM_IMPORTANT}[%s]${TERM_ENDC} ${TERM_WARNING} Warning: ${TERM_ENDC} ${TERM_BOLD}%s${TERM_ENDC}\n"	"`date`" "$@" >&2
	:;} || {
		echo "[`date`] Warning: $@" >&2
	}
}

jpmConsoleError () {
	[ -t 2 ] && [ -z "$JPMSH_NOCOLOR" ] && {
		printf "${TERM_IMPORTANT}[%s]${TERM_ENDC} ${TERM_FAIL} Error: ${TERM_ENDC} ${TERM_BOLDLINE}%s${TERM_ENDC}\n"	"`date`" "$@" >&2
	:;} || {
		echo "[`date`] Error: $@" >&2
	}
}

