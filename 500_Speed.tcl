# start-tcl: n

# Player Speed Checker
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

namespace eval Speed {

	# defaults (if you have scripts.conf, use it to change values)
	variable GLOBAL_CHECK 0
	variable CHECK_GM 0
	variable RETURN_POS 1
	variable ENABLE_DISMOUNT 1
	variable ENABLE_KICK 0
	variable SPEED_LIMITS {14 16 18}

	variable USE_CONF_FILE 1

	variable VERSION 1.31

	if { $USE_CONF_FILE } { Custom::LoadConf }

	proc Check { player } {
		global SPEEDLOG
		if { [info exists SPEEDLOG($player)] } {
			set newtime [clock clicks -milliseconds]
			set timediff [expr {$newtime-[lindex $SPEEDLOG($player) 4]}]
			if { $timediff > 2000 } {
				set newpos [::GetPos $player]
				set oldpos [lrange $SPEEDLOG($player) 0 3]
				set newspeed [expr {[::Custom::DistancePos $newpos $oldpos]/($timediff/1000.)}]
				set oldspeed [lindex $SPEEDLOG($player) 5]
				set averagespeed [expr {($oldspeed+$newspeed)/2.}]
				set level [::GetLevel $player]
				set limit [SpeedLimit $level]
				if { $newspeed > $limit } {
					if { $oldspeed > $limit || $averagespeed > 63 && ![IsTaxiNode $oldpos] && ![IsTaxiNode $newpos] } {
						if { [::GetHealthPCT $player] && [TestGM $player] } {
							set speedpercent [expr {$averagespeed/.07-100.}]
							set line "[::Custom::DateString]: name=[::GetName $player] level=$level oldpos=\[[::Custom::RoundPos $oldpos]\] newpos=\[[::Custom::RoundPos $newpos]\] speed=+[expr {round($speedpercent)}]%"
							if { $averagespeed > 49 } { append line " (TP)" }
							set hspeed [open "logs/speed.log" a]
							puts $hspeed $line
							close $hspeed
 							if { $averagespeed <= 42 } {
	 							if { $::Speed::RETURN_POS } {
 									::Custom::TeleportPos $player $oldpos
								}
 								if { $::Speed::ENABLE_DISMOUNT && [::Honor::GetAddonVersion $player] >= 1.26 } {
	 								::Say $player "|c00f10000I am too fast, I need to dismount!|r"
 								}
 								if { $::Speed::ENABLE_KICK } { KickPlayer $player }
 								return $averagespeed
 							}
						}
					}
				}
				set SPEEDLOG($player) "$newpos $newtime $newspeed $averagespeed"
			}
		} else {
			set newpos [::GetPos $player]
			set newtime [clock clicks -milliseconds]
			set SPEEDLOG($player) "$newpos $newtime 0 0"
		}
		lindex $SPEEDLOG($player) 6
	}

	if { $CHECK_GM } {
		proc TestGM { player } { return 1 }
	} else {
		proc TestGM { player } { expr {[::GetPlevel $player]<2} }
	}

	proc SpeedLimit { level } {
		if { $level < 40 } { return [lindex $::Speed::SPEED_LIMITS 0] }
		if { $level < 60 } { return [lindex $::Speed::SPEED_LIMITS 1] }
		return [lindex $::Speed::SPEED_LIMITS 2]
	}

	proc IsTaxiNode { pos } {
		info exists ::Speed::TaxiAreas([GetAreaPos $pos])
	}

	proc Commands { player cargs } {
		set p [GetSelection $player]
		if { [GetObjectType $p] != 4 } { set p $player }
		switch [lindex $cargs 0] {
			"silent" { Check $p; return }
			default { return "[GetName $p]: [Check $p]" }
		}
	}

