# StartTCL: c
#
#
# This file is part of the StartTCL Startup System
#
# StartTCL is (c) 2006 by Lazarus Long <lazarus.long@bigfoot.com>
# StartTCL is (c) 2006 by Spirit <thehiddenspirit@hotmail.com>
#
# StartTCL is free software; you can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the Free
# Software Foundation; either version 2.1 of the License, or (at your option)
# any later version.
#
# StartTCL is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
# details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA. You can also consult
# the terms of the license at:
#
#		<http://www.gnu.org/copyleft/lesser.html>
#
#
# Name:		ExtraCommands.tcl
#
# Description:	3rd party commands and procedures
#
# These commands come from UWC, adapted to StartTCL by Hochelf, special thanks
# to him.
#
#


::Custom::AddCommand {
	"additem" ::WoWEmu::Commands::additem 4
	"addmoney" ::WoWEmu::Commands::addmoney 4
	"addswp" ::WoWEmu::Commands::addswp 4
	"addtele" ::WoWEmu::Commands::addtele 4
	"addwp" ::WoWEmu::Commands::addwp 4
	"ban" ::WoWEmu::Commands::ban 4
	"bug" ::WoWEmu::Commands::bug 0
	"callpet" ::WoWEmu::Commands::callpet 0
	"castspell" ::WoWEmu::Commands::cCastSpell 4
	"delitem" ::WoWEmu::Commands::delitem 4
	"delmoney" ::WoWEmu::Commands::delmoney 4
	"deltele" ::WoWEmu::Commands::deltele 4
	"dismiss" ::WoWEmu::Commands::dismiss 0
	"emote" ::WoWEmu::Commands::cEmote 4
	"endway" ::WoWEmu::Commands::endway 6
	"imit" ::WoWEmu::Commands::imit 4
	"invisible" ::WoWEmu::Commands::invisible 4
	"isgm" ::WoWEmu::Commands::isgm 0
	"langall" ::WoWEmu::Commands::langall 4
	"learnall" ::WoWEmu::Commands::learnall 4
	"listbugs" ::WoWEmu::Commands::listbugs 4
	"listtele" ::WoWEmu::Commands::listtele 4
	"mergewp" ::WoWEmu::Commands::mergewp 6
	"pet_petdismiss" ::WoWEmu::Commands::dismiss 0
	"problem" ::WoWEmu::Commands::problem 0
	"pvp" ::WoWEmu::Commands::pvp 0
	"refresh" ::WoWEmu::Commands::refresh 0
	"setmessage" ::WoWEmu::Commands::setmessage 5
	"setwp" ::WoWEmu::Commands::setwp 6
	"showwp" ::WoWEmu::Commands::showwp 6
	"startway" ::WoWEmu::Commands::startway 6
	"tame" ::WoWEmu::Commands::tame 0
	"tele" ::WoWEmu::Commands::tele 3
	"visible" ::WoWEmu::Commands::visible 4
}


#
# player level 0
#

#
#	proc ::WoWEmu::Commands::pvp { player cargs }
#

proc ::WoWEmu::Commands::pvp { player cargs } {
	global userpos
	set player_name [ ::GetName $player ]
	set option [ lindex $cargs 0 ]

	if { $option == "" } {
		set msg [ ::Texts::Get "pvp_usage" ]
	} else {
		switch $option {
			"enter" {
				if { ! [ ::GetQFlag $player "jailed" ] } {
					if { ! [ ::GetQFlag $player "pvparena" ] } {
						set userpos($player_name) [ lindex [ ::GetPos $player ] ]
						::SetQFlag $player "pvparena"
						::Teleport $player 0 -13152.900391 342.729004 52.132801
					} else {
						return [ ::Texts::Get "already_there" ]
					}
				} else {
					return [ ::Texts::Get "no_enter_while_jailed" ]
				}
			}
			"leave" {
				if { ! [ ::GetQFlag $player "jailed" ] } {
					if { [ info exists userpos($player_name) ]==1 } {
						return [ ::Texts::Get "not_in_arena" ]
					}

					::ClearQFlag $player "pvparena"

					foreach { m x y z } userpos($player_name) {}

					::Teleport $player $m $x $y $z

					if { [ lindex [ ::GetPos $player ] 1 ] == $x } {
						set userpos($player_name) {}
					} else {
						return [ ::Texts::Get "cant_teleport" ]
					}
				}
			}			"info" {
				set msg [ ::Texts::Get "pvp_info" ]
			}
		}
	}
}


#
#	proc ::WoWEmu::Commands::problem { player cargs }
#
proc ::WoWEmu::Commands::problem { player cargs } {
	set file "log/problem_players.log"
	set selection [ ::GetSelection $player ]

	if { [ ::GetObjectType $selection ] != 4 } {
		return [ ::Texts::Get "target_player" ]
	}

	::Custom::Log "[ ::GetName $player ] [ ::Texts::Get "is_reporting" ] [ ::GetName $selection ]. [ ::Texts::Get "reason" ]: $cargs." $file
	return [ ::Texts::Get "thank_for_report" ]
}


#
#	proc ::WoWEmu::Commands::dismiss { player cargs }
#
variable ::WoWEmu::Commands::pbasedir "extra"

