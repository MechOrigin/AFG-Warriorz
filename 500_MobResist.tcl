# start-tcl: n
#
# Mob Resist 0.3b-Rev 0.2
# Modded By Greenseed On 2006-04-10
# BreakRoot Work on Other Player
# Compatible with Startup 0.91 By Lazarus Long And Spirit
#
namespace eval ::MobResist {

	variable DEBUG 0
	# you may need this for more precision (locations are sub-maps, obtained with the GetLocation command)
	#variable ForbiddenLocations ""
	variable AllowedMaps "0 1 30 209 309 451 489 529"
	# list of root spells
	variable RootSpells "339 1062 5195 5196 9852 9853"
	# all the spells mobs should be able to resist
	variable ResistableSpells "25 56 101 113 118 339 408 456 512 692 700 710 745 835 853 949 1062 1090 1725 1776 1777 1833 1834 1968 1969 1970 2070 2094 2139 2637 2878 2497 2498 2499 2500 2501 2502 2503 2504 2505 2506 2647 2854 2880 2937 3109 3143 3260 3263 3271 3355 3542 3609 3618 3635 3636 4167 4168 4169 4246 4962 5101 5106 5164 5165 5195 5196 5198 5211 5249 5484 5530 5531 5567 5588 5589 5627 5648 5649 5703 5726 5727 5782 5951 6213 6215 6253 6271 6304 6358 6432 6435 6524 6533 6537 6580 6607 6664 6716 6728 6730 6749 6754 6770 6772 6798 6869 6894 6927 6945 6982 7144 7184 7267 7670 7761 7803 7922 7950 7961 7964 7967 8040 8064 8122 8124 8208 8242 8312 8346 8377 8399 8643 8646 8672 8739 8817 8893 8901 8902 8983 8994 9005 9032 9159 9179 9256 9454 9458 9484 9485 9823 9827 9852 9853 10234 10308 10326 10794 10852 10856 10888 10890 10955 11020 11297 11428 11430 11444 11650 11820 11876 11922 12023 12024 12098 12242 12252 12355 12461 12494 12509 12521 12747 12798 12809 12824 12825 12826 12890 13005 13099 13119 13138 13235 13327 13360 13608 13902 14030 14308 14309 14821 14823 14870 14902 15056 15252 15269 15283 15398 15471 15474 15535 15593 15609 15618 15655 15660 15753 15822 15878 15970 16045 16096 16104 16310 16451 16469 16508 16566 16600 16727 16790 16798 16869 16922 17011 17286 17293 17308 17333 17398 17500 17507 17624 17691 17743 17928 18093 18103 18373 18430 18546 18647 18657 18658 18795 18798 18812 18953 19128 19134 19185 19229 19364 19410 19482 19636 19641 19780 19872 19970 19971 19972 19973 19974 19975 20066 20253 20276 20277 20310 20511 20548 20549 20614 20615 20654 20663 20669 20683 20699 20861 20989 21152 21167 21173 21331 21916 21990 22127 22289 22415 22561 22592 22692 22707 22744 22787 22800 22915 22994 23103 23171 23186 23269 23279 23310 23312 23364 23414 23447 23454 23694 23775 23973 24004 24110 24152 24170 24335 24360 24375 24594 24600 24647 24648 24664 24671 24686 24690 24754 24778 24883 24919 25043 25056"
}
proc ::MobResist::Perform { to from spellid } {
	variable DEBUG
	if { [IsRootSpell $spellid] } {
		if { [IsInDoors $to] } {
			BreakRoots $to
			if { $DEBUG } {
				Say $from 0 "OMG!! That spell doesn't work here!!"
			 }
		} else {
			ResistSpell $to $from
		}
		return 1
	} elseif { [IsResistableSpell $spellid] } {
		ResistSpell $to $from
		return 1
	}
	return 0
}

proc ::MobResist::ResistSpell { to from } {
	variable DEBUG

	# perform resist only on mobs (object type 3)
	set object_type [GetObjectType $to]


	set mlvl [GetLevel $to]
	set plvl [GetLevel $from]
	set dif [expr {$plvl-$mlvl}]
	if { $dif > 90 } { set dif 90 }
	if { $dif < 1 } { set dif 1 }
	
	#set entry [GetEntry $to]
	#set elite [GetScpValue "creatures.scp" "creature $entry" "elite"]
	#if { ![string is digit -strict $elite] } { set elite 0 }
	set elite [Custom::GetElite $to]
	set rnd [expr {int((rand())*100)}]
	set chance [lindex "50 15 10 5 15" $elite]
	if { $object_type == 4 } { set chance 25}
	if { ![string is integer -strict $chance] } { set chance 0 }
	#~ Say $from 0 "$rnd - $dif - $chance"
	if { $rnd >= $dif+$chance } {
		after 3
		BreakRoots $to
	}
}

# only checks for indoors instances in the current implementation
proc ::MobResist::IsInDoors { obj } {
	variable AllowedMaps
	#variable ForbiddenLocations
	set map [lindex [GetPos $obj] 0]
	if { [lsearch $AllowedMaps $map] >= 0 } {
		# map was found in the AllowedMaps list
		return 0
	}
	# obj is indoors
	return 1
}

proc ::MobResist::IsRootSpell { spellid } {
	variable RootSpells
	if { [lsearch $RootSpells $spellid] >= 0 } {
		# spellid was found in the RootSpells list
		return 1
	} else {
		return 0
	}
}

proc ::MobResist::IsResistableSpell { spellid } {
	# results are cached for speed, since we have a long list
	variable IsResistableSpell
	if { ![info exists IsResistableSpell($spellid)] } {
		variable ResistableSpells
		if { [lsearch $ResistableSpells $spellid] >= 0 } {
			# spellid was found in the ResistableSpells list
			set IsResistableSpell($spellid) 1
		} else {
			set IsResistableSpell($spellid) 0
		}
	}
	return $IsResistableSpell($spellid)
}

	# removes stun, slowing, or immobilizing effect on "to"
proc ::MobResist::BreakRoots { to } {
	if { ![CastSpell $to $to 22890] } {
		return 0
	}
	return 1
}



