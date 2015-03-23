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

VALUE1="modules=desktop-shell.so"
VALUE2="modules=desktop-shell.so,weston-wfits.so"
VALUE3="animation=zoom"
VALUE4="animation=none"

function replace_value {

    if grep -q "$2\|$4" /etc/xdg/weston/weston.ini ;then
	sed -i "s/$2/$1/g" /etc/xdg/weston/weston.ini
	sed -i "s/$4/$3/g" /etc/xdg/weston/weston.ini
		systemctl restart display-manager-run.service
		systemctl restart user@9999.service
		systemctl restart user@5000.service
		systemctl restart user@5001.service
		systemctl restart user@5002.service
		systemctl restart user@5003.service
		sleep 5;
	else
		echo "$1 and $3 already present"
	fi
}
zypper -n rm wayland-fits-master
replace_value $VALUE1 $VALUE2 $VALUE3 $VALUE4