proc ::WoWEmu::Commands::dismiss { player cargs } {
	variable pbasedir
	set pname [ ::GetName $player ]
	set plevel [ ::GetLevel $player ]
	set pet [ ::GetSelection $player ]
	set pguid [ ::GetGuid $player ]
	set petid [ ::GetEntry $pet ]
	set petguid [ ::GetLinkObject $pet ]

	if { $player != $petguid } {
		return [ ::Texts::Get "select_pet" ]
	}

	set pethp [ ::GetHealthPCT $pet ]

	if { $pethp < 90 } {
		return [ ::Texts::Get "pet_more_life" ]
	}

	set pclass [ ::GetClass $player ]

	if { $pclass != 9 && $pclass!= 3 } {
		return
	}

	if { ! [ file exists "$pbasedir/pets/$pname" ] } {
		set file "$pbasedir/pets/$pname"
		set id [ open $file w+ ]
		puts $id "0 0 0"
		close $id
	}

	#class hunter##########
	if { $pclass == 3 } {
		set file "$pbasedir/pets/$pname"
		set id [ open $file r+ ]
		gets $id list
		close $id

		foreach { pet1 pet2 pet3 } $list {}

		if { $pet1 == 0 && $pet2 == 0 && $pet3 == 0 } {
			set id [ open $file w+ ]
			set newlist "$petid 0 0"
			puts $id $newlist
			close $id
		}

		if { $pet1 != 0 && $pet2 == 0 && $pet3 == 0 } {
			set id [ open $file w+ ]
			set newlist "$petid $pet1 0"
			puts $id $newlist
			close $id
		}

		if { $pet1 != 0 && $pet2 != 0 && $pet3 == 0 } {
			set id [ open $file w+ ]
			set newlist "$petid $pet2 $pet1"
			puts $id $newlist
			close $id
		}

		if { $pet1 != 0 && $pet2 != 0 && $pet3 != 0 } {
			return "PET_DISMISS_ERROR_TOO"
		}
	}

	#class warlock #################
	if { $pclass == 9 } {
		set file "$pbasedir/pets/$pname"
		set id [ open $file r+ ]
		gets $id list
		close $id
		set pet1 [ lindex $list 0 ]
		set id [ open $file w+ ]
		set newlist "$petid"
		puts $id $newlist
		close $id
	}
}


#
#	proc ::WoWEmu::Commands::callpet { player cargs }
#
proc ::WoWEmu::Commands::callpet { player cargs } {
	variable pbasedir
	set pclass [ ::GetClass $player ]
	set plevel [ ::GetLevel $player ]
	set pname [ ::GetName $player ]

	if { $pclass == 9 } {
		set file "$pbasedir/pets/$pname"
		set id [ open $file r+ ]
		gets $id list
		close $id
		set pet1 [ lindex $list 0 ]
		set id [ open $file r+ ]
		puts $id "0"
		close $id

		if { $pet1 == 416 } {
			::CastSpell $player $player 23503
		}

		if { $pet1 == 417 } {
			::CastSpell $player $player 23500
		}

		if { $pet1 == 1860 } {
			::CastSpell $player $player 23501
		}

		if { $pet1 == 1863 } {
			::CastSpell $player $player 23502
		}

		if { $pet1 == 89 } {
			::CastSpell $player $player 12740
		}

		if { $pet1 == 8616 } {
			::CastSpell $player $player 12740
		}

		if { $pet1 == 14385 } {
			::CastSpell $player $player 22865
		}
	}

	if { $pclass == 3 } {
		set file "$pbasedir/pets/$pname"
		set id [ open $file r+ ]
		gets $id list
		close $id

		foreach { pet1  pet2 pet3 } $list {}

		set pet 0

		if { $pet1 != 0 } {
			set pet $pet1
			set pet1 0
		} else {
			if { $pet2 != 0 } {
				set pet $pet2
				set pet2 0
			} else {
				if { $pet3 != 0 } {
				set pet $pet3
				set pet3 0
				}
			}
		}

		set id [ open $file w+ ]
		set newlist "$pet1 $pet2 $pet3"
		puts $id $newlist
		close $id
		set wolf "3823 3824 3825 1258 923 628 118 5449 69 213 299 525 565 704 705 1131 1133 1138 1817 1922 2680 2681 2924 2958 2960 3939 8959 10981 13618 833 834 2727 2728 2729 2730"
		set bear "8956 822 1128 1129 1186 1797 1778 1196 1189 1188 1815 2163 2164 2165 2351 3810 3809 2356 2354 3811 5268 5272 5433 7444"
		set bird "5436 1194 2578 2579 2580 2829 2830 2831 6013"
		set boar "113 524 708 1125 1126 1127 1190 1191 1192 1689 1984 1985 2966 3098 3099 3100 3225 5992 5437"
		set cat "3566 15101 3425 5438 2043 2042 2034 2033 2032 2031 3619 4242 7430 7431 7432 7433 7434 10042 681 682 698 976 1085 3121 2407 2406 2385 2384"
		set crawler "5439 830 831 922 1088 1216 2231 2232 2233 2234 2235 2236 2544 3106 3107 3108 3228 3812 3814 6250 12347"
		set crocolisk "5440 1082 1084 1150 1151 1152 1400 1417 1693 2089 2476 3110 3231 4341 4344 5053"
		set gorilla "5442 1108 1511 1557 2521 6514"
		set raptor "3254 3255 3256 5444 685 686 856 855 1015 1020 4351"
		set scorpid "5445 3124 3125 3126 3127 3226 4139 4140 5422 5423 5424 7078 7405 7803 9691 9695 9698 9701 11735"
		set spider "5446 30 43 217 539 1504 1505 1555 1986 2001 4376 4413 4415 5856 5857 5858 10375 14881"

		foreach x $wolf {
			if { $x == $pet } {
				if { $plevel < 20 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}

				::CastSpell $player $player 4946
			}
		}

		foreach x $bear {
			if { $x == $pet } {
				if { $plevel < 40 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}

				::CastSpell $player $player 7903
			}
		}

		foreach x $bird {
			if { $x == $pet } {
				if { $plevel < 12 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}

				::CastSpell $player $player 7904
			}
		}

		foreach x $boar {
			if { $x == $pet } {
				if { $plevel < 40 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}

				::CastSpell $player $player 7905
			}
		}

		foreach x $cat {
			if { $x == $pet } {
				if { $plevel < 50 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}

				::CastSpell $player $player 7906
			}
		}

		foreach x $crawler {
			if { $x == $pet } {
				if { $plevel < 50 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}

				::CastSpell $player $player 7907
			}
		}

		foreach x $crocolisk {
			if { $x == $pet } {
				if { $plevel < 50 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}

				::CastSpell $player $player 7908
			}
		}

		foreach x $gorilla {
			if { $x == $pet } {
				if { $plevel < 50 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}

				::CastSpell $player $player 7909
			}
		}
		foreach x $raptor {
			if { $x == $pet } {
				if { $plevel < 40 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}

				::CastSpell $player $player 7910
			}
		}

		foreach x $scorpid {
			if { $x == $pet } {
				if { $plevel < 35 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}

				::CastSpell $player $player 7911
			}
		}

		foreach x $spider {
			if { $x == $pet } {
				if { $plevel < 30 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}

				::CastSpell $player $player 7912
			}
		}

		if { $pet == 5448 } {
			::CastSpell $player $player 7915
		}

		if { $pet == 5443 } {
			::CastSpell $player $player 7916
		}

		if { $pet == 4535 } {
			::CastSpell $player $player 8274
		}

		if { $pet == 4534 } {
			::CastSpell $player $player 8276
		}
	}
}


