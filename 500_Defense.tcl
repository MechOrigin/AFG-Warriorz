# start-tcl: n

# Defense System
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

namespace eval Defense {

	# defaults (if you have scripts.conf, use it to change values)
	variable PLAYER_DEFENSE 1
	variable PLAYER_DISTANCE 25
	variable PLAYER_REPUTATION 0
	variable NPC_DEFENSE 1
	variable NPC_DISTANCE 15 25
	variable NPC_HEALTH 40 100
	variable SWITCH_AGGRO 0
	variable USE_MASTERSCRIPT 1
	variable DEBUG 0

	variable VERSION 1.21
	variable USE_CONF_FILE 1
	variable SELF_INTEGRATION 1

	if { $USE_CONF_FILE } { ::Custom::LoadConf }

	if { [llength $NPC_DISTANCE] < 2 } {
		lappend NPC_DISTANCE [lindex $NPC_DISTANCE 0]
	}

	variable AREA_SIZE [expr {$PLAYER_DISTANCE*1.0}]
	if { $AREA_SIZE <= 0 } { set AREA_SIZE 1. }

	proc Register { npc } {
		if { [::Honor::IsGuard $npc] } {
			set ::Defense::AutoGuards[::Custom::GetNpcSide $npc][::GetLocation $npc]($npc) 0
		}
	}

	if { $PLAYER_DEFENSE } {
		proc Request { player } {
			if {[::GetObjectType [set selection [::GetSelection $player]]] != 3 || ![::Honor::IsGuard $selection] ||
				![set side [::Custom::GetPlayerSide $player]] == [::Custom::GetNpcSide $selection] ||
				[::Custom::GetReputationLevel $player $selection] < $::Defense::PLAYER_REPUTATION
			} then { return	}
			if { $::Defense::PLAYER_DEFENSE > 1 } { set ::Defense::AutoGuards$side[::GetLocation $selection]($selection) 0 }
			variable SwitchAggro
			set time [clock seconds]
			foreach { hitter hit } [array get ::Honor::Hits::$player] {
				set ot [::GetObjectType $hitter]
				if { $ot == 3 && [::Custom::NpcIsAlive $hitter] } {
					if { $time - [lindex $hit 1] < 60 && [::Distance $selection $hitter] <= $::Defense::PLAYER_DISTANCE } {
						if { [::Custom::GetNpcSide $hitter] != $side && [::CastSpell $hitter $selection 58] } {
							set SwitchAggro($player) $time
						}
						break
					}
				} elseif { $ot == 4 && [::Custom::PlayerIsAlive $hitter] } {
					if {$time - [lindex $hit 1] < 60 && [::Distance $selection $hitter] <= $::Defense::PLAYER_DISTANCE &&
						[::CastSpell $hitter $selection 58]
					} then {
						set SwitchAggro($player) $time
						break
					}
				} else { unset ::Honor::Hits::${player}($hitter) }
			}
		}

		if { $PLAYER_DEFENSE > 2 } {

			# auto mode
			proc AutoRequest { player mob } {
				set pos [::GetPos $player]
				if { ![info exists ::Defense::AutoRequestPos($player)] || $pos != $::Defense::AutoRequestPos($player) } {
					set side [::Custom::GetPlayerSide $player]
					if { [::Custom::GetSide $mob] != $side } {
						set loc [::GetLocation $mob]
						set time [clock seconds]
						foreach { npc deftime } [array get ::Defense::AutoGuards${side}${loc}] {
							if { [::GetObjectType $npc] == 3 && [::GetHealthPCT $npc] } {
								if { [set dist [::Distance $npc $mob]] <= $::Defense::PLAYER_DISTANCE && $dist > 1 && $time - $deftime > 10 } {
									if { [::Custom::GetReputationLevel $player $npc] >= $::Defense::PLAYER_REPUTATION && [::CastSpell $mob $npc 58] } {
										set ::Defense::AutoGuards${side}${loc}($npc) [set ::Defense::SwitchAggro($player) $time]
									}
									break
								}
							} else {
								unset ::Defense::AutoGuards${side}${loc}($npc)
							}
						}
						if { ![info exists ::Defense::SwitchAggro($player)] || $::Defense::SwitchAggro($player) != $time } {
							set ::Defense::AutoRequestPos($player) $pos
						}
					}
				}
			}

		} else {

			# faster auto mode
			proc AutoRequest { player mob } {
				set loc [::Defense::GetArea $player]
				if { ![info exists ::Defense::AutoRequestPos($player)] || $loc != $::Defense::AutoRequestPos($player) } {
					set time [clock seconds]
					set npc 0
					foreach { npc deftime } [array get ::Defense::AutoGuards$loc] {
						if { [::GetObjectType $npc] == 3 } {
							if { $time - $deftime > 10 && [::CastSpell $mob $npc 58] } {
								set ::Defense::AutoGuards${loc}($npc) $time
								break
							}
						} else {
							unset ::Defense::AutoGuards${loc}($npc)
						}
					}
					if { !$npc } {
						set ::Defense::AutoRequestPos($player) $loc
					}
				}
			}
		}

		proc GetArea { obj } {
			variable GetArea
			set time [clock seconds]
			if { ![info exists GetArea($obj)] || $time - [lindex $GetArea($obj) 3] > 2 } {
				set GetArea($obj) [::GetPos $obj]
				lset GetArea($obj) 1 [expr {round([lindex $GetArea($obj) 1]/$::Defense::AREA_SIZE)}]
				lset GetArea($obj) 2 [expr {round([lindex $GetArea($obj) 2]/$::Defense::AREA_SIZE)}]
				lset GetArea($obj) 3 $time
			}
			return [lrange $GetArea($obj) 0 2]
		}

		proc Register { npc } {
			if { [::Honor::IsGuard $npc] } {
				set ::Defense::AutoGuards[::Defense::GetArea $npc]($npc) 0
			}
		}

	} else {
		proc Request { player } { return "HONOR_GUARD_DEFENSE_DISABLED" }
	}

