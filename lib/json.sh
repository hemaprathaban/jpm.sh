# -*- sh; tab-width: 4; coding: utf-8 -*-
# vim: ts=4 noet ai ft=sh

# JSON functions for JPM.sh
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


sedPath=$gLibDir/json-escape.sed

jpmJsonGenSed () {
# Create a sed script
{
printf 's/\\\\/\\\\\\\\/g\n' > "$sedPath"
printf 's/"/\\\\"/g\n' >> "$sedPath"

printf 's/\0/\\\\u0000/g\n' >> "$sedPath"
printf 's/\1/\\\\u0001/g\n' >> "$sedPath"
printf 's/\2/\\\\u0002/g\n' >> "$sedPath"
printf 's/\3/\\\\u0003/g\n' >> "$sedPath"
printf 's/\4/\\\\u0004/g\n' >> "$sedPath"
printf 's/\5/\\\\u0005/g\n' >> "$sedPath"
printf 's/\6/\\\\u0006/g\n' >> "$sedPath"
printf 's/\7/\\\\u0007/g\n' >> "$sedPath"
printf 's/\10/\\\\b/g\n' >> "$sedPath"
printf 's/\11/\\\\t/g\n' >> "$sedPath"
#printf ':a\nN\n$!ba\ns/\\n/\\\\n/g\n' >> "$sedPath"
printf 's/\13/\\\\u000b/g\n' >> "$sedPath"
printf 's/\14/\\\\f/g\n' >> "$sedPath"
printf 's/\15/\\\\r/g\n' >> "$sedPath"
printf 's/\16/\\\\u000e/g\n' >> "$sedPath"
printf 's/\17/\\\\u000f/g\n' >> "$sedPath"
printf 's/\20/\\\\u0010/g\n' >> "$sedPath"
printf 's/\21/\\\\u0011/g\n' >> "$sedPath"
printf 's/\22/\\\\u0012/g\n' >> "$sedPath"
printf 's/\23/\\\\u0013/g\n' >> "$sedPath"
printf 's/\24/\\\\u0014/g\n' >> "$sedPath"
printf 's/\25/\\\\u0015/g\n' >> "$sedPath"
printf 's/\26/\\\\u0016/g\n' >> "$sedPath"
printf 's/\27/\\\\u0017/g\n' >> "$sedPath"
printf 's/\30/\\\\u0018/g\n' >> "$sedPath"
printf 's/\31/\\\\u0019/g\n' >> "$sedPath"
printf 's/\32/\\\\u001a/g\n' >> "$sedPath"
printf 's/\33/\\\\u001b/g\n' >> "$sedPath"
printf 's/\34/\\\\u001c/g\n' >> "$sedPath"
printf 's/\35/\\\\u001d/g\n' >> "$sedPath"
printf 's/\36/\\\\u001e/g\n' >> "$sedPath"
printf 's/\37/\\\\u001f/g\n' >> "$sedPath"
} 2>/dev/null
}

# This does not sort keys.
jpmJsonNormalize () {
	egrep -v '^\s*$' | sed 's/^\s*// ; s/":\s*/":/g ; s/,\s*"/,"/g' | tr -d '\n'
}

jpmJsonNormalizeArg () {
	printf %s "$1" | jpmJsonNormalize
}

jpmJsonToStringValue () {
	printf '"'
	sed -f "$sedPath" | awk 'FNR == 1 { printf "%s", $0 ; while ( getline == 1 ) { printf "\\n%s", $0; } ; }' # | awk 1 ORS='\\n'
	printf '"'
}

jpmJsonArgToStringValue () {
	printf %s "$1" | jpmJsonToStringValue
}