#
#	proc ::WoWEmu::Commands::isgm { player cargs }
#
proc ::WoWEmu::Commands::isgm { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "target_player" ]
	}

	if { [ ::GetPlevel $target ] } {
		return [ ::Texts::Get "is_gm" ]
	}

	return [ ::Texts::Get "no_gm" ]
}


#	proc ::WoWEmu::Commands::tame { player cargs }
#
proc ::WoWEmu::Commands::tame { player cargs } {
	set pLvl [ ::GetPlevel $player ]

	if { $pLvl == 6 } {
		set Sel [ ::GetSelection $player ]

		if { $Sel == 0 } {
			return [ ::Texts::Get "select_target_first" ]
		}

		set plevel [ ::GetPlevel $player ]
		set elite [ ::GetScpValue creatures.scp "creature $Sel" elite ]

		if { ( $elite == 1 || $elite == 2 || $elite == 3 || $elite == 4 ) && $plevel < 4} {
			return [ ::Texts::Get "cant_tame_elite" ]
		}

		if { [ ::GetEntry $Sel ] == 0 } {
			return [ ::Texts::Get "cant_tame_player" ]
		}

		if { [ ::GetCreatureType $Sel ] == 7 } {
			return [ ::Texts::Get "cant_tame_npc" ]
		}

		if { [ ::GetCreatureType $Sel ] == 8 } {
			return [ ::Texts::Get "cant_tame_friendly" ]
		}

		if { [ ::GetLevel $Sel ] > [ ::GetLevel $player ] } {
			return [ ::Texts::Get "cant_tame_higher" ]
		}

		if { [ ::Distance $player $Sel] > 10 } {
			return [ ::Texts::Get "closer_to_target" ]
		}

		::CastSpell $player $Sel 13481
		return [ ::Texts::Get "beast_tamed" ]
	} else {
		return [ ::Texts::Get "you_not_gm" ]
	}
}


#
# player level 2
#

#
# player level 4
#

#
#	proc ::WoWEmu::Commands::additem { player cargs }
#
proc ::WoWEmu::Commands::additem { player cargs } {
	if { [ ::GetObjectType [ ::GetSelection $player ] ] != 4 } {
		return [ ::Texts::Get "select_player" ]
	}

	set name [ ::GetName [ ::GetSelection $player ] ]
	set iname [ ::GetScpValue "items.scp" "item $cargs" "name" ]

	if {$iname == "{}" } { return [ ::Texts::Get "item_not_found" ] }

	::AddItem [ ::GetSelection $player ] $cargs
	return "|c8f20ff20Item $iname ($cargs) [ ::Texts::Get "added_to" ] $name."
}


#
#	proc ::WoWEmu::Commands::addmoney { player cargs }
#
proc ::WoWEmu::Commands::addmoney { player cargs } {
	if { [ ::GetSelection $player ] == "0" } {
		return [ ::Texts::Get "select_player" ]
	}

	if { [ ::GetObjectType [ ::GetSelection $player ] ] != "4" } {
		return [ ::Texts::Get "select_player" ]
	}

	set cargs [ split $cargs ]

	if { [ llength $cargs ] } {
		if { [ lindex $cargs 0 ] > 0 } {
			::ChangeMoney [ GetSelection $player ] +[ lindex $cargs 0 ]
			set copper [ string range [ lindex $cargs 0 ] end-1 end ]
			set silver [ string range [ lindex $cargs 0 ] end-3 end-2 ]
			set gold [ string range [ lindex $cargs 0 ] end-1000 end-4 ]

			if { $copper > 0 } {
				set copper "$copper [ ::Texts::Get "copper" ]"
			} else {
				set copper ""
			}

			if { $silver != "" } {
				if { $silver > 0 } {
					set silver "$silver [ ::Texts::Get "silver" ]"
				} else {
					set silver ""
				}
			}

			if { $gold != "" } {
				set gold "$gold [ ::Texts::Get "gold" ]"
			}

			if { $copper != "" && $silver != "" } {
				set copper ", $copper"
			}

			if { $silver != "" && $gold != "" } {
				set silver ", $silver"
			}

			return "$gold$silver$copper [ ::Texts::Get "added_to" ] [ ::GetName [ ::GetSelection $player ] ]"
		} else {
			return [ ::Texts::Get "invalid_money" ]
		}
	}

	return "[ ::Texts::Get "bad_cmd_args" ] (.addmoney [ ::Texts::Get "amount" ])"
}


