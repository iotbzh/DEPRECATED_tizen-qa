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
	echo "$2 and $4 already present"
    else
	sed -i "s/$1/$2/g" /etc/xdg/weston/weston.ini
	sed -i "s/$3/$4/g" /etc/xdg/weston/weston.ini
	chsmack -a _ /etc/xdg/weston/weston.ini
	chmod 666 /dev/uinput
	systemctl restart display-manager-run.service
	systemctl restart user@9999.service
	systemctl restart user@5000.service
	systemctl restart user@5001.service
	systemctl restart user@5002.service
	systemctl restart user@5003.service
	sleep 5;
    fi
}
zypper -n in -f wayland-fits-master
replace_value $VALUE1 $VALUE2 $VALUE3 $VALUE4