	proc RegisterNpc { npc victim } {
		set ::Defense::Mobs${victim}($npc) 0
	}

	# npc defense mode 1
	proc OnDamageNpc { player mob } {
		if {[::GetObjectType $mob] == 3 &&
			[::GetHealthPCT $mob] <= [lindex $::Defense::NPC_HEALTH [set elite [expr {![string is false [::Custom::GetElite $mob]]}]]] &&
			([set type [::GetCreatureType $mob]] == 7 || $type == 3)
		} then {
			set mobfaction [::Custom::GetFaction $mob]
			set mobside [::Custom::GetNpcSideByFaction $mobfaction]
			set time [clock seconds]
			if { $mobside < 0 } {
				foreach { npc deftime } [array get ::Defense::Mobs${player}] {
					if {[::GetObjectType $npc] == 3 && [::Distance $npc $player] <= [lindex $::Defense::NPC_DISTANCE $elite] &&
						[::Custom::GetFaction $npc] == $mobfaction && [::GetHealthPCT $npc] && $mob != $npc && $time - $deftime > 60
					} then {
						foreach victim [array names ::Honor::Attacked::$mob] {
							if { $victim != $player && [::GetHealthPCT $victim] && [::CastSpell $victim $npc 58] } {
								set ::Defense::Mobs${victim}($npc) [set ::Defense::Mobs${player}($npc) $time]
								break;
							}
						}
						if { [::CastSpell $player $npc 58] } {
							set ::Defense::Mobs${player}($npc) $time
							break;
						}
					} else { unset ::Defense::Mobs${player}($npc) }
				}
			} else {
				foreach { npc deftime } [array get ::Defense::Mobs${player}] {
					if {[::GetObjectType $npc] == 3 && [::Distance $npc $mob] <= [lindex $::Defense::NPC_DISTANCE $elite] &&
						[::Custom::GetNpcSide $npc] == $mobside && [::GetHealthPCT $npc] && $mob != $npc && $time - $deftime > 60
					} then {
						foreach victim [array names ::Honor::Attacked::$mob] {
							if { $victim != $player && [::GetHealthPCT $victim] && [::CastSpell $victim $npc 58] } {
								set ::Defense::Mobs${victim}($npc) [set ::Defense::Mobs${player}($npc) $time]
								break;
							}
						}
						if { [::CastSpell $player $npc 58] } {
							set ::Defense::Mobs${player}($npc) $time
							break;
						}
					} else { unset ::Defense::Mobs${player}($npc) }
				}
			}
		}
	}

