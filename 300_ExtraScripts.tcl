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
# Name:		ExtraScripts.tcl
#
# Description:	3rd party scripts support
#
# To use this, you need additional scripts or files not included with StartTCL:
#	RestState
#	Stats
#	AutoShot/Channeling
#	PickPoket/Stealth
#	Tame
#	Pet
#	Charge
#     MobResist
#     BossSpells
#
#
# Comment or delete what you don't need
#
# Note to script authors: Please consider making your scripts self-contained
#

namespace eval SpellEffects {
proc SPELL_EFFECT_SCRIPT_EFFECT { to from spellid } {
switch $spellid {
5 {OnLogin::Cheater $from $spellid} 
265 {OnLogin::Cheater $from $spellid}
448 {OnLogin::Cheater $from $spellid}
1557 {OnLogin::Cheater $from $spellid}
1834 {OnLogin::Cheater $from $spellid}
2596 {OnLogin::Cheater $from $spellid}
3240 {OnLogin::Cheater $from $spellid}
3488 {OnLogin::Cheater $from $spellid}
4170 {OnLogin::Cheater $from $spellid}
6237 {OnLogin::Cheater $from $spellid}
7082 {OnLogin::Cheater $from $spellid}
9455 {OnLogin::Cheater $from $spellid}
9461 {OnLogin::Cheater $from $spellid}
9575 {OnLogin::Cheater $from $spellid}
10860 {OnLogin::Cheater $from $spellid}
11504 {OnLogin::Cheater $from $spellid}
12158 {OnLogin::Cheater $from $spellid}
12159 {OnLogin::Cheater $from $spellid}
13489 {OnLogin::Cheater $from $spellid}
14806 {OnLogin::Cheater $from $spellid}
16141 {OnLogin::Cheater $from $spellid}
17472 {OnLogin::Cheater $from $spellid}
17686 {OnLogin::Cheater $from $spellid}
17688 {OnLogin::Cheater $from $spellid}
18761 {OnLogin::Cheater $from $spellid}
18801 {OnLogin::Cheater $from $spellid}
19773 {OnLogin::Cheater $from $spellid}
19952 {OnLogin::Cheater $from $spellid}
20038 {OnLogin::Cheater $from $spellid}
20478 {OnLogin::Cheater $from $spellid}
20479 {OnLogin::Cheater $from $spellid}
20483 {OnLogin::Cheater $from $spellid}
20527 {OnLogin::Cheater $from $spellid}
20565 {OnLogin::Cheater $from $spellid}
20625 {OnLogin::Cheater $from $spellid}
21131 {OnLogin::Cheater $from $spellid}
21133 {OnLogin::Cheater $from $spellid}
21135 {OnLogin::Cheater $from $spellid}
21136 {OnLogin::Cheater $from $spellid}
21137 {OnLogin::Cheater $from $spellid}
21139 {OnLogin::Cheater $from $spellid}
21138 {OnLogin::Cheater $from $spellid}
21158 {OnLogin::Cheater $from $spellid}
22458 {OnLogin::Cheater $from $spellid}
23189 {OnLogin::Cheater $from $spellid}
23308 {OnLogin::Cheater $from $spellid}
23313 {OnLogin::Cheater $from $spellid}
23315 {OnLogin::Cheater $from $spellid}
23644 {OnLogin::Cheater $from $spellid}
23664 {OnLogin::Cheater $from $spellid}
23954 {OnLogin::Cheater $from $spellid}
23965 {OnLogin::Cheater $from $spellid}
24024 {OnLogin::Cheater $from $spellid}
24063 {OnLogin::Cheater $from $spellid}
24080 {OnLogin::Cheater $from $spellid}
24208 {OnLogin::Cheater $from $spellid}
24208 {OnLogin::Cheater $from $spellid}
25770 {OnLogin::Cheater $from $spellid}
25721 {OnLogin::Cheater $from $spellid}
75 { AutoShot::Bow $to $from } 
5019 { AutoShot::Wand $to $from } 
25807 {OnLogin::Cheater $from $spellid}
default { puts "warning! spell effect script $spellid without case" } }
}
}

