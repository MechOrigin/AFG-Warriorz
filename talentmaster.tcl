# StartTCL: c
#
# Name:		retalents.tcl
# Author:	Jecrell <jecrell@gmail.com>
#
# Description:	Talent Resetting Command
#
# Installation:
# This script requires J0S3's talent removing spell
# Which can be found here <http://rapidshare.de/files/18458247/retalents-spell.txt.html>
# Once that is installed, simply put this file into your scripts/tcl folder
# Enjoy the program

::Custom::AddCommand {
	"retalents" ::WoWEmu::Commands::JecResetTalents 4
}

#	Plevel 4 Commands
#	GAME MASTER

proc ::WoWEmu::Commands::JecResetTalents { player cargs } {
	set cible [ ::GetSelection $player ]
	set playerlevel [ ::GetLevel $cible ]
	set tpoints [expr $playerlevel - 9]	
	if { [ ::GetPlevel $player ] < 4 } {
		return [ ::Texts::Get "not_allowed" ]
	}
	if { [ ::GetObjectType $cible ] != 4 } { 
		return [ ::Texts::Get "target_player" ]
	} 
	if { $playerlevel <= 9 } {
                return "Player's level is too low! \nMinimum level for resetting talents: 10" 
        } 
	LearnSpell $cible 14867
	return ".setcp $tpoints"
}

#	EOF