	# npc defense mode 2
	proc OnAggroNpc { npc victim } {
		if {
			[::GetHealthPCT $npc] <= [lindex $::Defense::NPC_HEALTH [set elite [expr {![string is false [::Custom::GetElite $npc]]}]]] &&
			([set type [::GetCreatureType $npc]] == 7 || $type == 3)
		} then {
			set npcfaction [::Custom::GetFaction $npc]
			set npcside [::Custom::GetNpcSideByFaction $npcfaction]
			set time [clock seconds]
			if { $npcside < 0 } {
				foreach { dnpc deftime } [array get ::Defense::Mobs${victim}] {
					if {[::GetObjectType $dnpc] == 3 && [::Distance $dnpc $victim] <= [lindex $::Defense::NPC_DISTANCE $elite] &&
						[::Custom::GetFaction $dnpc] == $npcfaction && [::GetHealthPCT $dnpc] && $dnpc != $npc && $time - $deftime > 60
					} then {
						foreach other_victim [array names ::Honor::Attacked::$npc] {
							if { $other_victim != $victim && [::GetHealthPCT $other_victim] && [::CastSpell $other_victim $dnpc 58] } {
								set ::Defense::Mobs${other_victim}($dnpc) [set ::Defense::Mobs${victim}($dnpc) $time]
								break;
							}
						}
						if { [::CastSpell $victim $dnpc 58] } {
							set ::Defense::Mobs${victim}($dnpc) $time
							break;
						}
					} else { unset ::Defense::Mobs${victim}($dnpc) }
				}
			} else {
				foreach { dnpc deftime } [array get ::Defense::Mobs${victim}] {
					if {[::GetObjectType $dnpc] == 3 && [::Distance $dnpc $npc] <= [lindex $::Defense::NPC_DISTANCE $elite] &&
						[::Custom::GetNpcSide $dnpc] == $npcside && [::GetHealthPCT $dnpc] && $dnpc != $npc && $time - $deftime > 60
					} then {
						foreach other_victim [array names ::Honor::Attacked::$npc] {
							if { $other_victim != $victim && [::GetHealthPCT $other_victim] && [::CastSpell $other_victim $dnpc 58] } {
								set ::Defense::Mobs${other_victim}($dnpc) [set ::Defense::Mobs${victim}($dnpc) $time]
								break;
							}
						}
						if { [::CastSpell $victim $dnpc 58] } {
							set ::Defense::Mobs${victim}($dnpc) $time
							break;
						}
					} else { unset ::Defense::Mobs${victim}($dnpc) }
				}
			}
		}
	}

	proc QDBscript { entry } {
		set name [::Custom::GetCreatureScp $entry "name"]
		set ns [join $name "_"]_$entry
		set ns2 [join $name "_"]_[expr {$entry+1000000}]
		if { ![namespace exists ::$ns] && [namespace exists ::$ns2] } {	return $ns2 }
		return $ns
	}

	proc GetCorrectQuestScript { entry } {
		variable USE_MASTERSCRIPT
		if { $USE_MASTERSCRIPT } { return "MasterScript" }
		return [QDBscript $entry]
	}

	proc GetQuestSystem {} {
		variable USE_MASTERSCRIPT
		if { $USE_MASTERSCRIPT } { return "MasterScript" }
		return "QDB"
	}

	proc CheckQuestScript { entry } {
		set qs [::Custom::GetCreatureScp $entry "questscript"]
		if { $qs == [::Defense::GetCorrectQuestScript $entry] || $qs == "Defense" } { return 1 }
		return 0
	}

	proc CheckGuard { entry } {
		if { [::Honor::IsGuardByEntry $entry] } {
			set npcflags [::Custom::GetCreatureScp $entry "npcflags"]
			if { ![CheckQuestScript $entry] || !($npcflags & 2) } {	return 0 }
		}
		return 1
	}

	proc EntrySort { a b } {
		set entry1 [lindex $a 1]
		set entry2 [lindex $b 1]
		if { [string is integer -strict $entry1] && [string is integer -strict $entry2] } { return [expr {$entry1 > $entry2}] }
		return 0
	}