#
#	proc ::WoWEmu::Commands::addtele { player cargs }
#
variable ::WoWEmu::Commands::tbasedir "extra"

proc ::WoWEmu::Commands::addtele { player cargs } {
	variable tbasedir
	if { [ string length $cargs ] > 1 } {
		set handle [ open "$tbasedir/locations.dat" "a+" ]
		puts $handle "[ string trim $cargs ] [ ::GetPos $player ]"
		close $handle
		return [ ::Texts::Get "location_added" ]
	}

	return [ ::Texts::Get "no_location_name" ]
}


#
#	proc ::WoWEmu::Commands::addswp { player cargs }
#
variable ::WoWEmu::Commands::wbasedir "extra"

proc ::WoWEmu::Commands::addswp { player cargs } {
	variable wbasedir
	set pname [ ::GetName $player ]

	if { [ file exists "saves/ways/saveway$pname" ] } {
		set wayfile [ open "saves/ways/saveway$pname" r ]
		set latestadded [ gets $wayfile ]
		set firstwayp [ gets $wayfile ]
		close $wayfile
	} else {
		set latestadded [ open "saves/lastWPoint.txt" r ]
		set firstwayp $latestadded
	}

	set hwaypointfile [ open "saves/lastWPoint.txt" r ]
	set hwaypoint [ gets $hwaypointfile ]
	close $hwaypointfile

	if { $hwaypoint =="" } {
		set lastWP 1
	} else {
		set lastWP [ expr { $hwaypoint + 1 } ]
	}

	foreach { map x y z } [ ::GetPos $player ] {}

	if { $latestadded == 0 } {
		set hwaypointout [ open "scripts/waypoints.scp" a ]
	} else {
		set hwaypointout [ open "scripts/$wbasedir/ways/Way$pname.scp" a ]
		puts $hwaypointout "next=$lastWP\n"
	}

	set outline1 {[point }
	set outline2 {]}
	puts $hwaypointout "$outline1$lastWP$outline2"

	if { $latestadded == 0 } {
		puts $hwaypointout "name=TalkingWP\npos=$x $y $z\nscript=mobspeaking::npcsaywp\n"
	} else {
		puts $hwaypointout "name=TalkingWP\npos=$x $y $z\nscript=mobspeaking::npcsaywp"
	}

	close $hwaypointout
	set hwaypointfile [ open "saves/lastWPoint.txt" w ]
	puts -nonewline $hwaypointfile $lastWP
	close $hwaypointfile

	if { $latestadded == 0 } {
		return "Talking Waypoint $lastWP [ ::Texts::Get "created" ]."
	} else {
		set wayfile [ open "saves/ways/saveway$pname" w ]
		puts $wayfile $lastWP
		puts $wayfile $firstwayp
		close $wayfile
		return "Talking waypoint $lastWP [ ::Texts::Get "created_for_route_and" ] $latestadded ."
	}
}


#
#	proc ::WoWEmu::Commands::addwp { player cargs }
#
proc ::WoWEmu::Commands::addwp { player cargs } {
	variable wbasedir
	set pname [ ::GetName $player ]

	if { [ file exists "saves/ways/saveway$pname" ] } {
		set wayfile [ open "saves/ways/saveway$pname" r ]
		set latestadded [ gets $wayfile ]
		set firstwayp [ gets $wayfile ]
		close $wayfile
	} else {
		set latestadded [ open "saves/lastWPoint.txt" r ]
		set firstwayp $latestadded
	}

	set hwaypointfile [ open "saves/lastWPoint.txt" r ]
	set hwaypoint [ gets $hwaypointfile ]
	close $hwaypointfile

	if { $hwaypoint =="" } {
		set lastWP 1
	} else {
		set lastWP [ expr { $hwaypoint + 1 } ]
	}

	foreach { map x y z } [ ::GetPos $player ] {}

	if { $latestadded == 0 } {
		set hwaypointout [ open "scripts/waypoints.scp" a ]
	} else {
		set hwaypointout [ open "scripts/$wbasedir/ways/Way$pname.scp" a ]
		puts $hwaypointout "next=$lastWP\n"
	}

	set outline1 {[point }
	set outline2 {]}
	puts $hwaypointout "$outline1$lastWP$outline2"

	if { $latestadded == 0 } {
		puts $hwaypointout "pos=$x $y $z\n"
	} else {
		puts $hwaypointout "pos=$x $y $z"
	}

	close $hwaypointout
	set hwaypointfile [ open "saves/lastWPoint.txt" w ]
	puts -nonewline $hwaypointfile $lastWP
	close $hwaypointfile

	if { $latestadded == 0 } {
		return "Waypoint $lastWP [ ::Texts::Get "created" ]."
	} else {
		set wayfile [ open "saves/ways/saveway$pname" w ]
		puts $wayfile $lastWP
		puts $wayfile $firstwayp
		close $wayfile
		return "Waypoint $lastWP [ ::Texts::Get "created_for_route_and" ] $latestadded ."
	}
}


