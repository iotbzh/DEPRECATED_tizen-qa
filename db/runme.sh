#!/bin/bash -x

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#
# Authors: Ewan Le Bideau-Canevet <ewan.lebideau-canevet@open.eurogiciel.org>

CMD="$@"
tmpscript=$(mktemp)

trap "rm -rf $tmpscript" INT QUIT TERM STOP EXIT
echo "#!/bin/bash " > $tmpscript
tr '\0' '\n' </proc/$(pgrep tz-launcher -u guest)/environ | awk 'FS="=" {if ($1 != "_") { print "export",$0;} }' >> $tmpscript
echo export PATH=$QAPATH:\$PATH >> $tmpscript
echo env >> $tmpscript
echo $CMD >> $tmpscript
chmod 777 $tmpscript
su - guest -c $tmpscript
if [ $? -eq 0 ]; then
	exit 0
else
	exit 1
fi