	proc GenerateGuards { {full 1} {include 1} {comment 1} } {
		set count 0
		Scp::Clear
		Scp::LoadAndCorrect "scripts/creatures.scp" $include $comment
		if { [llength $Scp::wrongs] } {
			set filename "scripts/creatures_corrected_guards.scp"
			set handle [open $filename w]
			puts $handle ""
			puts -nonewline $handle "// Corrected guards for auto mode ([GetQuestSystem]) by Spirit "
			if { $full } { puts $handle "(full file)" } { puts $handle "(corrected guards only)" }
			puts $handle ""
			foreach { section } [lsort -command EntrySort [array names Scp::entries]] {
				set entry [lindex $section 1]
				if { $full || [lsearch $Scp::wrongs $entry] >= 0 } {
					incr count
					set data $Scp::entries($section)
					puts $handle "\[$section\]"
					foreach { key value } $data { puts $handle "$key=[join $value]" }
					puts $handle ""
				}
			}
			close $handle
			# notice how the system message is improved with Color & Sound Technology
			return [::Texts::Get file_written $filename $count]
		} else {
			return [::Texts::Get guards_ready [Scp::GetGuardCount]]
		}
	}

	proc Commands { player cargs } {
		if { $cargs == "" } {
			return [Request $player]
		} else {
			set gm_plevel 4
			switch -- [lindex $cargs 0] {
				"info" {
					set selection [::GetSelection $player]
					if { [::GetObjectType $selection] != 3 } { return }
					if { [::Honor::IsGuard $selection] } {
						#set emotes "2 273"
						set msg [::Texts::Get target_is_guard [::Custom::GetName $selection]]
					} else {
						#set emotes "6 274"
						set msg [::Texts::Get target_is_not_guard [::Custom::GetName $selection]]
					}
					#::Emote $selection [lindex $emotes [expr {int(rand()*[llength $emotes])}]]
					return $msg
				}
				"generate" {
					if { [GetPlevel $player] < $gm_plevel } { return [::Texts::Get not_allowed_command] }
					set full 0
					set include 1
					set comment 1
					if { [lsearch [lrange $cargs 1 end] "full"] >= 0 } { set full 1 }
					if { [lsearch [lrange $cargs 1 end] "noinclude"] >= 0 } { set include 0 }
					if { [lsearch [lrange $cargs 1 end] "nocomment"] >= 0 } { set comment 0 }
					return [GenerateGuards $full $include $comment]
				}
				default {
					if { [GetPlevel $player] < $gm_plevel } { return "usage: .defense info"	}
					return "usage: .defense \[ info | generate (full | noinclude) \]"
				}
			}
		}
	}

	# for npcs that had no questscript at all
	eval "proc QuestStatus \{ npc player \} \{\n[info body Register]\n\}"

}

namespace eval Defense {
	namespace eval Scp {

		variable basedir "."
		variable entries
		variable wrongs

		proc DropNoise { string } {
			set string [string trim $string]
# 			set comment [string first "#" $string]
# 			if { $comment != -1 } {
# 				set string [string trim [string range $string 0 [expr {$comment - 1}]]]
# 			}
			set comment [string first "//" $string]
			if { $comment != -1 } { set string [string trim [string range $string 0 [expr {$comment - 1}]]] }
			return $string
		}

		proc LoadAndCorrect { scpfilename {include 1} {comment 1} } {
			variable entries
			variable wrongs
			variable guard_count
			set wrong 0
			set questscript 1
			set npcflags 1
			if { ![file exists $scpfilename] } { ::Custom::Error "$scpfilename not found."; return }
			#puts $scpfilename
			set handle [open $scpfilename]
			set foundentry 0
			while { [gets $handle line] >= 0 } {
				if { $include && [string range $line 0 [expr [string first " " $line]-1]] == "#include" } {
					variable basedir
					LoadAndCorrect "$basedir/[lindex $line 1]" $include $comment
				} else {
					if { [string index $line 0] == "\[" } {
						if { $wrong } {
							if { !$questscript } {
								#set correct [::Defense::GetCorrectQuestScript $entry]
								set correct "Defense"
								if { $comment } { append correct " // was missing" }
								lappend entries($section) "questscript" $correct
							}
							if { !$npcflags } {
								set correct "02"
								if { $comment } { append correct " // was missing" }
								lappend entries($section) "npcflags" $correct
							}
						}
						set wrong 0
						set questscript 1
						set npcflags 1
						set foundentry 1
						set type [lindex [split [lindex $line 0] "\["] 1]
						set entry [lindex [split [lindex $line 1] "\]"] 0]
						set section "$type $entry"
						if { [::Honor::IsGuardByEntry $entry] } {
							incr guard_count
							if { ![::Defense::CheckGuard $entry] } {
								set wrong 1
								set questscript 0
								set npcflags 0
								lappend wrongs $entry
							}
						}
						if { [info exists entries($section)] } {
							unset entries($section)
						}
					} elseif { $foundentry && $line != "" } {
						if { $wrong } {
							set line [DropNoise $line]
							set key [string trim [lindex [split $line "="] 0]]
							set val [string trim [lindex [split $line "="] 1]]
							switch -- $key {
								"questscript" {
									set correct [::Defense::GetCorrectQuestScript $entry]
									set org [::Custom::GetCreatureScp $entry "questscript"]
									if { $org != $correct } {
										if { $comment } { append correct " // was $val" }
										set val $correct
									}
									set questscript 1
								}
								"npcflags" {
									set org [::Custom::GetCreatureScp $entry "npcflags"]
									if { !($org & 2) } {
										set correct [::Custom::DecToHex [expr {$org+2}]]
										if { $comment } { append correct " // was $val" }
										set val "$correct"
									}
									set npcflags 1
								}
							}
						} else {
							set key [string trim [lindex [split $line "="] 0]]
							set val [string trim [lindex [split $line "="] 1]]
						}
						lappend entries($section) $key $val
					}
				}
			}
			close $handle
		}

