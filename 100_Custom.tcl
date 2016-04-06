# start-tcl: a

# Custom Procedures
#
# This program is (c) 2006 by Spirit <thehiddenspirit@hotmail.com>
# This program is (c) 2006 by Lazarus Long <lazarus.long@bigfoot.com>
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


namespace eval ::Custom {

	variable VERSION 1.96
	variable DEBUG 0

	# registers a command to call a given procedure
	proc AddCommand { args } {
		set args [string map {\} {} \{ {}} $args]
		foreach { command proc plevel } $args {
			if { ![string is integer -strict $plevel] } { set plevel 0 }
			set ::WoWEmu::Commands($command) [list $proc $plevel]
		}
	}

	# links a procedure to a given spell effect
	proc AddSpellScript { proc args } {
		set args [string map {\} {} \{ {}} $args]
		foreach { spellid } $args {
			if { ![info exists ::SpellEffects::ScriptEffects($spellid)] || [lsearch $::SpellEffects::ScriptEffects($spellid) $proc] < 0 } {
				lappend ::SpellEffects::ScriptEffects($spellid) $proc
			}
		}
	}

	# logging of commands
	proc LogCommand { args } {
		set args [string map {\} {} \{ {}} $args]
		foreach command $args {
			if { ![info exists ::WoWEmu::Commands($command)] } { continue }
			set ::Custom::LogCommand $command
			set ::Custom::LogCommandProc [lindex $::WoWEmu::Commands($command) 0]
			namespace eval ::WoWEmu {
				eval "::Custom::HookProc $::Custom::LogCommandProc {
					::WoWEmu::Commands::Log $::Custom::LogCommand \$player \$cargs
				}"
			}
			unset ::Custom::LogCommand
			unset ::Custom::LogCommandProc
		}
	}

	# returns a string with the guild name for the given player
	proc GetGuildName { player {force_update 0} } {
		variable guild
		if { ![info exists guild] || $force_update } {
			set handle [open "saves/guilds.save"]
			while { [gets $handle line] >= 0 } {
				set line [split $line "="]
				switch [lindex $line 0] {
					"NAME" { set name [lindex $line 1] }
					"MEMBER" { set guild([lindex [lindex $line 1] 0]) $name }
				}
			}
			close $handle
		}
		set guid [::GetGuid $player]
		if { [info exists guild($guid)] } { return $guild($guid) }
	}

	# return a integer ranged from -3 to 4 depending on the player reputation regarding a NPC faction
	proc GetReputationLevel { player npc } {
		# range: -41999 42999
		set repu [::GetReputation $player $npc]
		if { $repu >= 42000 } { return 4
		} elseif { $repu >= 21000 } { return 3
		} elseif { $repu >= 9000 } { return 2
		} elseif { $repu >= 3000 } { return 1
		} elseif { $repu >= 0 } { return 0
		} elseif { $repu >= -3000 } { return -1
		} elseif { $repu >= -6000 } { return -2 }
		return -3
	}

	# returns the ID of a logged in player or 0 if not found
	proc GetPlayerID { player_name } {
		set player_name [string tolower $player_name]
		expr { [info exists ::SpellEffects::PlayerID($player_name)] ? $::SpellEffects::PlayerID($player_name) : 0 }
	}

	# returns a string with the name of the game object or target NPC
	proc GetName { obj } { if { [::GetObjectType $obj] == 4 } { ::GetName $obj } else { GetNpcName $obj } }

	# returns a dying scream as a string
	proc DyingScream { {player 0} } {
		set screams "Aaaahhh Aarrh Aaarrh Aaarrgg Aaahh Aahh Ahhh"
		return "[lindex $screams [expr {int(rand()*[llength $screams])}]]..."
	}

	# return a random integer from a given interval
	proc RandInt { a b } { expr {$a+int(rand()*($b-$a+1))} }

	# send the given player to his bind position
	proc GoHome { player } { TeleportPos $player [::GetBindpoint $player] }

	# returns a string with the rounded values of a given position
	proc RoundPos { pos } { return [list [lindex $pos 0] [expr {round([lindex $pos 1])}] [expr {round([lindex $pos 2])}] [expr {round([lindex $pos 3]+.5)}]] }

	# send the player to a given position
	proc TeleportPos { player pos } { Teleport $player [lindex $pos 0] [lindex $pos 1] [lindex $pos 2] [lindex $pos 3] }

	# returns the X and y distance between two positions
	proc DistancePos { a b } {
		if { [lindex $a 0] != [lindex $b 0] } { return -1 }
		expr {hypot([lindex $b 1]-[lindex $a 1],[lindex $b 2]-[lindex $a 2])}
	}

	# returns a string in the format "YYYY-MM-DD HH:MM:SS"
	proc DateString { } { clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S" }

	# returns a string suited to prefix entries in the server console
	proc LogPrefix {} { return "[clock format [clock seconds] -format %k:%M:%S]:M:" }

	# converts a integer to a time string in the form "HHhMMmSSs"
	proc SecondsToTime { seconds } {
		set h [expr {$seconds / 3600}]
		set m [expr {$seconds / 60 % 60}]
		set s [expr {$seconds % 60}]
		set time ""
		if { $h > 0 } {
			#if { $h < 10 } { set h "0$h" }
			append time "${h}h"
		}
		if { $m > 0 || ($h > 0 && $s > 0) } {
			if { $m < 10 && $h > 0 } { set m "0$m" }
			append time "${m}m"
		}
		if { $s > 0 } {
			if { $s < 10 && ($m > 0 || $h > 0) } { set s "0$s" }
			append time "${s}s"
		}
		return $time
	}

	# converts a integer from base 10 to base 16
	proc DecToHex { num } {
		if { ![string is integer -strict $num] || !$num } { return "00" }
		set hex ""
		while { $num } {
			set hex [string index "0123456789ABCDEF" [expr {$num % 16}]]$hex
			set num [expr {$num / 16}]
		}
		return "0$hex"
	}

	# returns the side of a given player, NPC or game object
	proc GetSide { obj } { if { [::GetObjectType $obj] == 4 } { GetPlayerSide $obj } else { GetNpcSide $obj } }

	# returns the side of a given player (0 = Alliance, 1 = Horde)
	proc GetPlayerSide { player } {
		if { ![info exists ::Custom::GetPlayerSide($player)] } {
			set ::Custom::GetPlayerSide($player) [GetPlayerSideByRace [::GetRace $player]]
		}
		return $::Custom::GetPlayerSide($player)
	}

	# returns the side of a given race (0 = Alliance, 1 = Horde)
	proc GetPlayerSideByRace { race } { expr {[string first $race {1347}] < 0} }

	# returns the faction of a given NPC
	proc GetFaction { npc } { GetCreatureScp [::GetEntry $npc] faction }

	# returns the family of a given NPC
	proc GetFamily { npc } { GetCreatureScp [::GetEntry $npc] family }

	# returns the elite status of a given NPC
	proc GetElite { npc } { GetCreatureScp [::GetEntry $npc] elite }

	# returns a boolean value regarding the civilian status of a given NPC
	proc GetCivilian { npc } { GetCreatureScp [::GetEntry $npc] civilian }

	# returns the name of the given NPC
	proc GetNpcName { npc } { GetCreatureScp [::GetEntry $npc] name }

	# returns the side of the given NPC (0 = Alliance, 1 = Horde)
	proc GetNpcSide { npc } { GetNpcSideByFaction [GetCreatureScp [::GetEntry $npc] faction] }

	# already defined by wowemu:
	# GetCreatureType (type)
	# GetNpcflags (npcflags)

	# returns a cached value from the given creature definition
	proc GetCreatureScp { entry key {type ""} } {
		variable CreatureScp
		if { ![info exists CreatureScp($entry,$key)] } {
			set value [::GetScpValue "creatures.scp" "creature $entry" $key]
			switch -- $key {
				"elite" -
				"civilian" -
				"faction" -
				"family" -
				"npcflags" -
				"flags1" -
				"maxhealth" -
				"maxmana" -
				"model" {
					set type "integer"
				}
				"speed" -
				"bounding_radius" -
				"combat_reach" {
					set type "double"
				}
				"damage" -
				"attack" {
					set type "integer integer"
				}
			}
			while { [llength $value] < [llength $type] } {
				lappend value ""
			}
			for { set i 0 } { $i < [llength $type] } { incr i } {
				if { [lindex $type $i] == "integer" && [string index [lindex $value $i] 0] == "0" } {
					lset value $i "0x[lindex $value $i]"
				}
				if { ![string is [lindex $type $i] -strict [lindex $value $i]] } {
					if { [string is [lindex $type $i] -strict 0] } { lset value $i 0 } { lset value $i "" }
				}
			}
			set CreatureScp($entry,$key) [join $value]
		}
		return $CreatureScp($entry,$key)
	}

	# returns the side of a given faction (0 = Alliance, 1 = Horde, -1 = Other)
	proc GetNpcSideByFaction { faction } {
		variable NpcSide
		if { ![info exists NpcSide($faction)] } {
			if { [lsearch {11 12 55 57 64 79 80 84 122 123 124 148 210 371 534 1076 1078 1097 1315 1514 1575 1594 1600} $faction] >= 0 } { set NpcSide($faction) 0
			} elseif { [lsearch {29 68 71 83 85 98 104 105 106 118 125 126 714 995 1034 1074 1174 1314 1515 1595} $faction] >= 0 } { set NpcSide($faction) 1
			} else { set NpcSide($faction) -1 }
		}
		return $NpcSide($faction)
	}

	# returns a boolean depending if a given player or NPC is dead or alive
	proc IsAlive { obj } { if { [::GetObjectType $obj] == 4 } { PlayerIsAlive $obj } { NpcIsAlive $obj } }

	# returns a boolean depending if a given player is alive
	proc PlayerIsAlive { player } { expr {![::GetQFlag $player IsDead]} }

	# returns a boolean depending if a given NPC is alive
	proc NpcIsAlive { npc } { expr {[::GetHealthPCT $npc] > 0} }

	# returns a boolean depending if the victim is "grey leveled" to the killer
	proc IsTrivial { victim killer } { IsGreyLevel [::GetLevel $victim] [GetLevel $killer] }

	# returns a boolean depending if the difference of levels results in the victim being "grey leveled" to the killer
	proc IsGreyLevel { victim_level killer_level } {
		if { $killer_level > 60 } { set level_limit [expr {$killer_level-12}]
		} elseif { $killer_level > 40 } { set level_limit [expr {$killer_level*4/5}]
		} else { set level_limit [expr {$killer_level-$killer_level/10-4}] }
		if { $victim_level < $level_limit } { return 1 }
		return 0
	}

	# add a log message into a given file
	proc Log { msg file {commit 1} } {
		if { ![info exists ::Custom::LogHandle($file)] } {
			set ::Custom::LogHandle($file) [open $file a]
		}
		puts $::Custom::LogHandle($file) "[DateString]: $msg"
		if { $commit } {
			LogCommit $file
		}
	}

	# commit the writing into specified log files
	proc LogCommit { {file_filter *} } {
		foreach file [array names ::Custom::LogHandle $file_filter] {
			close $::Custom::LogHandle($file)
			unset ::Custom::LogHandle($file)
		}
	}

	# outputs to the game console and the error log the given error message
	proc Error { msg } {
		set script [info script]
		if { $script == "" } {
			set script [namespace tail [uplevel namespace current]]
		}
		puts stderr "\n ERROR $script: $msg\n"
		Log "$script: $msg" "logs/errors.log"
	}

	if { ![file exists "logs"] } {
		proc Error { msg } {
			set script [info script]
			if { $script == "" } {
				set script [namespace tail [uplevel namespace current]]
			}
			puts stderr "\n ERROR $script: $msg\n"
		}
	}

	# loads the uppercase version of the variables found into the namespace section of the given configuration file
	proc LoadConf { {script ""} {conf_file "scripts/conf/scripts.conf"} {verbose 0} } {

		if { $script == "" } { set script [namespace tail [uplevel namespace current]] }
		set loaded 0
		if { [file exists $conf_file] } {

			variable ConfFileData
			variable ConfFileCheck
			if { ![info exists ConfFileCheck($conf_file)] } { set ConfFileCheck($conf_file) 0 }
			set time [clock seconds]
			if { $time-$ConfFileCheck($conf_file) > 9 } {
				set ConfFileData($conf_file) ""
				set hconfig [open $conf_file]
				while { [gets $hconfig line] >= 0 } {
					set pos [string first "#" $line]
					if { $pos >= 0 } { set line [string range $line 0 [expr {$pos-1}]] }
					set pos [string first "//" $line]
					if { $pos >= 0 } { set line [string range $line 0 [expr {$pos-1}]] }
					set line [string trim $line]
					if { $line == "" } { continue }
					lappend ConfFileData($conf_file) $line
				}
				close $hconfig
				set ConfFileCheck($conf_file) $time
			}
			set in_section 0
			foreach line $ConfFileData($conf_file) {
				if { [string index $line 0] == "\[" } {
					set section [lindex [split $line {[]}] 1]
					if { ![namespace exists ::$section] } {
						set section [string totitle $section]
					}
					if { [string match -nocase $script $section] } {
						set in_section 1
					} else { set in_section 0 }
				} elseif { $in_section } {
					set line [split $line "="]
					set name [string toupper [string trim [lindex $line 0]]]
					if { $name != "" } {
						set value [string trim [lindex $line 1]]
						if { [string index $value 0] == "\"" } {
							set value [string trim [lindex [split $value "\""] 1]]
						}
						set ::${section}::${name} $value
						incr loaded
					}
				}
			}
			if { $loaded } {
				 if { $verbose } { puts "$script: $loaded configuration variable[expr $loaded>1?{s}:{}] loaded." }
			} else {
				if { $verbose } { puts "$script: no configuration variables loaded." }
			}
		} else {
			if { $verbose } { puts "$script: Configuration file not found: $conf_file" }
		}
		return $loaded
	}

	# returns the VERSION variable from the given namespace (-1 if not found)
	proc GetScriptVersion { script } {
		if { [info exists ::${script}::VERSION] } { return [set ::${script}::VERSION] }
		if { [namespace exists ::$script] } { return 0 }
		return -1
	}

	# returns a boolean depending if the given procedure exists and if the
	# optional code is not already defined in it
	proc CheckProc { proc_name {code ""} } {
		if { [info procs "::$proc_name"] == "" } {
			uplevel ::Custom::Error \{"$proc_name is not defined or loaded too late"\}
			return 0
		} elseif { [string first $code [info body "::$proc_name"]] >= 0 } {
			uplevel ::Custom::Error \{"Redundant \"$code\" code in $proc_name"\}
			return 0
		}
		return 1
	}

	# adds the given code to the beginning of a procedure
	proc HookProc { proc_name body {code_to_check ""} args } {
		set ns [uplevel namespace current]
		if { [info commands ${ns}::${proc_name}] != "" } {
			set proc_name ${ns}::${proc_name}
		}
		if { ![uplevel ::Custom::CheckProc \{::$proc_name\} \{$code_to_check\}] } { return 0 }
		set args ""
		foreach arg [info args "::$proc_name"] {
			if { [info default "::$proc_name" $arg def] } { lappend arg $def }
			lappend args $arg
		}
		set body [string trim $body]
		set proc_body [string trim [info body ::$proc_name]]
		if { [string match -nocase "*Compiled -- no source code available*" $proc_body] } {
			# can't hook to tbc, use ChainCmd instead
			puts "Custom::HookProc:: ::$proc_name is compiled, using ChainCmd."
			uplevel ChainCmd \{::$proc_name\} \{$body\} before
			return 2
		} else {
			eval "proc ::$proc_name \{ $args \} \{\n$body\n$proc_body\n\}"
			return 1
		}
	}

	# adds the given code to the end of a procedure
	proc HookProcAfter { proc_name body args } {
		set args ""
		foreach arg [info args "::$proc_name"] {
			if { [info default "::$proc_name" $arg def] } { lappend arg $def }
			lappend args $arg
		}
		set body [string trim $body]
		set proc_body [info body ::$proc_name]
		if { [string match -nocase "*Compiled -- no source code available*" $proc_body] } {
			# can't hook to tbc, use ChainCmd instead
			puts "HookProcAfter: $proc_name is compiled, using ChainCmd."
			::Custom::ChainCmd $proc_name $body after
			return 2
		} else {
			eval "proc ::$proc_name \{ $args \} \{\n$proc_body\n$body\n\}"
			return 1
		}
	}

	# executes code before or after a command or procedure, returning the
	# command or procedure value if ran after
	proc ChainCmd { cmd_name body {position "after"} } {
		if { [lsearch $::Custom::BasicCommands $cmd_name] >= 0 } { return 0 }
		if { [info commands ::$cmd_name] == "" } { return 0 }
		set args ""
		set args_set ""
		if { [info procs "::$cmd_name"] == "" } {
			lappend args "args"
			lappend args_set "\$args"
		} else {
			foreach arg [info args "::$cmd_name"] {
				lappend args_set "\$$arg"
				if { [info default "::$cmd_name" $arg def] } { lappend arg $def }
				lappend args $arg
			}
		}
		if { [lindex $args_set end] == {$args} } {
			set args_set [concat [lrange $args_set 0 end-1] "\$args"]
		}
		set body [string trim $body]
		set i 1
		while { [info commands [set newname "::${cmd_name}_ChainCmd$i"]] != "" } { incr i }
		rename "::$cmd_name" "$newname"
		if { $position == "after" } { set exec "set return \[eval $newname $args_set\]\n$body" } else { set exec "$body\neval $newname $args_set" }
		eval "proc ::$cmd_name \{ $args \} \{\n$exec\n\}"
		return 1
	}

	# traces a command or procedure execution and arguments and returns its return value
	variable TraceCmd_indent 0
	proc TraceCmd { cmd_name {verbose 1} {out stdout} } {
		if { [lsearch $::Custom::BasicCommands $cmd_name] >= 0 } { return 0 }
		if { [info commands ::$cmd_name] == "" } { return 0 }
		if { [info commands [set newname "::${cmd_name}_TraceCmd"]] != "" } { return 0 }
		set args ""
		set args_set ""
		set args_disp ""
		if { [info procs "::$cmd_name"] == "" } {
			lappend args "args"
			lappend args_set "\$args"
			lappend args_disp "args = $$args"
		} else {
			foreach arg [info args "::$cmd_name"] {
				lappend args_set "\$$arg"
				lappend args_disp "$arg = $$arg"
				if { [info default "::$cmd_name" $arg def] } { lappend arg $def }
				lappend args $arg
			}
		}
		if { [lindex $args_set end] == {$args} } {
			set args_set [concat [lrange $args_set 0 end-1] "\$args"]
		}
		set args_disp [join $args_disp ", "]
		rename "::$cmd_name" "$newname"
		eval "proc ::$cmd_name \{ $args \} \{
			puts $out \"Trace: \[string repeat \{ \} \$::Custom::TraceCmd_indent\]$cmd_name $args_disp\"
			incr ::Custom::TraceCmd_indent 2
			set return \[eval $newname $args_set\]
			incr ::Custom::TraceCmd_indent -2
			if { \$return != \"\" } { puts $out \"Trace: \[string repeat \{ \} \$::Custom::TraceCmd_indent\]<RETURN> $cmd_name = \$return\" }
			return \$return
		\}"
		if { $verbose } { puts $out "Trace: tracing $cmd_name $args_set" }
		return 1
	}

	# benchmarks a command or procedure execution
	proc BenchCmd { args } {
		set milliseconds 0
		set verbose 1
		set out "stdout"

		if { ![string first [lindex $args 0] "-milliseconds"] } {
			set milliseconds 1
			set args [lrange $args 1 end]
		}

		set cmd_name [lindex $args 0]
		if { [string is digit -strict [lindex $args 1]] } {
			set verbose [lindex $args 1]
		}
		if { [lindex $args 2] != "" } {
			set out [lindex $args 2]
		}

		if { [lsearch $::Custom::BasicCommands $cmd_name] >= 0 } { return 0 }
		if { [info commands ::$cmd_name] == "" } { return 0 }
		if { [info commands [set newname "::${cmd_name}_BenchCmd"]] != "" } { return 0 }
		set args ""
		set args_set ""
		if { [info procs "::$cmd_name"] == "" } {
			lappend args "args"
			lappend args_set "\$args"
		} else {
			foreach arg [info args "::$cmd_name"] {
				lappend args_set "\$$arg"
				if { [info default "::$cmd_name" $arg def] } { lappend arg $def }
				lappend args $arg
			}
		}
		if { [lindex $args_set end] == {$args} } {
			set args_set [concat [lrange $args_set 0 end-1] "\$args"]
		}
		set output "puts $out \"BenchCmd $cmd_name: time=\$time\, total_time=\$total_time, total_calls=\$total_calls, average=\$average\""
		rename "::$cmd_name" "$newname"
		eval "proc ::$cmd_name \{ $args \} \{
			set start \[clock clicks [expr {$milliseconds ? "-milliseconds" : ""}]\]
			set return \[eval $newname $args_set\]
			set end \[clock clicks [expr {$milliseconds ? "-milliseconds" : ""}]\]
			set time \[expr \{\$end-\$start\}\]
			::Custom::SetBenchData $cmd_name \$time[expr {$verbose ? " stdout" : ""}]
			return \$return
		\}"
		if { $verbose } { puts $out "Bench: benching $cmd_name $args_set" }
		return 1
	}

	# returns the data gathered by ::Custom::BenchCmd
	proc GetBenchData { {sort_index 0} {out stdout} } {
		variable BenchCmd
		set bench_data {}
		foreach {proc data} [array get BenchCmd] {
			if { [lindex $data 1] } {
				set average [expr {round(double([lindex $data 0])/[lindex $data 1])}]
			} else { set average 0 }
			lappend bench_data [concat $proc $data $average]
		}
		set disp ""
		if { $sort_index } {
			set data [lsort -integer -decreasing -index $sort_index $bench_data]
		} else {
			set data [lsort -index $sort_index $bench_data]
		}
		set total 0
		foreach row $data {
			lappend disp $row
			incr total [lindex $row 1]
		}
		lappend disp "total: [expr $total/1000000.]"
		set disp [join $disp \n]
		puts $out $disp
		return $disp
	}

	# should not be used directly
	proc SetBenchData { cmd_name time {out ""} } {
		if { ![info exists ::Custom::BenchCmd($cmd_name)] } { set ::Custom::BenchCmd($cmd_name) [list 0 0] }
		set total_time [lindex $::Custom::BenchCmd($cmd_name) 0]
		set total_calls [lindex $::Custom::BenchCmd($cmd_name) 1]
		incr total_time $time
		incr total_calls
		set ::Custom::BenchCmd($cmd_name) [list $total_time $total_calls]
		if { $out != "" } {
			set average [expr {round(double($total_time)/$total_calls)}]
			puts $out "Bench $cmd_name: time=$time, total_time=$total_time, total_calls=$total_calls, average=$average"
		}
	}

	variable BasicCommands {after append array auto_execok auto_import auto_load auto_load_index auto_qualify\
		binary break case catch cd clock close concat continue encoding eof error eval\
		exec exit expr fblocked fconfigure fcopy file fileevent flush for foreach format\
		gets glob global history if incr info interp join lappend lindex linsert list\
		llength load lrange lreplace lsearch lset lsort namespace open package pid proc\
		puts pwd read regexp regsub rename return scan seek set socket source split string\
		subst switch tclLog tell time trace unknown unset update uplevel upvar variable vwait while}

	variable OnlinePlayers
	variable OnlinePlayerUpdate 9
	variable OnlinePlayersCheck 0
	variable OnlinePlayerFields "race class level map zone"

	# get online info for a single player
	proc IsOnline { player {force_update 0} } {
		variable OnlinePlayers
		variable OnlinePlayerUpdate
		set name [string tolower [::GetName $player]]
		set time [ReadOnline $force_update]
		expr {[info exists OnlinePlayers($name)] && $time-[lindex $OnlinePlayers($name) 6]<=$OnlinePlayerUpdate}
		#expr {[lsearch $OnlinePlayers [GetName $player]] >= 0}
	}

	# fills the information variable with data about online players
	# use before either a single or multiple calls to ::Custom::GetOnlineData
	proc ReadOnline { {force_update 0} } {
		variable OnlinePlayers
		variable OnlinePlayersCheck
		variable OnlinePlayerUpdate
		variable OnlinePlayerFields
		#if { ![info exists OnlinePlayersCheck] } { set OnlinePlayersCheck 0 }
		set time [clock seconds]
		if { $time-$OnlinePlayersCheck > $OnlinePlayerUpdate || $force_update } {
			#set OnlinePlayers ""
			set field_index -1
			set handle [open "www/stat.xml"]
			while { [gets $handle line] >= 0 } {
				if { [string match -nocase "*<name>*" $line] } {
					set name [lindex [split $line "<>"] 2]
					set field_index 0
					#lappend OnlinePlayers $name
				} elseif { $field_index >= 0 } {
					if { $field_index < [llength $OnlinePlayerFields] } {
						lset OnlinePlayerFields $field_index [lindex [split $line "<>"] 2]
						incr field_index
					} else {
						#if { [info exists OnlinePlayers($name)] } {
						#	set status [lindex $OnlinePlayers($name) 6]
						#} else { set status "" }
						set OnlinePlayers([string tolower $name]) [concat $name $OnlinePlayerFields $time]
						set field_index -1
					}
				}
			}
			close $handle
			set OnlinePlayersCheck $time
		}
		return $time
	}

	# gathers the information stored in stats.xml for a given player name
	# ::Custom::ReadOnline must be called before any number of calls to this one
	proc GetOnlineData { player_name } {
		variable OnlinePlayers
		variable OnlinePlayerUpdate
		set player_name [string tolower $player_name]
		#if { ![info exists OnlinePlayers($player_name)] } { ReadOnline }
		if { [info exists OnlinePlayers($player_name)] } {
			set data $OnlinePlayers($player_name)
			if { [clock seconds]-[lindex $data 6] <= $OnlinePlayerUpdate } {
				return [lrange $data 0 end-1]
			}
		}
		return 0
	}

	# allows loading TCL files encoded in UTF-8 with BOM
	proc Source { filename } {
		info script $filename
		set handle [open $filename]
		set filedata ""

		gets $handle line
		while { ![string is ascii $line] } { set line [string range $line 1 end] }
		append filedata $line "\n"

		while { [gets $handle line] >= 0 } { append filedata $line "\n" }
		uplevel eval $filedata
		close $handle
	}

	# trims comment tags and spaces from a given string
	proc DropNoise { string {comment_tags {\# //}} } {
		foreach tag $comment_tags {
			set pos [string first $tag $string]
			if { $pos >= 0 } {
				set string [string range $string 0 [expr {$pos-1}]]
			}
		}
		return [string trim $string]
	}

	# return a list of lists organized by section with key/value pairs
	proc ReadConf { file } {
		if { ![file exists $file] } { return }
		set conf {}
		set section {}
		set data {}
		set hconfig [open $file]
		while { [gets $hconfig line] >= 0 } {
			set line [DropNoise $line]
			if { [string index $line 0] == "\[" } {
				if { [llength $data] } { lappend conf $section $data }
				set data {}
				set section [lindex [split $line {[]}] 1]
			} else {
				set line [split $line "="]
				set key [string trim [lindex $line 0]]
				if { [string is false $key] } { continue }
				set value [string trim [lindex $line 1]]
				if { [string index $value 0] == "\"" } {
					set value [string trim [lindex [split $value "\""] 1]]
				}
				lappend data $key $value
			}
		}
		close $hconfig
		if { [llength $data] } { lappend conf $section $data }
		return $conf
	}

	if { [info procs ::Custom::GetID] == "" } {
		proc GetID { args } {
			return 0
		}
	}

	# duplicate loading detection
	if { [info exists Loaded] } { ::Custom::Error "Duplicated loading detected" }
	variable Loaded 1
}

namespace eval ::Custom {
	namespace eval Color {
		variable AQUA "00ffff"
		variable BLACK "000000"
		variable BLUE "0000ff"
		variable FUCHSIA "ff00ff"
		variable GRAY "808080"
		variable GREEN "008000"
		variable LIME "00ff00"
		variable MAROON "800000"
		variable NAVY "000080"
		variable OLIVE "808000"
		variable PURPLE "800080"
		variable RED "ff0000"
		variable SILVER "c0c0c0"
		variable TEAL "008080"
		variable WHITE "ffffff"
		variable YELLOW "ffff00"
	}

	# returns a colored string suitable to output to the client console
	proc Color { text {color white} } {
		set color_var ::Custom::Color::[string toupper $color]
		if { [info exists $color_var] } {
			set color [set $color_var]
		}
		return "|cff$color$text|r"
	}

	# returns a predefined sound suitable to play on the client
	proc Sound { {sound levelup} } {
		return "|s$sound|r"
	}

	# returns a color striped string
	proc UnColor { text } {
		regsub -all {\|s[^|]*\|r} $text {} text
		regsub -all {\|c\w\w\w\w\w\w\w\w} $text {} text
		regsub -all {\|r} $text {} text
		return $text
	}
}

if { [namespace exists ::WoWEmu::Commands] } {
	proc ::WoWEmu::Commands::Log { command player cargs } {
		set selection [::GetSelection $player]
		if { $selection != $player && [::GetObjectType $selection] == 4 && [::GetPlevel $selection] < 2 } {
			set gm_name [::GetName $player]
			set player_name [::GetName $selection]
			set pos [::Custom::RoundPos [::GetPos $player]]
			::Custom::Log "GM=$gm_name player=$player_name command=\"[string trim "$command $cargs"]\" pos=\[$pos\]" "logs/gmcommands.log"
		}
	}
}

# compatibility stuff
if { [::Custom::GetScriptVersion "StartTCL"] < "0.9.0" } {

	if { [namespace exists "StartTCL"] } {
		namespace eval ::Custom {
			set level "n"
			set handle [open [info script]]
			set line [gets $handle]
			close $handle
			set line [string trim [string trim [string trim [string trim $line \#]] \#]]
			if { [regexp -nocase {start-?tcl *:} $line] } {
				set level [string tolower [string trim [lindex [split $line :] 1]]]
			}
			if { $level < "c" } {
				::Custom::Error "Custom.tcl should be loaded at level \"c\" with StartTCL before v0.9.0"
			}
			unset level
			unset handle
			unset line
		}
	}


	# dummy definitions for old versions of StartTCL
	namespace eval ::StartTCL {
		if { ![info exists VERSION] } {
			variable VERSION 0
		}
		proc Provide { args } {}
		proc Require { args } {}
	}


	# this allows adding commands from scripts (Custom::AddCommand command proc plevel)
	if { [namespace exists "::WoWEmu"] } {
		namespace eval ::WoWEmu {

			variable Commands

			if { [info proc "Command"] == "" } {
				::Custom::Error "Original Commands.tcl loaded too late!"
			} elseif { [info proc "Command_Original"] == "" } {
				rename Command Command_Original
			}

			proc Command { args } {
				set sargs [string map {\} {} \{ {} \] {} \[ {} \$ {} \\ {}} $args]
				set player [lindex $sargs 0]
				set command [lindex $sargs 1]
				set cargs [lrange $sargs 2 end]
				if { [set proc [GetCommandProc [string tolower $command] [::GetPlevel $player]]] != "" } { $proc $player $cargs
				} else { Command_Original $args }
			}


			proc GetCommandProc { command plevel } {
				if { [info exists ::WoWEmu::Commands($command)] } {
					if { $plevel < [lindex $::WoWEmu::Commands($command) 1] } { return WrongPlevel }
					return [lindex $::WoWEmu::Commands($command) 0]
				}
			}

			proc WrongPlevel { {player 0} {cargs ""} } { return "You are not allowed to use this command." }
		}

		# adding scripts for spell with script effect
		set proc "::SpellEffects::SPELL_EFFECT_SCRIPT_EFFECT"
		if { [info proc $proc] != "" } {
			set hook {
				variable ScriptEffects
				if { [info exists ScriptEffects($spellid)] } {
					foreach proc $ScriptEffects($spellid) {
						$proc $to $from $spellid
					}
				}
			}
			if { [string first [string trim $hook] [info body $proc]] < 0 } {
				::Custom::HookProc $proc $hook
			}
			unset hook
		}
		unset proc

		# add setting/clear the "IsDead" qflag if it is missing. needed for Custom::PlayerIsAlive
		foreach { proc code } {::WoWEmu::OnPlayerDeath {SetQFlag $player IsDead} ::WoWEmu::OnPlayerResurrect {ClearQFlag $player IsDead}} {
			if { [info procs $proc] != "" } {
				if { [string first $code [info body $proc]] < 0 } { ::Custom::HookProc $proc $code $code }
			} else {
				::Custom::Error "$proc is not defined!"
			}
		}

	} else {
		namespace eval ::WoWEmu {
			variable NO_WOWEMU 1
		}
	}

}


# initialization stuff
namespace eval ::Custom {
	if { $DEBUG } {
		foreach proc [lsort [info procs]] {
			::Custom::TraceCmd [namespace current]::$proc 0
		}
	}

	::StartTCL::Provide
}


namespace eval ::Texts {

	variable LANGUAGE "default"
	variable TEXTS_DIR "scripts/conf/texts"

	variable USE_CONF 1
	variable VERSION 1.30

	proc GetEx { lang ns text args } {
		variable Texts
		if { [info exists Texts($lang,$ns,$text)] } {
			set text $Texts($lang,$ns,$text)
		} else {
			set lang [lindex [split $lang "_"] 0]
			if { ![info exists Texts($lang,$ns,$text)] } { set lang "en" }
			if { [info exists Texts($lang,$ns,$text)] } { set text $Texts($lang,$ns,$text) }
		}
		if { [llength $args] } { eval [list format $text] $args } else { set text }
	}

	eval "proc GetNs \{ ns text args \} \{
		set lang \$::Texts::LANGUAGE
		set ns ::\[string trim \$ns :\]
		[info body GetEx]
	\}"

	eval "proc Get \{ text args \} \{
		set lang \$::Texts::LANGUAGE
		set ns \[uplevel namespace current\]
		[info body GetEx]
	\}"

	proc GetAll {} {
		set lang $::Texts::LANGUAGE
		set ns [uplevel namespace current]
		set texts {}
		foreach { key translate } [array get ::Texts::Texts $lang,$ns,*] {
			set text [lindex [split $key ,] 2]
			lappend texts $text $translate
		}
		return $texts
	}

	proc Exists { {text "*"} } {
		set ns [uplevel namespace current]
		expr {[llength [array names ::Texts::Texts *,$ns,$text]] > 0}
	}

	proc Unset { {text "*"} } {
		set ns [uplevel namespace current]
		array unset ::Texts::Texts *,$ns,$text
	}

	proc Locale { {lang ""} } {
		if { $lang == "" } { set ::Texts::LANGUAGE } else { set ::Texts::LANGUAGE $lang }
	}

	proc Set { args } {
		if { [llength $args] < 3 } { return }
		variable Texts
		set lang [lindex $args 0]
		set text [lindex $args 1]
		set translate [join [lrange $args 2 end]]
		set ns [uplevel namespace current]
		if { [info exists Texts($lang,$ns,$text)] } {
			::Custom::Error "$lang ${ns}::${text} defined again."
		}
		set Texts($lang,$ns,$text) $translate
	}

	proc Clear {} { array unset ::Texts::Texts }

	proc Command { player cargs } { Locale $cargs }

	Clear
	if { $USE_CONF } { Custom::LoadConf }
	if { [string match -nocase "default" $LANGUAGE] } {
		if { [info exists ::LANG] } { set LANGUAGE $::LANG }
		if { [string match -nocase "default" $LANGUAGE] } { set LANGUAGE "en" }
	}

	namespace export *

	::StartTCL::Provide
}

namespace eval ::Text { namespace import ::Texts::* }

if { ![info exists ::WoWEmu::NO_WOWEMU] } {
	# load the text files
	if { $::Texts::TEXTS_DIR != "" } {
		catch {
			foreach textfile [glob "$::Texts::TEXTS_DIR/*.txt" "$::Texts::TEXTS_DIR/*.tcl"] {
				if { [catch { ::Custom::Source $textfile } err] } {
					::Custom::Error $err
				}
			}
			unset textfile
		} err
		if { $err != "" } {
			::Custom::Error "No text file could be loaded from the directory \"$::Texts::TEXTS_DIR\"."
		}
	}
	Custom::AddCommand "texts" "Texts::Command" 4
}


# do command
proc do {body while condition} {
	if {$while ne "while"} {
		error "required word missing"
	}
	set conditionCmd [list expr $condition]
	while {1} {
		uplevel 1 $body
		if {![uplevel 1 $conditionCmd]} {
			break
		}
	}
}