#
#	proc ::WoWEmu::Commands::ban { player cargs }
#
proc ::WoWEmu::Commands::ban { player cargs } {
	set ip_file "scripts/conf/banned.conf"

	if { [ ::GetObjectType [ ::GetSelection $player ] ] == 4} {
		return [ ::Texts::Get "plevel_conflict" ]
	}

	if { $cargs == "" } {
		return [ ::Texts::Get "banip_usage" ]
	}

	if { $cargs == "list" } {
		set base_name ""
		set ip [ open $ip_file r ]

		while { [ gets $ip line ] >= 0 } {
			set line [ string trim $line ]

			if { $line != "" && [ string index $line 0 ] != "#" } {
				lappend base_name $line
			}
		}

		close $ip
		return "$base_name"
	}

	if { $cargs == "undo" } {
		if { [ ::GetPlevel $player ] < 6 } {
			return [ ::Texts::Get "not_allowed" ]
		}

		set tcount 0
		set base_name ""
		set ip [ open $ip_file r ]

		while { [ gets $ip line ] >= 0 } {
			set line [ string trim $line ]

			if { $line != "" && [ string index $line 0 ] != "#" } {
				lappend base_name $line
				set tcount [ expr { $tcount + 1 } ]
			}
		}

		close $ip

		# stop [banned] being removed 1st line
		if { $tcount <= 1 } {
			return "[ ::Texts::Get "no_ips_lines_to_remove" ] $base_name"
		}

		Say $player 0 "$tcount"
		set oldcount [ expr { $tcount - 1 } ]
		set tcount 0
		set data " "
		set ip [ open $ip_file w ]

		foreach ipno $base_name {
			set writedata [ lindex $base_name $tcount ]

			if { $tcount == $oldcount } {
				puts $ip $data
			} else {
				puts $ip $writedata
				#Say $player 0 "TO WRITE > $writedata"
			}

			set tcount [ expr { $tcount + 1 } ]
		}

		close $ip
		return "[ ::Texts::Get "undo_done_last_line" ]: $base_name"
	}

	set gmname [ ::GetName $player ]
	set base_name ""
	set log_name ""
	set banip "ip=$cargs/255.255.255.0"
	set logip "ip=$cargs/255.255.255.0 $gmname"
	set iplist ""
	set ip [ open $ip_file r ]

	while { [ gets $ip line ] >= 0 } {
		set line [ string trim $line ]

		if { $line != "" && [ string index $line 0 ] != "#" } {
			if { $line == $banip } {
				close $ip
				return [ ::Texts::Get "ip_already_banned" ]
			}

			lappend base_name $line
			lappend log_name $line
		}
	}

	close $ip
	lappend base_name $banip
	lappend log_name $logip
	#Say $player 0 "read > $base_name"
	set ip [ open $ip_file w ]
	set tcount 0

	foreach ipno $base_name {
		set writedata [ lindex $base_name $tcount ]
		puts $ip $writedata
		#Say $player 0 "TO WRITE > $writedata"
		incr tcount
	}

	close $ip
	set ip_file "logs/banned.log"
	set tcount 0

	foreach ipno $log_name {
		set writedata [ lindex $log_name $tcount ]
		::Custom::Log $writedata $ip_file 0
		#Say $player 0 "TO WRITE > $writedata"
		incr tcount
	}

	::Custom::LogCommit $ip_file
	return "[ ::Texts::Get "ip_list_updated_noerror" ] > $base_name"
}


#
#	proc ::WoWEmu::Commands::bug { player cargs }
#
proc ::WoWEmu::Commands::bug { player cargs } {
	set file "logs/bugs.log"

	if { ! [ ::GetSelection $player ] } {
		return [ ::Texts::Get "bug_select" ]
	} else {
		set selection [ ::GetSelection $player ]
		::Custom::Log "[ ::GetName $player ]: $cargs. -(NPC: [ ::GetEntry $selection ])- Loc: .go [ ::GetPos $selection ]" $file
		return [ ::Texts::Get "thank_for_report" ]
	}
}


#
#	proc ::WoWEmu::Commands::castspell { player cargs }
#
proc ::WoWEmu::Commands::cCastSpell { player cargs } {
	if { [ llength $cargs ] } {
		set selection [ ::GetSelection $player ]

	        switch [ ::GetObjectType $selection ] {
			3 {
				set r [ ::CastSpell $player $selection $cargs ]
			}
			4 {
				set r [ ::CastSpell $player $selection $cargs ]
			}
			default {
				return [ ::Texts::Get "cant_cast_that" ]
			}
		}

		if { $r } {
			return OK
		} else {
			return [ ::Texts::Get "cant_cast_that" ]
		}
	} else {
		return [ ::Texts::Get "cant_cast_that" ]
	}

	return [ ::Texts::Get "input_spell" ]
}


#
#	proc ::WoWEmu::Commands::delitem { player cargs }
#
proc ::WoWEmu::Commands::delitem { player cargs } {
	if { [ ::GetObjectType [ ::GetSelection $player ] ] != 4 } {
		return [ ::Texts::Get "select_player" ]
	}

	set name [ ::GetName [ ::GetSelection $player ] ]
	set iname [ ::GetScpValue "items.scp" "item $cargs" "name" ]

	if { $iname == "{}" } {
		return [ ::Texts::Get "item_not_found" ]
	}

	if { [ ::ConsumeItem [ ::GetSelection $player ] $cargs 1 ] } {
		return "|c8f20ff20Item $iname ($cargs) [ ::Texts::Get "deleted_from" ] $name"
	} else {
		return "$iname ($cargs) [ ::Texts::Get "not_in_inventory" ] $name"
	}
}