	variable TaxiNodes {
		{0 -986.43 -547.86 -3.86}
		{1 1320.07 -4649.2 21.57}
		{1 5068.4 -337.22 367.41}
		{1 7455.76 -2485.72 466.46}
		{1 -3147.39 -2842.18 34.61}
		{1 2711.44 -3889.01 103.7}
		{1 6207.12 -1949.89 571.07}
		{0 931.32 -1430.11 64.67}
		{0 2271.09 -5340.8 87.11}
		{1 139.24 1325.82 193.5}
		{0 -12418.77 235.43 1.12}
		{1 2302.39 -2524.55 104.4}
		{1 7793.61 -2403.47 489.32}
		{1 7787.72 -2404.1 489.56}
		{0 -8888.98 -0.54 94.39}
		{0 -8840.56 489.7 109.61}
		{0 16391.811 16341.21 69.44}
		{0 -10628.89 1036.68 34.06}
		{0 -9429.1 -2231.4 68.65}
		{0 -4821.78 -1155.44 502.21}
		{0 -3792.26 -783.29 9.06}
		{0 -5421.91 -2930.01 347.25}
		{0 -14271.77 299.87 31.09}
		{0 478.86 1536.59 131.32}
		{0 1568.62 267.97 -43.1}
		{0 -10515.46 -1261.65 41.34}
		{0 -0.06 -859.91 58.83}
		{0 2253.4 -5344.9 83.38}
		{0 -1240.53 -2515.11 22.16}
		{0 -916.29 -3496.89 70.45}
		{0 -14444.29 509.62 26.2}
		{0 -14473.05 464.15 36.43}
		{0 -6633.99 -2180.05 244.14}
		{1 -1197.21 29.71 176.95}
		{1 1677.59 -4315.71 61.17}
		{1 -441.8 -2596.08 96.06}
		{1 8643.59 841.05 23.3}
		{1 2827.34 -289.24 107.16}
		{1 966.57 1040.32 104.27}
		{1 -4491.88 -775.89 -39.52}
		{1 -3825.37 -4516.58 10.44}
		{1 2681.13 1461.68 232.88}
		{0 -10456.97 -3279.25 21.35}
		{1 -7048.89 -3780.36 10.19}
		{0 -11112.25 -3435.74 79.09}
		{1 -1767.64 3263.89 4.94}
		{1 -4373.8 3338.65 12.27}
		{1 -4419.86 199.31 25.06}
		{0 283.74 -2002.76 194.74}
		{0 -12414.18 146.29 3.28}
		{1 -5407.71 -2414.3 90.32}
		{1 6799.24 -4742.44 701.5}
		{1 6813.06 -4611.12 710.67}
		{1 3374.71 996.97 5.19}
		{0 2327.41 -5286.89 81.78}
		{1 -7223.97 -3734.59 8.39}
		{1 3661.52 -4390.38 113.05}
		{0 -6666 -2222.3 278.6}
		{1 -1965.17 -5824.29 -1.06}
		{1 -4203.87 3284 -12.86}
		{30 574.21 -46.65 37.61}
		{30 -1335.44 -319.69 90.66}
		{1 7470.39 -2123.38 492.34}
		{0 -7504.03 -2187.54 165.53}
		{0 -8364.61 -2738.35 185.46}
		{1 -6353.88 -251.83 -2.14}
		{1 -6422.15 -320.75 -1.05}
		{0 -6552.59 -1168.27 309.31}
		{0 -6554.93 -1100.05 309.57}
		{0 -635.26 -4720.5 5.38}
		{1 -2380.67 -1882.67 95.85}
		{0 -711.48 -515.48 26.11}
		{1 6341.38 557.68 16.29}
		{1 8701.51 991.37 14.21}
	}

	proc GetAreaPos { pos {area_size 50} } {
		return "[expr {round([lindex $pos 1]/$area_size)}] [expr {round([lindex $pos 2]/$area_size)}]"
	}

	variable TaxiAreas
	foreach pos $TaxiNodes {
		set TaxiAreas([GetAreaPos $pos]) 1
	}

	::StartTCL::Provide
}

if { $::Speed::GLOBAL_CHECK } {

	if { [info commands "::Wad::Teleport"] == "" } { rename ::Teleport ::Wad::Teleport }

	proc ::Teleport { player map x y z args } {
	    array unset ::SPEEDLOG $player
		::Wad::Teleport $player $map $x $y $z
	}

	::Custom::HookProc "AI::CanAgro" {::Speed::Check $victim} "Speed::"
	if { [info procs "::MasterScript::QuestStatus"] != "" } {
		::Custom::HookProc "::MasterScript::QuestStatus" {::Speed::Check $player} "Speed::"
	}
}

::Custom::AddCommand "speed" "::Speed::Commands"


