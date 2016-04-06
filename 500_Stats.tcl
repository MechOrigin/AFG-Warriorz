# Start-TCL: n

namespace eval Balance {

	variable addons 1.03
	variable version 1.10
	variable NAME "StatSystem"

	# 1-Enable or 2-Disable

	variable security 1
	variable enable_enrage 1
	variable enable_dodge 1
	variable enable_miss 1
	variable enable_power 1
	variable enable_attack 1
	variable crushing_blow 1
	variable resistance 1
	variable bonus_armor 1
	variable mob_critical 1
	variable boss_balance 1
	variable factor 15
	variable DEBUG 0

	proc Elite { mob } {
		set entry [::GetEntry $mob]
		set elite [::GetScpValue "creatures.scp" "creature $entry" "elite"]
		if {([string is digit -strict $elite] != 1)} {set elite 0}
		return $elite
	}
	proc Resistance { player mob dr } {
		variable DEBUG
		if {[::Distance $mob $player] < 5} { return $dr }
		set dif [expr {[::GetLevel $player]-[::GetLevel $mob]}]
		if { $dif == 0 } { set tar 0.04
		} elseif { $dif < 0 } { return $dr }
		if {[::GetObjectType $mob] == 4} {
			set fac 0.8
			set base 0.07
		} else {
			set fac 0.16
			set base 0.11
		}
		switch $dif {
			1 { set tar 0.05 }
			2 { set tar 0.06 }
			default { set tar [expr {($dif*$base)-$fac}] }
		}
		set dr [expr {$dr+$tar}]
		if { $DEBUG } { puts "Bonus Resistence: [expr {int($tar*100)}]%" }
		if { $dr > 0.75 } { set dr 0.75 }
		return $dr
	}
	proc Hit { player mob }	{
		variable DEBUG
		set name [::GetName $player]
		if { $::Balance::enable_dodge == 1 } { if {[Dodge $player $mob] == 1} {
			if { $DEBUG } { puts "$name Dodge" }
			return 1} }
		if { $::Balance::enable_miss == 1 } { if {[Miss $player $mob] == 1} {
			if { $DEBUG } { puts "$name Miss" }
			return 1} }
		return 0
	}
	proc Miss { player mob } {
		variable DEBUG
		if {[Distance $mob $player] < 5} {return 0}
		set mlvl [::GetLevel $mob]
		set plvl [::GetLevel $player]
		set dif [expr {$plvl-$mlvl}]
		set rnd [expr {rand()}]
		set chance 0.96
		if {$dif > 0} {
			if {[::GetObjectType $player] == 4} {
				switch $dif {
					1 {set chance 0.95}
					2 {set chance 0.94}
					default {set chance [expr {0.94-((($dif-2)*7.0)/100.0)}]}
				}
			} else {
				switch $dif {
					1 {set chance 0.95}
					2 {set chance 0.83}
					default {set chance [expr {0.94-((($dif-2)*9.0)/100.0)}]}
				}
			}
		}
		if {$chance <= 0.15} {set chance 0.15}
		if { $DEBUG } { puts "[::GetName $player] Spell Miss Chance: [expr {int($chance*100)}]%" }
		if {$rnd <= $chance} {return 0}
		return 1
	}
	proc Dodge { player mob } {
		variable DEBUG
		set name [::GetName $player]
		set dodge 2.5
		set rnd [expr {rand()}]
		set mlvl [::GetLevel $mob]
		set exist [ stats eval { SELECT `name` FROM `stats` WHERE (`name` = $name) } ]
		if {$exist != ""} {
			set Agility [ stats eval { SELECT `agility` FROM `stats` WHERE (`name` = $name) } ]
			set Defense [ stats eval { SELECT `defense` FROM `stats` WHERE (`name` = $name) } ]
		} else {
			set Agility 1
			set Defense 1
		}
		switch [GetClass $player] {
			3 {set mod 26.5}
			4 {set mod 14.5}
			default {set mod 20.0}
		}
		set agibonus [expr {($Agility*1.0)/$mod}]
		set dodge [expr {(($dodge+(($Defense-$mlvl*5)*0.04)+$agibonus)/100.0)*1.5}]
		if { $DEBUG } { puts "[::GetName $player] Dodge Chance: [expr {int($dodge*100)}]%" }
		if {$rnd <= $dodge} {return 1}
		return 0
	}
	proc Dr { player mob dr } {
		variable DEBUG
		if { $dr > 0.75 } { set dr 0.75 }
		if { $DEBUG } { puts "Normal Reduction: [expr {int($dr*100)}]%" }
		if { [::GetQFlag $player IsDead] } { return 1 }
		if { [::GetObjectType $mob] == 4 && [::GetQFlag $player resting]} { return 1 }
		if { $::Balance::boss_balance == 1 } { if { [Elite $mob] == 3 && $dr <= 0 } {set dr 0} }
		if { $::Balance::resistance == 1 } { set dr [Resistance $player $mob $dr] }
		if { $::Balance::crushing_blow == 1 } { set dr [Crushing $player $mob $dr] }
		if { $::Balance::enable_enrage == 1 } { set dr [Enrage::Rage $player $mob $dr] }
		if { $::Balance::enable_power == 1 } { set dr [Power $player $mob $dr] }
		if { $::Balance::enable_attack == 1 } { set dr [Attack $player $mob $dr] }
		if { $DEBUG } { puts "Total Reduction: [expr {int($dr*100)}]%" }
		return $dr
	}
	proc Crushing { player mob dr } {
		set plrlvl [::GetLevel $player]
		set moblvl [::GetLevel $mob]
		if {[expr {$moblvl-$plrlvl}] > 2} {
			if {[expr {rand()*100}] <= 15} { set dr [expr {1-(1-$dr)*1.5}] }
		}
		return $dr
	}
	proc Power { player mob dr } {
		set val 1
		if {[::GetObjectType $mob] == 4} {
			set name [::GetName $mob]
			if {[Distance $mob $player] < 5} { set attack 1 } else { set attack 0 }
			set exist [ stats eval { SELECT `name` FROM `stats` WHERE (`name` = $name) } ]
			if {$exist != ""} {
				set Agility [ stats eval { SELECT `agility` FROM `stats` WHERE (`name` = $name) } ]
				set Strength [ stats eval { SELECT `strength` FROM `stats` WHERE (`name` = $name) } ]
			} else {
				set Agility 1
				set Strength 1
			}
			set lvl [::GetLevel $player]
			set bonus [expr {$lvl*10.0+1450.0}]
			switch [GetClass $mob] {
				3 {
					if {$attack == 1} {
						set val [expr {1+(($Strength+$Agility*1.0)/$bonus)}]
					} else {
						set val [expr {1+(($Strength+$Agility*2.0)/$bonus)}]
					}
				}
				4 {
					if {$attack == 1} {
						set val [expr {1+(($Strength+$Agility*1.0)/$bonus)}]
					}
				}
				default {
					if {$attack == 1} {
						set val [expr {1+($Strength*2.0/$bonus)}]
					}
				}
			}
			set dr [expr {1-(1-$dr)*$val}]
		}
		return $dr
	}
	proc Attack { player mob dr } {
		set rnd [expr {rand()}]
		if {[::GetObjectType $mob] == 4} {
			set name [::GetName $mob]
			if {[Distance $mob $player] > 5} { set attack 1 } else { set attack 0 }
			switch $attack {
				1 {
					set chance [expr {[Spell $mob $name]*1.25}]
					if { $chance == 0 } { return $dr }
					if { $rnd <= $chance } {
						set dr [expr {1-(1-$dr)*1.5}]
					}
				}
				0 {
					set chance [expr {[Melee $mob $name]*1.25}]
					if { $rnd <= $chance } {
						set dr [expr {1-(1-$dr)*2.0}]
					}
				}
			}
		} else {
			if { $::Balance::mob_critical == 1 } {
				set chance [Mob $mob]
				if { $rnd <= $chance } {
					set dr [expr {1-(1-$dr)*1.75}]
				}
			}	
		}
		return $dr
	}
	proc Spell { player name } {
		set exist [ stats eval { SELECT `name` FROM `stats` WHERE (`name` = $name) } ]
		if {$exist != ""} {
			set Intellect [ stats eval { SELECT `intellect` FROM `stats` WHERE (`name` = $name) } ]
		} else {
			set Intellect 1
		}
		switch [::GetClass $player] {
			1 { return 0 }
			2 { 	set chance [expr {($Intellect*1.0)/30.0}]
				return [expr {$chance/100.0}]
			}
			3 { return 0 }
			4 { return 0 }
			11 {
				set chance [expr {($Intellect*1.0)/30.0}]
				return [expr {$chance/100.0}]
			}
			default {
				set chance [expr {($Intellect*1.0)/59.5}]
				return [expr {$chance/100.0}]
			}
		}
	}
	proc Melee { player name } {
		set exist [ stats eval { SELECT `name` FROM `stats` WHERE (`name` = $name) } ]
		if {$exist != ""} {
			set Agility [ stats eval { SELECT `agility` FROM `stats` WHERE (`name` = $name) } ]
		} else {
			set Agility 1
		}
		switch [::GetClass $player] {
			1 {
				set chance [expr {5.0+($Agility*1.0)/20.0}]
				return [expr {$chance/100.0}]
			}
			3 {
				set chance [expr {5.0+($Agility*1.0)/53.0}]
				return [expr {$chance/100.0}]
			}
			4 {
				set chance [expr {5.0+($Agility*1.0)/29.0}]
				return [expr {$chance/100.0}]
			}
			7 {
				set chance [expr {5.0+($Agility*1.0)/20.0}]
				return [expr {$chance/100.0}]
			}
			default {
				set chance [expr {5.0+($Agility*1.0)/20.0}]
				return [expr {$chance/100.0}]
			}
		}
	}
	proc Mob { mob } {
		set elite [Elite $mob]
		switch $elite {
			0 {set bonus 0.03}
			1 {set bonus 0.09}
			2 {set bonus 0.12}
			3 {set bonus 0.21}
			4 {set bonus 0.15}
		}
		set lvl [::GetLevel $mob]
		if {$lvl > 70 } { set lvl 70 }
		set calc [expr {($lvl*8.0)/1000.0}]
		if {$calc > 0.25} {set calc 0.25}
		set calc [expr {$calc+$bonus}]
		return $calc
	}
	proc Armor { player armor } {
		variable DEBUG
		set name [::GetName $player]
		if { $::Balance::security == 1 } { Security $player $armor $name }
		if { $DEBUG } {	puts "Default Armor ($name): $armor" }
		set exist [ stats eval { SELECT `name` FROM `stats` WHERE (`name` = $name) } ]
		if {$exist != ""} {
			set Arm [ stats eval { SELECT `armor` FROM `stats` WHERE (`name` = $name) } ]
			set Agility [ stats eval { SELECT `agility` FROM `stats` WHERE (`name` = $name) } ]
		} else {
			set Arm $armor
			set Agility 1
		}
		if { $::Balance::bonus_armor == 1 } {
			set plvl [::GetLevel $player]
			set Arm [expr {$Arm+($plvl*$::Balance::factor)}]
			if { $DEBUG } {
				set bonus [expr {$plvl*$::Balance::factor}]	
				puts "Bonus Armor ($name): $bonus" }
		}
		set Arm [expr {$Arm+2.0*$Agility}]
		if { $DEBUG } { puts "Total Armor w/Agi ($name): $Arm" }
		return $Arm
	}		
	proc Call { player cargs } {
		set name [::GetName $player]
		if {[llength $cargs] < 5} {
			Stat $player 0
		} else {
			set Armor [lindex $cargs 0]
			set Agility [lindex $cargs 1]
			set Intellect [lindex $cargs 2]
			set Defense [lindex $cargs 3]
			set Strength [lindex $cargs 4]
			set Buff [lindex $cargs 5]
			set plvl [::GetPlevel $player]
			set lvl [::GetLevel $player]
			set skill [expr {$lvl*5}]
			if { $Defense > $skill } { set Defense 0 }
			if { [GetLevel $player] > 60 } {
				if { $Armor > 18000 && $plvl < 1} { set Armor 0 }
				if { $Agility > 900 && $plvl < 1} { set Agility 0 }
				if { $Intellect > 900 && $plvl < 1} { set Intellect 0 }
				if { $Strength > 900 && $plvl < 1} { set Strength 0 }
			} else {
				if { $Armor > 12000 && $plvl < 1} { set Armor 0 }
				if { $Agility > 600 && $plvl < 1} { set Agility 0 }
				if { $Intellect > 600 && $plvl < 1} { set Intellect 0 }
				if { $Strength > 600 && $plvl < 1} { set Strength 0 }
			}
			set exist [ stats eval { SELECT `name` FROM `stats` WHERE (`name` = $name) } ]
			if {$exist != ""} {
				stats eval {UPDATE `stats` set `armor`=$Armor, `agility`=$Agility, `intellect`=$Intellect, `defense`=$Defense, `strength`=$Strength, `buff`=$Buff WHERE (`name` = $name) }
			} else {
				stats eval {INSERT INTO `stats` (`name`, `armor`, `agility`, `intellect`, `defense`, `strength`, `buff`) VALUES ($name, $Armor, $Agility, $Intellect, $Defense, $Strength, $Buff)}
			}
		}
	}
	proc Security { player armor name } {		
		set exist [ stats eval { SELECT `name` FROM `stats` WHERE (`name` = $name) } ]
		if {$exist == ""} { return
		} elseif { $armor == 0 } { return
		} else {
			set A [ stats eval { SELECT `armor` FROM `stats` WHERE (`name` = $name) } ]
			set B [ stats eval { SELECT `buff` FROM `stats` WHERE (`name` = $name) } ]
			if {$armor == $A} { return }
			if {[expr {$armor+$B}] < $A} {
				set Arm 0
				set Agility 0
				set Intellect 0
				set Defense 0
				set Strength 0
				set Buff 0
				stats eval {UPDATE `stats` set `armor`=$Arm, `agility`=$Agility, `intellect`=$Intellect, `defense`=$Defense, `strength`=$Strength, `buff`=$Buff WHERE (`name` = $name) }
				set time [::Custom::DateString]
				set text "$time $name send have a error: Stat armor:$A Correct armor: $armor"
				set file "logs/stats.log"
				set id [open $file a+]
				puts $id $text
				close $id				
				if { [file size "logs/stats.log"] >= 512000 } {
					file rename -force "logs/stats.log" "logs/stats.old"
				}
				return "You have cheat!"
			}
		}
	}
	proc Ver { player cargs } {
		variable addons
		if {$cargs < $addons} {
			Stat $player 0
			set name [::GetName $player]
			set version $cargs
			set time [::Custom::DateString]
			set text "$time $name have a Old StatsAddons v$version"
			set file "logs/stats.log"
			set id [open $file a+]
			puts $id $text
			close $id
			return "Please update StatsAddons"		
		}
	}
	proc Stat { player cargs } {
		set name [::GetName $player]
		if {$cargs == "redo" && [::GetPlevel $player] > 4} {
			stats eval {DROP TABLE `stats`}
			stats eval {CREATE TABLE `stats` (`name` TEXT PRIMARY KEY, `armor` TEXT, `agility` TEXT, `intellect` TEXT, `defense` TEXT, `strength` TEXT, `buff` TEXT)}
			return "Done..."
		} elseif {$cargs == "info"} {
			set fac [Check $player]
			set selection [::GetSelection $player]
			if { !$selection } { set selection $player }
			if { [::GetObjectType $selection] != 4 } { return "Please select a player." }
			set side [ Check $selection ]
			if { $fac != $side && [::GetPlevel $player] == 0 } { return "Select a player of your faction." }
			set player_name [::GetName $selection]
			set exist [ stats eval { SELECT `name` FROM `stats` WHERE (`name` = $player_name) } ]
			if {$exist != ""} {
				set Armor [ stats eval { SELECT `armor` FROM `stats` WHERE (`name` = $player_name) } ]
				set Agility [ stats eval { SELECT `agility` FROM `stats` WHERE (`name` = $player_name) } ]
				set Intellect [ stats eval { SELECT `intellect` FROM `stats` WHERE (`name` = $player_name) } ]
				set Defense [ stats eval { SELECT `defense` FROM `stats` WHERE (`name` = $player_name) } ]
				set Strength [ stats eval { SELECT `strength` FROM `stats` WHERE (`name` = $player_name) } ]
				set Bonus [expr {$Agility*2}]
				return "$player_name:\n Str: $Strength Agi: $Agility Int: $Intellect Armor: $Armor Bonus: $Bonus Def: $Defense"
			} else {
				return "$player_name don't have StatAddons"
			}
			return
		} elseif {$cargs == "del" && [::GetPlevel $player] > 4} {
			set selection [::GetSelection $player]
			if { !$selection } { return "Please select a player." }
			if { [::GetObjectType $selection] != 4 } { return "Please select a player."}
			set player_name [::GetName $selection]
			set exist [ stats eval { SELECT `name` FROM `stats` WHERE (`name` = $player_name) } ]
			if {$exist != ""} {
				stats eval { DELETE FROM `stats` WHERE (`name` = $player_name) }
				return "Delete...Done."
			} else { return "Player don't have Stats." }
		} elseif {$cargs == "help" || $cargs == ""} { return "Stats System v$::Balance::version by Raverouk\n .stat redo (to reset the database)\n .stat info (give player stats info)\n .stat del (erase a player stats)\n .stat help (give this help)"
		} elseif {[llength $cargs] > 0} { return "Command error in StatAddons" }
		set Armor 0
		set Agility 0
		set Intellect 0
		set Defense 0
		set Strength 0
		set Buff 0
		set exist [ stats eval { SELECT `name` FROM `stats` WHERE (`name` = $name) } ]
		if {$exist != ""} {
			stats eval {UPDATE `stats` set `armor`=$Armor, `agility`=$Agility, `intellect`=$Intellect, `defense`=$Defense, `strength`=$Strength, `buff`=$Buff WHERE (`name` = $name) }
		} else {
			stats eval {INSERT INTO `stats` (`name`, `armor`, `agility`, `intellect`, `defense`, `strength`, `buff`) VALUES ($name, $Armor, $Agility, $Intellect, $Defense, $Strength, $Buff)}
		}
		return "Error! in your StatsAddons"
	}
	proc Check { player } {
			set race [ ::GetRace $player ]
			if { $race == 1 } { set side a
			} elseif {$race == 2} { set side h
			} elseif {$race == 3} { set side a
			} elseif {$race == 4} { set side a
			} elseif {$race == 5} { set side h
			} elseif {$race == 6} { set side h
			} elseif {$race == 7} { set side a
			} elseif {$race == 8} { set side h
			}
			return $side
	}
	proc Init {} {
		package require sqlite3
		sqlite3 stats "saves/stats.db"
		if { ![file size "saves/stats.db"] } {
			stats eval {CREATE TABLE `stats` (`name` TEXT PRIMARY KEY, `armor` TEXT, `agility` TEXT, `intellect` TEXT, `defense` TEXT, `strength` TEXT, `buff` TEXT)}
			set info "SQLite3 Stats database created."
			puts "[clock format [clock seconds] -format %k:%M:%S]:M:$info"
		}
		set loadinfo "Stats System v$::Balance::version by Raverouk loaded - SQLite3"
		puts "[clock format [clock seconds] -format %k:%M:%S]:M:$loadinfo"
	}				
}