		proc Clear {} {
			variable entries
			array unset entries
			variable wrongs ""
			variable guard_count 0
		}

		proc GetGuardCount {} {
			variable guard_count
			return $guard_count
		}
	}
}


# start-up
namespace eval Defense {

	if { $SELF_INTEGRATION } {

		if { $PLAYER_DEFENSE } {
			if { [string first "Guard::is " [info body "::AI::CanAgro"]] >= 0 } {
				::Custom::Error "You have to remove \"Guard\" code from DamageReduction/OnPlayerDeath/CalcXP/CanAgro. That code is redundant with the Defense System."
			}
			if { $PLAYER_DEFENSE > 1 } {

				::Custom::HookProc "WoWEmu::OnPlayerResurrect" {
					array unset ::Defense::AutoRequestPos($player)
				}

				if { $PLAYER_DEFENSE == 2 } {
					foreach proc {Request Register} {
						eval "proc $proc \{ [info args $proc] \} \{
							[string map {{$side[::GetLocation [::Defense::GetArea} {GetLocation Defense::GetArea}} [info body $proc]]
						\}"
					}
				}

				::Custom::HookProc "::WoWEmu::DamageReduction" [info body ::Defense::AutoRequest] "::AutoGuards"

				if { $USE_MASTERSCRIPT } {
					if { [info procs "::MasterScript::QuestStatus"] != "" } {
						::Custom::HookProc "::MasterScript::QuestStatus" [info body ::Defense::Register] "::AutoGuards"
						#::Custom::HookProc "::MasterScript::GossipHello" [info body ::Defense::Register] "::AutoGuards"
					} else {
						::Custom::Error "auto mode requires MasterScript to be loaded first."
					}
				}
			}
		}

		if { $SWITCH_AGGRO } {
			::Custom::HookProc "::AI::CanUnAgro" {
				if { [info exists ::Defense::SwitchAggro($victim)] && [clock seconds] - $::Defense::SwitchAggro($victim) < 60 } {
					return 1
				}
			} "Defense::SwitchAggro"
		}

		if { $NPC_DEFENSE } {
			if { [string first {GetQFlag $victim mobneedshelp} [info body "::AI::CanAgro"]] >= 0 } {
				::Custom::Error "You have to remove \"Mob Help\" code from CalcXP/OnPlayerDeath/CanAgro/CanUnAgro. That code is redundant with the Defense System."
			}
			::Custom::HookProc "::AI::CanAgro" [info body ::Defense::RegisterNpc]
			if { $NPC_DEFENSE == 1 } {
				::Custom::HookProc "::WoWEmu::DamageReduction" [info body ::Defense::OnDamageNpc]
			} else {
				::Custom::HookProc "::AI::CanUnAgro" [info body ::Defense::OnAggroNpc]
			}
		}
	}

	::Custom::AddCommand "defense" "::Defense::Commands"
	::StartTCL::Provide
}

# testing suff
namespace eval Defense {
	if { $DEBUG } {
		puts "\n[namespace tail [namespace current]]: *** DEBUG MODE ENABLED ***\n"
		# .eval Custom::GetBenchData 1
		foreach proc [lsort [info procs]] {
			#Custom::BenchCmd [namespace current]::$proc 1
			Custom::TraceCmd [namespace current]::$proc 0
		}
	}

}


