# start-tcl: n

# Friends and Ignore Lists
#
# This program is (c) 2006 by Spirit <thehiddenspirit@hotmail.com>
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the Free
# Software Foundation; either version 2.1 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
# details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA. You can also consult
# the terms of the license at:
#
#		<http://www.gnu.org/copyleft/lesser.html>

namespace eval Friends {

	# defaults (if you have scripts.conf, use it to change values)
	variable SERVER_UPDATING 1
	variable LIST_LIMIT 50

	variable VERSION 0.60
	variable USE_CONF_FILE 1

	if { $USE_CONF_FILE } { ::Custom::LoadConf }

	if { [info procs ::Custom::ReadOnline] != "" } {
		proc Commands { player cargs } {
			set count 0
			set answer "FRIENDLIST_UPDATE"
			Custom::ReadOnline
			foreach friend_name $cargs {
				# name race class level map zone
				append answer "," [join [Custom::GetOnlineData $friend_name] ","]
				if { [incr count] >= $::Friends::LIST_LIMIT } { break }
			}
			return $answer
		}
		if { !$SERVER_UPDATING } { proc Commands { args } {} }
		Custom::AddCommand "friends" "Friends::Commands"
	} else {
		proc Commands { args } {}
	}

	::StartTCL::Provide
}