namespace eval Enrage {
	proc Rage { player mob dr } {
		if {[ ::GetObjectType $player ] != 4} {
			set elite [Balance::Elite $mob]
			set type [::GetCreatureType $mob]
			set mobh [::GetHealthPCT $mob]
			set rnd [expr {int(rand()*100)}]
			switch $type {
				7 {
					if {($rnd <= 25) && ($mobh <= 25) && ($elite != 0) && (![::GetQFlag $mob Rage])} {
						Say $mob 0 "Arrggg"
						SetQFlag $mob Rage
						CastSpell $mob $mob 5229
						Emote $mob 16
					}
					if {($rnd >= 90) && (![::GetQFlag $mob Health]) && ($mobh <= 40) && ($elite == 0)} {
						SetQFlag $mob Health
						CastSpell $mob $mob 23965
					}
				}
				1 {
					if {($rnd <= 30) && ($mobh <= 30)} {
						SetQFlag $mob Rage
						CastSpell $mob $player 24187
					}
				}
			}
		}
		if {[::GetQFlag $mob Rage]} {set dr [expr {1-(1-$dr)*1.25}]}
		return $dr
	}
}
::Balance::Init
::Custom::AddCommand "ver" "Balance::Ver" 0
::Custom::AddCommand "call" "Balance::Call" 0
::Custom::AddCommand "stat" "Balance::Stat" 0

::Custom::HookProc ::WoWEmu::CalcXP {
	::ClearQFlag $victim Rage
	::ClearQFlag $victim Health
}
::Custom::HookProc ::AI::CanAgro {
	if {[::GetQFlag $victim IsDead]} { return 0 }
}
::Custom::HookProc ::WoWEmu::OnPlayerDeath {
	::ClearQFlag $killer Rage
	::ClearQFlag $killer Health
}