#
#	proc ::WoWEmu::Commands::delmoney { player cargs }
#
proc ::WoWEmu::Commands::delmoney { player cargs } {
	if { [ ::GetSelection $player ] == "0" } {
		return [ ::Texts::Get "select_player" ]
	}

	if { [ ::GetObjectType [ ::GetSelection $player ] ] != "4"} {
		return [ ::Texts::Get "invalid_selection" ]
	}

	if { [ llength $cargs ] } {
		if { [ lindex $cargs 0 ] } {
			if { ! [ ::ChangeMoney [ ::GetSelection $player ] -[ lindex $cargs 0 ] ] } {
				return "Not enough money"
			} else {
				set copper [ string range [ lindex $cargs 0 ] end-1 end ]
				set silver [ string range [ lindex $cargs 0 ] end-3 end-2 ]
				set gold [ string range [ lindex $cargs 0 ] end-1000 end-4 ]

				if { $copper > 0 } {
					set copper "$copper [ ::Texts::Get "copper" ]"
				} else {
					set copper ""
				}

				if { $silver != "" } {
					if { $silver > 0 } {
						set silver "$silver [ ::Texts::Get "silver" ]"
					} else {
						set silver ""
					}
				}

				if { $gold != "" } {
					set gold "$gold [ ::Texts::Get "gold" ]"
				}

				if { $copper != "" && $silver != "" } {
					set copper ", $copper"
				}

				if { $silver != "" && $gold != "" } {
					set silver ", $silver"
				}

				return "$gold$silver$copper [ ::Texts::Get "removed_from" ] [ ::GetName [ ::GetSelection $player ] ]"
			}
		} else {
			return [ ::Texts::Get "invalid_money" ]
		}
	}

	return "[ ::Texts::Get "bad_cmd_args" ] (.delmoney [ ::Texts::Get "amount" ])"
}


#
#	proc ::WoWEmu::Commands::deltele { player cargs }
#
proc ::WoWEmu::Commands::deltele { player cargs } {
	variable tbasedir

	if { [ ::GetPlevel $player ] > 4 } {
		if { [ string length $cargs ] > 1} {
			set cargs [ string trim [ string tolower $cargs ] ]

			if { [ file exists "$tbasedir/locations.dat" ] } {
				set handle [ open "$tbasedir/locations.dat" ]
				set x 0
				set linenum ""

				while { [ gets $handle line ] >= 0 } {
					if { [ string tolower [ lrange $line 0 end-4 ] ] == $cargs } {
						set linenum $x
					}

					incr x
				}

				if { $linenum == "" } {
					return [ ::Texts::Get "location_not_found" ]
				}

				close $handle
				set handle [ open "$tbasedir/locations.dat" ]
				set data [ split [ read $handle ] \n ]
				close $handle
				set handle [ open "$tbasedir/locations.dat" w+ ]
				puts -nonewline $handle [ join [ lreplace $data $linenum $linenum ] \n ]
				close $handle
				return [ ::Texts::Get "location_deleted" ]
			}

			return [ ::Texts::Get "location_not_found" ]
		}

		return [ ::Texts::Get "specify_location" ]
	}

	return [ ::Texts::Get "bad_command" ]
}


#
#	proc ::WoWEmu::Commands::cEmote { player cargs }
#
proc ::WoWEmu::Commands::cEmote { player cargs } {
	if { [ llength $cargs ] } {
		set selection [ ::GetSelection $player ]

		switch [ ::GetObjectType $selection ] {
			3 {
				::Emote $selection $cargs
			}
			4 {
				::Emote $selection $cargs
			}
			default { return [ ::Texts::Get "cant_emote" ] }
		}

		return OK
	} else {
		return [ ::Texts::Get "" ]
	}

	return [ ::Texts::Get "cant_emote" ]
}


#
#	proc ::WoWEmu::Commands::endway { player cargs }
#
proc ::WoWEmu::Commands::endway { player cargs } {
	set pname [ ::GetName $player ]

	if { [ file exists "saves/ways/saveway$pname" ] } {
		set wayfile [ open "saves/ways/saveway$pname" r ]
		set latestadded [ gets $wayfile ]
		set firstwayp [ gets $wayfile ]
		close $wayfile
		set hwaypointout [ open "scripts/extra/ways/Way$pname.scp" "a+" ]
		puts $hwaypointout "next=$firstwayp\n"
		close $hwaypointout
		file delete "saves/ways/saveway$pname"
		return "[ ::Texts::Get "way_saved" ] $latestadded [ ::Texts::Get "linked_to_start" ].\n [ ::Texts::Get "way_starts_on" ] $firstwayp."
	} else {
		return [ ::Texts::Get "start_way_before" ]
	}
}


#
#	proc ::WoWEmu::Commands::imit { player cargs }
#
proc ::WoWEmu::Commands::imit { player cargs } {
	set lang [ lindex $cargs 0 ]
	set msg [ lrange $cargs 1 end ]
	set target [ ::GetSelection $player ]
	::Say $target $lang " $msg "
	return
}


#
#	proc ::WoWEmu::Commands::invisible { player cargs }
#
proc ::WoWEmu::Commands::invisible { player cargs } {
	::CastSpell $player $player 1784
	::WoWEmu::Commands::refresh
	return ".setmodel 13069"
}

#
#	proc ::WoWEmu::Commands::langall { player cargs }
#
proc ::WoWEmu::Commands::langall { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "select_player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only_gm_learn" ]
	}

	::LearnSpell $target 668
	::SetSkill $target 98 300 300
	::LearnSpell $target 669
	::SetSkill $target 109 300 300
	::LearnSpell $target 672
	::SetSkill $target 111 300 300
	::LearnSpell $target 7340
	::SetSkill $target 313 300 300
	::LearnSpell $target 671
	::SetSkill $target 113 300 300
	::LearnSpell $target 7341
	::SetSkill $target 315 300 300
	::LearnSpell $target 17737
	::SetSkill $target 673 300 300
	::LearnSpell $target 670
	::SetSkill $target 115 300 300
	::LearnSpell $target 17334
	::LearnSpell $target 17608
	::LearnSpell $target 17609
	::LearnSpell $target 17610
	::LearnSpell $target 17611
	::LearnSpell $target 17607
	return [ ::Texts::Get "learned_all_langs" ]
}


