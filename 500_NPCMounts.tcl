# StartTCL: n
#
# NPC Mount script
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


# Description:
#
# This script uses waypoints to have NPC Mounts, so it works even after respawn.
#
#
# Instructions:
#
# New installation:
# 1) Make a backup of world.save and waypoints.scp.
# 2) Copy this file to the tcl directory.
# 3) Start the server or reload the scripts with ".retcl".
# 4) Reboot the server.
#
# Upgrading / Adding NPC Mounts:
# 1) Spawn NPCs and/or edit MountArray.
# 2) Delete waypoints_mounts.scp.
# 3) Start the server or reload the scripts with ".retcl".
# 4) Reboot the server.

#
# TODO:
#
# .mount command, targeting an NPC or spawnpoint
#

namespace eval ::Mount {

	variable VERSION 0.20

	variable INSTALL_ON_START 1
	variable POINT_START 20000

	variable USE_CONF 1
	variable WAY_FILE "scripts/waypoints_mounts.scp"
	variable WORLD_FILE "saves/world.save"
	variable MIN_CUSTOM 1.95

	variable MountArray

	# creature entry -> mount spell
	array set MountArray {
		464 16083
		466 16083
		469 458
		1121 16081
		1279 6898
		1515 5784
		2149 16056
		2151 16056
		2612 6648
		2738 6648
		3836 6898
		4752 6653
		5682 458
		5724 5784
		5725 5784
		5797 16055
		5798 16056
		5799 16055
		5800 16083
		6388 17465
		6390 17465
		10602 22723
		10603 22723
		10604 16055
		10605 22723
		10606 16055
		10676 578
		10682 6654
		12790 6898
		12864 16080
		12996 6898
		13577 6898
		14376 578
		14377 23251
		14378 16055
		14379 16055
		14380 16055
		15857 13819
		15862 22720
	}

	# mount script used in waypoints_mounts.scp
	proc Waypoint { npc } {
		variable MountArray
		set entry [::GetEntry $npc]

		if { [info exists MountArray($entry)] } {
			::CastSpell $npc $npc $MountArray($entry)
		}
	}

	# add include line into a file
	proc AddInclude { file include_file } {
		set include "#include $include_file"
		set content {}
		set found_include 0
		set handle [open $file]
		while { [gets $handle line] >= 0 } {
			if { [string trim $line] == $include } {
				incr found_include
				break
			}
			lappend content $line
		}
		close $handle
		if { !$found_include } {
			set count 0
			set added 0
			set handle [open $file w]
			foreach line $content {
				if { !$added && [string is ascii $line] && [string range [string trim $line] 0 1] != "//" } {
					if { !$count } { puts $handle "" }
					puts $handle $include
					if { [string trim $line] != "" } { puts $handle "" }
					set added 1
				}
				puts $handle $line
				incr count
			}
			close $handle
		}
		expr {!$found_include}
	}

	# create waypoints_mounts.scp, add include to waypoints.scp, patch world.save
	proc Install {} {
		variable POINT_START
		variable WORLD_FILE
		variable WAY_FILE
		variable MountArray
		variable hWorld

		set world_index -1
		set point $POINT_START

		set world [::Custom::ReadConf $WORLD_FILE]

		set hway [open $WAY_FILE w]
		puts $hway "// Waypoints for NPC Mounts by Spirit\n"
		foreach { section data } $world {
			incr world_index 2

			set spawn_index [lsearch $data "SPAWN"]
			set spawn [expr { $spawn_index < 0 ? 0 : [lindex [lindex $data [expr {$spawn_index+1}]] 0] }]

			if { [info exists MountArray($spawn)] } {
				set xyz_index [lsearch $data "XYZ"]
				if { $xyz_index < 0 } { continue }
				set pos [lrange [lindex $data [expr {$xyz_index+1}]] 0 2]
				lset pos 0 [expr {round([lindex $pos 0])}]
				lset pos 1 [expr {round([lindex $pos 1])}]
				lset pos 2 [expr {round([lindex $pos 2]+.5)}]

				set way_index [lsearch $data "WAYPOINT"]
				if { $way_index < 0 } {
					lappend data "WAYPOINT" $point
					lset world $world_index $data
				} else {
					lset world $world_index [expr {$way_index+1}] $point
				}

				set guid_index [lsearch $data "GUID"]
				set guid [expr { $guid_index < 0 ? 0 : [lindex $data [expr {$guid_index+1}]] }]

				set mount_waypoints($guid) $point

				puts $hway "// [::Custom::GetCreatureScp $spawn name]"
				puts $hway "\[point $point\]\npos=$pos\nscript=Mount::Waypoint"
				puts $hway ""
				incr point
			} else {
				set entry_index [lsearch $data "ENTRY"]
				set entry [expr { $entry_index < 0 ? 0 : [lindex $data [expr {$entry_index+1}]] }]

				if { [info exists MountArray($entry)] } {
					set link_index [lsearch $data "LINK"]
					set link [expr { $link_index < 0 ? 0 : [lindex $data [expr {$link_index+1}]] }]

					if { [info exists mount_waypoints($link)] } {
						set way_index [lsearch $data "WAYPOINT"]
						if { $way_index < 0 } {
							lappend data "WAYPOINT" $mount_waypoints($link)
							lset world $world_index $data
						} else {
							lset world $world_index [expr {$way_index+1}] $mount_waypoints($link)
						}
					}
				}
			}
		}
		close $hway

		AddInclude "scripts/waypoints.scp" $WAY_FILE

		file attributes $WORLD_FILE -readonly 0
		set hworld [open $WORLD_FILE w]
		puts $hworld "// Objects save file with NPC Mounts by Spirit\n"
		foreach { section data } $world {
			puts $hworld "\[$section\]"
			foreach { key value } $data {
				puts $hworld "$key=$value"
			}
			puts $hworld ""
		}
		close $hworld
		file attributes $WORLD_FILE -readonly 1
		set hWorld [open $WORLD_FILE]
		expr {$point-$POINT_START}
	}

	# initialization
	if { $USE_CONF } { ::Custom::LoadConf }
	if { [::Custom::GetScriptVersion "Custom"] < $MIN_CUSTOM } {
		::Custom::Error "Your Custom.tcl is too old. You need v$MIN_CUSTOM or higher."
		return
	}
	if { $INSTALL_ON_START && ![file exists $WAY_FILE] } {
		puts "\n[::Custom::LogPrefix]Installation of NPC Mounts, please wait...\n"
		set count [Install]
		puts "[::Custom::LogPrefix]$count NPC Mounts installed. Now you have to reboot.\n"
	}
}