#
# Mod by Delfin
# BossSpells
# 17.04.06
#
namespace eval ::BossSpells {
	proc ::BossSpells::ShadowFlameConsume { to from } {
		set chance 50
		set random [ expr { int(rand()*100) } ]
		if { $random <= $chance } { 
			::CastSpell $from $to 22682 
		}
	}
}

#
# Mod by Delfin
# AI_CanAgro level depending
# 17.04.06

# This is not blizz-like proc of aggro,
# so if you want blizz-like - don't uncomment it
# because on blizz all hostile mobs do aggro, only distance counts
#

#
#::Custom::HookProc "::WoWEmu::ModXP" {
#	set victimlvl [ ::GetLevel $victim ]
#	set moblvl [ ::GetLevel $npc ]
#	set vklvl [ expr { $victimlvl - 5 } ]
#	if { [ ::GetQFlag $victim stealth ] } { 
#		return 0 
#	} 
#	if { $vklvl > $moblvl } { 
#		return 0 
#	}
#}

#
# Mod by Delfin
# for MobResist
# 17.04.06
#
::Custom::HookProc "::SpellEffects::SPELL_EFFECT_SCRIPT_EFFECT" {
	if { [ MobResist::Perform $to $from $spellid ] } { 
		return 
	}
}

#
# Autoshot & Channeling System v1.0 by seatleson
# Adopted for Start-TCL 0.9.2 by Delfin
# 17.04.06
#
::Custom::HookProc "::WoWEmu::DamageReduction" {
	global channelingticks 
	global channelingticksA 

	if { [ info exists channelingticks($player) ] != 0 } { 
		set channelingticks($player) 0 
	} 
	if { [ info exists channelingticksA($player) ] != 0 } { 
		set channelingticksA($player) 0 
	} 

}

#
# RestState
#
::Custom::HookProc "::WoWEmu::ModXP" {
	if { [ ::RestState::restxpcount $killer ] == 1 } {
		set xp [ expr { $xp * 2 } ]
	}
	::ClearQFlag $killer resting
}

#
# Stats
#
namespace eval ::WoWEmu {
	variable gmlvl 255
	variable maxplrlvl 60
	variable maxmoblvl 501
	variable maxdif 8
	variable mindif 16
}

::Custom::HookProc "::WoWEmu::DamageReduction" {
	if { [ ::Balance::Hit $player $mob ] } {
		return 1.
	}

	set armor [ ::Balance::Armor $player $armor ]
}

::Custom::HookProc "::WoWEmu::ModDR" {
	variable gmlvl
	variable maxplrlvl
	variable maxmoblvl
	variable maxdif
	variable mindif
	set plrlvl [ ::GetLevel $player ]
	set moblvl [ ::GetLevel $mob ]
	set object [ ::GetObjectType $mob ]

	if { $plrlvl >= $gmlvl } {
		return 1
	}
	if { $plrlvl > $maxplrlvl } {
		set plrlvl $maxplrlvl
	}
	if { $moblvl > $maxmoblvl } {
		set moblvl $maxmoblvl
	}

	if { $object == 3 } {
		set entry [ ::GetEntry $mob ]
		set damage_list [ ::Custom::GetCreatureScp $entry "damage" ]
		set dmg [ ::Custom::RandInt [ lindex $damage_list 0 ] [ lindex $damage_list end ] ]
		set dr [ expr { $armor / double( $armor + 400 + 85 * $moblvl + 25 * $dmg ) } ]
	}

	if { $plrlvl > $moblvl } {
		set dif [ expr { $plrlvl - $moblvl } ]
		set bonus [ expr { $dif / 500. } ]
		set dr [ expr { $dr + $bonus } ]

		if { $plrlvl >= $moblvl + $mindif } {
			set dr [ expr { $plrlvl / 100. + $dr * .25 + .05 } ]
		}
	} elseif { $moblvl >= $plrlvl + $maxdif } {
		set dr [ expr { $dr * 1.15 + $plrlvl / 200. - .8 } ]
	}

	set dr [ ::Balance::Dr $player $mob $dr ]
}