#
#	proc ::WoWEmu::Commands::learnall { player cargs }
#
proc ::WoWEmu::Commands::learnall { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "select_player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only_gm_learn" ]
	}

	::LearnSpell $target 9078
	::SetSkill $target 415 1 1
	::LearnSpell $target 9077
	::SetSkill $target 414 1 1
	::LearnSpell $target 8737
	::SetSkill $target 413 1 1
	::LearnSpell $target 16320
	::LearnSpell $target 750
	::SetSkill $target 293 1 1
	::LearnSpell $target 9116
	::SetSkill $target 433 1 1
	::LearnSpell $target 196
	::SetSkill $target 44 300 300
	::LearnSpell $target 198
	::SetSkill $target 54 300 300
	::LearnSpell $target 201
	::SetSkill $target 43 300 300
	::LearnSpell $target 197
	::SetSkill $target 172 300 300
	::LearnSpell $target 199
	::SetSkill $target 160 300 300
	::LearnSpell $target 202
	::SetSkill $target 55 300 300
	::LearnSpell $target 1180
	::SetSkill $target 173 300 300
	::LearnSpell $target 264
	::SetSkill $target 45 300 300
	::LearnSpell $target 266
	::SetSkill $target 46 300 300
	::SetSkill $target 226 300 300
	::LearnSpell $target 227
	::SetSkill $target 136 300 300
	::LearnSpell $target 5009
	::LearnSpell $target 5019
	::SetSkill $target 228 300 300
	::LearnSpell $target 2567
	::SetSkill $target 176 300 300
	::SetSkill $target 148 1 1
	::SetSkill $target 149 1 1
	::SetSkill $target 150 1 1
	::SetSkill $target 152 1 1
	::SetSkill $target 533 1 1
	::SetSkill $target 713 1 1
	::LearnSpell $target 11543
	::LearnSpell $target 11542
	::LearnSpell $target 11544
	::LearnSpell $target 20276
	::LearnSpell $target 24612
	::LearnSpell $target 21655
	::LearnSpell $target 22681
	::LearnSpell $target 23858
	::LearnSpell $target 23860
	return [ ::Texts::Get "learned_gm_spells" ]
}


#
#	proc ::WoWEmu::Commands::listbugs { player cargs }
#
proc ::WoWEmu::Commands::listbugs { player cargs } {
	set file "logs/bugs.log"

	if { $cargs == "" } {
		set cargs 1
	}

	set handle [ open $file r+ ]
	gets $handle pass
	set data [ read $handle ]
	set lines [ split $data \n ]
	set count [ lrange $lines end-$cargs end ]
	close $handle
	return $count
}


#
#	proc ::WoWEmu::Commands::listtele { player cargs }
#
proc ::WoWEmu::Commands::listtele { player cargs } {
	variable tbasedir

	if { [ ::GetPlevel $player ] } {
		if { [ file exists "$tbasedir/locations.dat" ] } {
			set handle [ open "$tbasedir/locations.dat" ]
			set list ""

			while { [ gets $handle line ] >= 0 } {
				set list "$list [ ::Texts::Get "name" ]: [ lrange $line 0 end-4 ] [ ::Texts::Get "target" ]: [ lrange $line end-3 end ]\n"
			}

			close $handle

			if {$list != ""} {
				return "$list"
			}
		}

		return [ ::Texts::Get "no_locations" ]
	}

	return [ ::Texts::Get "bad_command" ]
}


#
#	proc ::WoWEmu::Commands::mergewp { player cargs }
#
proc ::WoWEmu::Commands::mergewp { player cargs } {
	variable wbasedir
	set pname [ ::GetName $player ]

	if { [ file exists "scripts/$wbasedir/ways/Way$pname.scp" ] } {
		set mainwpfile [ open "scripts/waypoints.scp" "a+" ]
		set wpchainfile [ open "scripts/$wbasedir/ways/Way$pname.scp" "r" ]
		set wpchain [ read $wpchainfile ]
		puts $mainwpfile "\n$wpchain\n"
		close $wpchainfile
		close $mainwpfile
		file delete "scripts/$wbasedir/ways/Way$pname.scp"
		return "[ ::Texts::Get "file" ] Way$pname.scp [ ::Texts::Get "merged_with_main_file" ]\n[ ::Texts::Get "the_original" ] Way$pname.scp [ ::Texts::Get "deleted_run_rescp" ]"
	} else {
		return "[ ::Texts::Get "missing" ] Way$pname.scp [ ::Texts::Get "file_to_merge" ]"
	}
}


#
#	proc ::WoWEmu::Commands::refresh { player cargs }
#
proc ::WoWEmu::Commands::refresh { player cargs } {
	if { [ ::GetQFlag $player IsDead ] } {
		return [ ::Texts::Get "not_while_dead" ]
	}

	::Custom::TeleportPos $player [ ::GetPos $player ]
}


#
#	proc ::WoWEmu::Commands::setmessage { player cargs }
#
proc ::WoWEmu::Commands::setmessage { player cargs } {
	return ".broadcast $cargs"
}


#
#	proc ::WoWEmu::Commands::setwp { player cargs }
#
proc ::WoWEmu::Commands::setwp { player cargs } {
	if { ! [ string is integer $cargs ] } {
		return [ ::Texts::Get "waypoint_doesnt_exist" ]
	}

	set selected [ ::GetSelection $player ]

	if { [ ::GetObjectType $selected ] != 3} {
		return [ ::Texts::Get "select_npc" ]
	}

	::SetWayPoint $selected $cargs
	return "[ ::Texts::Get "ok_waypoint" ] $cargs [ ::Texts::Get "set_for_npc" ]"
}


#
#	proc ::WoWEmu::Commands::showwp { player cargs }
#
proc ::WoWEmu::Commands::showwp { player cargs } {
	set hwaypointfile [ open "saves/lastWPoint.txt" "r" ]
	set hwaypoint [ gets $hwaypointfile ]
	close $hwaypointfile

	if { $hwaypoint == "" } {
		set lastWP 1
	} else {
		set lastWP $hwaypoint
	}

	for { set i 1 } { $i <= $lastWP } { incr i } {
		set curPos [ lrange [ string trim [ split [ ::GetScpValue "waypoints.scp" "point $i" "pos" ] ] "\\\{\}" ] end-3 end ]
		set x [ expr { round([ lindex $curPos 0 ]) } ]
		set y [ expr { round([ lindex $curPos 1 ]) } ]
		::SendPOI $player 2 $x $y 6 1637 "WayPoint $i"
	}

	return "[ ::Texts::Get "waypoint" ] $hwaipoint [ ::Texts::Get "ok_shown" ]."
}


#
#	proc ::WoWEmu::Commands::startway { player cargs }
#
proc ::WoWEmu::Commands::startway { player cargs } {
	variable wbasedir
	set pname [GetName $player]

	if { [ file exists "saves/ways/saveway$pname" ] } {
		return [ ::Texts::Get "finish_before_new" ]
	}

	set hwaypointfile [ open "saves/lastWPoint.txt" r ]
	set hwaypoint [ gets $hwaypointfile ]
	close $hwaypointfile

	if { $hwaypoint == "" } {
		set lastWP 1
	} else {
		set lastWP [ expr { $hwaypoint + 1 } ]
	}

	foreach { map x y z } [ ::GetPos $player ] {}

	set hwaypointout [ open "scripts/$wbasedir/ways/Way$pname.scp" a ]
	set outline1 {[point }
	set outline2 {]}
	puts $hwaypointout "$outline1$lastWP$outline2"
	puts $hwaypointout "pos=$x $y $z"
	close $hwaypointout
	set hwaypointfile [ open "saves/lastWPoint.txt" w ]
	puts -nonewline $hwaypointfile $lastWP
	close $hwaypointfile
	set wayfile [ open "saves/ways/saveway$pname" w ]
	puts $wayfile $lastWP
	puts $wayfile $lastWP
	close $wayfile
	return "[ ::Texts::Get "route_started_waypoint" ] $lastWP [ ::Texts::Get "created" ]."
}


#
#	proc ::WoWEmu::Commands::tele { player cargs }
#
proc ::WoWEmu::Commands::tele { player cargs } {
	variable tbasedir

	if { [ ::GetPlevel $player ]} {
		if { [ string length $cargs ] > 1 } {
			set cargs [ string trim [ string tolower $cargs ] ]

			if { [ file exists "$tbasedir/locations.dat" ] } {
				set handle [ open "$tbasedir/locations.dat" ]

				while { [ gets $handle line ] >= 0 } {
					set loc [ string tolower [ lrange $line 0 end-4 ] ]

					if { $loc == $cargs } {
						set target [ lrange $line end-3 end ]
						::Custom::TeleportPos $player $target
						return "Teleporting to $target ([ lrange $line 0 end-4 ])"
					}
				}

				close $handle
			}

			return [ ::Texts::Get "location_not_found" ]
		}

		return [ ::Texts::Get "specify_location" ]
	}

	return [ ::Texts::Get "bad_command" ]
}


#
#	proc ::WoWEmu::Commands::visible { player cargs }
#

variable ::WoWEmu::Commands::visiblemodel
array set ::WoWEmu::Commands::visiblemodel {
	1	49
	2	51
	3	53
	4	55
	5	57
	6	59
	7	1563
	8	1478
}

proc ::WoWEmu::Commands::visible { player cargs } {
	variable visiblemodel
	::CastSpell $player $player 12844
	set race [ ::GetRace $player ]

	if { $cargs=="m" } {
		set model $visiblemodel($race)
	} elseif { $cargs=="f" } {
		set model [ expr { $visiblemodel($race) + 1 } ]
	} else {
		return [ ::Texts::Get "specify_gender" ]
	}

	if { $race >= 1 && $race <= 8 } {
		return ".setmodel $model"
	} else {
		return [ ::Texts::Get "now_visible" ]
	}

	return ".refresh"
}


#
# player level 6
#


######### Additional (useless?) procs #########

proc ::WoWEmu::Commands::mapupdate { player args } {
	return
}

proc ::WoWEmu::Commands::autojail {player reason} {
	variable jbasedir
	set gmname "Server"
	set plname [ ::GetName $player ]
	set _from [ lindex [ ::GetPos $player ] ]
	::Teleport $player 13 0 0 0

	if { [ lindex [ ::GetPos $player ] 0 ] == 13 } {
		set fh [ open "$jbasedir/jail/$plname" w ]
		puts $fh "$reason\n$gmname\n$_from"
		close $fh
		::SetQFlag $player "jailed"
	}
}

############# End of useless ^^ ################


::Custom::LogCommand {
	"additem"
	"addmoney"
	"ban"
	"castspell"
	"delitem"
	"delmoney"
	"jail"
}