#
# Stealth
#
Custom::HookProc "::AI::ModAgro" {
	if { [ ::GetQFlag $victim stealth ] } {
		return 0
	}
}
Custom::HookProc "::WoWEmu::DamageReduction" {
	::ClearQFlag $player stealth
}

#
#	array set ::SpellEffects::LegacySpellScripts
#
# AutoShot/Channeling, PickPoket/Stealth, Tame, Pet, Charge
#
# Note to script authors: Please consider converting your procedures so they can
# directly use ::Custom::AddSpellScript
#
variable ::SpellEffects::LegacySpellScripts
array set ::SpellEffects::LegacySpellScripts {
	  100 { ChargeSkills::Charge $to $from }
	 6178 { ChargeSkills::Charge $to $from }	
	11578 { ChargeSkills::Charge $to $from }
	12695 { ChargeSkills::ChargeStun $from }
	20252 { ChargeSkills::Intercept1 $to $from }
	20616 { ChargeSkills::Intercept2 $to $from }	
	20617 { ChargeSkills::Intercept3 $to $from }
	14530 { ChargeSkills::InterceptStun1 $from }
	17498 { ChargeSkills::InterceptStun2 $from }
	22863 { ChargeSkills::InterceptStun3 $from }

	22539 { BossSpells::ShadowFlameConsume $to $from }

	  694 { CastSpell $to $from 20508 }
	 7400 { CastSpell $to $from 20508 }
	 7402 { CastSpell $to $from 20508 }
	20559 { CastSpell $to $from 20508 }
	20560 { CastSpell $to $from 20508 }
	  355 { CastSpell $to $from 20508 }

	   75 { AutoShot::Bow $to $from } 
	 5019 { AutoShot::Wand $to $from } 
	 5143 { set to [GetSelection $from]; Channeling::Start $to $from 7268 3 }	
	 7268 { Channeling::Maintain $to $from 7268 }
	 5144 { set to [GetSelection $from]; Channeling::Start $to $from 7269 4 }	
	 7269 { Channeling::Maintain $to $from 7269 }		
	 5145 { set to [GetSelection $from]; Channeling::Start $to $from 7270 5 }	
	 7270 { Channeling::Maintain $to $from 7270 }		
	 8416 { set to [GetSelection $from]; Channeling::Start $to $from 8419 5 }	
	 8419 { Channeling::Maintain $to $from 8419 }	
	 8417 { set to [GetSelection $from]; Channeling::Start $to $from 8418 5 }	
	 8418 { Channeling::Maintain $to $from 8418 }		
	10211 { set to [GetSelection $from]; Channeling::Start $to $from 10273 5 }	
	10273 { Channeling::Maintain $to $from 10273 }		
	10212 { set to [GetSelection $from]; Channeling::Start $to $from 10274 5 }	
	10274 { Channeling::Maintain $to $from 10274 }		
	25345 { set to [GetSelection $from]; Channeling::Start $to $from 25346 5 }	
	25346 { Channeling::Maintain $to $from 25346 }		
	10797 { Channeling::StartAndMaintain $to $from 10797 6 }
	19296 { Channeling::StartAndMaintain $to $from 19296 6 }
	19299 { Channeling::StartAndMaintain $to $from 19299 6 }
	19302 { Channeling::StartAndMaintain $to $from 19302 6 }
	19303 { Channeling::StartAndMaintain $to $from 19303 6 }
	19304 { Channeling::StartAndMaintain $to $from 19304 6 }
	19305 { Channeling::StartAndMaintain $to $from 19305 6 }		
	16914 { Channeling::StartAndMaintainA $to $from 16914 10 }
	17401 { Channeling::StartAndMaintainA $to $from 17401 10 }
	17402 { Channeling::StartAndMaintainA $to $from 17402 10 }		
	   10 { Channeling::StartAndMaintainA $to $from 10 8 }
	 6141 { Channeling::StartAndMaintainA $to $from 6141 8 }
	 8427 { Channeling::StartAndMaintainA $to $from 8427 8 }
	10185 { Channeling::StartAndMaintainA $to $from 10185 8 }
	10186 { Channeling::StartAndMaintainA $to $from 10186 8 }
	10187 { Channeling::StartAndMaintainA $to $from 10187 8 }
	15407 { Channeling::StartAndMaintain $to $from 15407 3 }
	17311 { Channeling::StartAndMaintain $to $from 17311 3 }
	17312 { Channeling::StartAndMaintain $to $from 17312 3 }
	17313 { Channeling::StartAndMaintain $to $from 17313 3 }
	17314 { Channeling::StartAndMaintain $to $from 17314 3 }
	18807 { Channeling::StartAndMaintain $to $from 18807 3 }
	  740 { Channeling::StartAndMaintainA $to $from 740 10 }
	 8918 { Channeling::StartAndMaintainA $to $from 8918 10 }
	 9862 { Channeling::StartAndMaintainA $to $from 9862 10 }
	 9863 { Channeling::StartAndMaintainA $to $from 9863 10 }
	 5740 { Channeling::StartAndMaintainA $to $from 5740 8 }
	 6219 { Channeling::StartAndMaintainA $to $from 6219 8 }
	11677 { Channeling::StartAndMaintainA $to $from 11677 8 }
	11678 { Channeling::StartAndMaintainA $to $from 11678 8 }
	12051 { Channeling::StartAndMaintainA $to $from 12051 8 }
	 5138 { Channeling::StartAndMaintain $to $from 5138 5 }
	 6226 { Channeling::StartAndMaintain $to $from 6226 5 }
	11703 { Channeling::StartAndMaintain $to $from 11703 5 }
	11704 { Channeling::StartAndMaintain $to $from 11704 5 }		
	  689 { Channeling::StartAndMaintain $to $from 689 5 }
	  699 { Channeling::StartAndMaintain $to $from 699 5 }
	  709 { Channeling::StartAndMaintain $to $from 709 5 }
	 7651 { Channeling::StartAndMaintain $to $from 7651 5 }
	11699 { Channeling::StartAndMaintain $to $from 11699 5 }
	11700 { Channeling::StartAndMaintain $to $from 11700 5 } 

	  883 { stbmstpets::callpet $to }

	  921 { vor::vol $from $to }

	 1784 { SetQFlag $from stealth }
	 1785 { SetQFlag $from stealth }
	 1786 { SetQFlag $from stealth }
	 1787 { SetQFlag $from stealth }

	 1515 { Tame::Taming $from $to }

	19548 { Tame::Quests $from $to 1196 6085 15908 }
	19674 { Tame::Quests $from $to 1126 6064 15911 }
	19687 { Tame::Quests $from $to 1201 6084 15913 }
	19688 { Tame::Quests $from $to 2956 6061 15914 }
	19689 { Tame::Quests $from $to 2959 6087 15915 }
	19692 { Tame::Quests $from $to 2970 6088 15916 }
	19693 { Tame::Quests $from $to 1998 6063 15921 }
	19694 { Tame::Quests $from $to 3099 6062 15917 }
	19696 { Tame::Quests $from $to 3107 6083 15919 }
	19697 { Tame::Quests $from $to 3126 6082 15920 }
	19699 { Tame::Quests $from $to 2043 6101 15922 }
	19700 { Tame::Quests $from $to 1996 6102 15923 }
}


proc ::SpellEffects::AddLegacySpellScripts {} {
	foreach { spellid commands } [ array get ::SpellEffects::LegacySpellScripts ] {
		eval "proc ::SpellEffects::LegacySpellScript$spellid { to from spellid } { $commands }"
		::Custom::AddSpellScript "::SpellEffects::LegacySpellScript$spellid" $spellid
	}
}

::SpellEffects::AddLegacySpellScripts

