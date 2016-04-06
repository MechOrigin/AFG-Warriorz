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
# Name:		AutoBan.tcl
#
# Version:	0.2.0
#
# Date:		2006-04-08
#
# Description:	Automatically bans a player using a cheat spell.
#
# Authors:	Spirit <thehiddenspirit@hotmail.com>
#		Lazarus Long <lazarus.long@bigfoot.com>
#
# Changelog:
#
# v0.2.0 (2006-04-08) - The "omg it's you again" version
#			Banned IPs can now be read and written to banned.conf.
#			No ".rescp" needed, the IPs are loaded and modified in
#			memory too.
#
# v0.1.0 (2006-04-05) - The "why don't you use custom" version
#			This script was written to demonstrate how
#			"::Custom::AddSpellScript" can be used.
#
#


#
#	StartTCL initialization
#
# StartTCL: n
#


#
#	Patch to apply to spells.dbc
#
# cheat spells to be used with DBC-Patcher
#
#;< cut from here down and remove the hash "#" from the begining of all lines >
#5:60=77
#265:60=77,58=0
#448:60=77
#1557:60=77
#1834:60=77
#2596:60=77
#3240:60=77
#3488:60=77
#4170:60=77,58=0
#6237:60=77
#7082:60=77
#9455:60=77
#9461:60=77
#9575:60=77
#10860:60=77,59=0
#11504:60=77
#112158:60=77,58=0
#12159:60=77,58=0
#13489:60=77
#14806:60=77
#16141:60=77
#17472:60=77
#17686:60=77
#17688:60=77
#18761:60=77
#18801:60=77
#19773:60=77
#19952:60=77
#20038:60=77,58=0
#20478:60=77
#20479:60=77
#20483:60=77
#20527:60=77
#20565:60=77
#20625:60=77
#21131:60=77
#21133:60=77
#21135:60=77
#21136:60=77
#21137:60=77
#21139:60=77
#21138:60=77
#21158:60=77
#22458:60=77
#23189:60=77
#23308:60=77
#23313:60=77
#23315:60=77
#23644:60=77
#23664:60=77
#23954:60=77
#23965:60=77
#24024:60=77
#24063:60=77
#24080:60=77
#24208:60=77
#24208:60=77
#25059:60=77
#25770:60=77
#25721:60=77
#25807:60=77
#;< end of patch cut until here>


#
#	namespace eval ::AutoBan
#
# AutoBan namespace and variable definitions
#
namespace eval ::AutoBan {
	variable VERSION 0.2.0

	# check for GmTools, of which we are fully dependent
	if { [ catch { ::StartTCL::Require GmTools } ] } {
		namespace delete [ namespace current ]
		return
	}

	# boolean to use or not the configuration file
	variable USE_CONF 1

	# File to log automatic bans in
	variable LOG_FILE "logs/autoban.log"

	# default fallback values
	variable BAN_FILE "scripts/conf/banned.conf"	;# emu.conf should
							;# include this file
	variable LOG 1
	variable DESTROY_LOOT 1
	variable DEL_ACCOUNT 0
	variable BAN_ACCOUNT 2

	# load configuration
	if { $USE_CONF } {
		::Custom::LoadConf "AutoBan" $::StartTCL::conf_file
	}

	# spells to have script effect on (these must be patched)
	variable CheatSpells {5 265 448 1557 1834 2596 3240 3488 4170 6237 7082 9455 9461 9575 10860 11504 12158 12159 13489 14806 16141 17472 17686 17688 18761 18801 19773 19952 20038 20478 20479 20483 20527 20565 20625 21131 21133 21135 21136 21137 21139 21138 21158 22458 23189 23308 23313 23315 23644 23664 23954 23965 24024 24063 24080 24208 24208 25059 25770 25721 25807}
}


#
#	proc ::AutoBan::OnCheat { to from spellid }
#
# trigger procedure fired when a player uses one of the cheat spells
#
proc ::AutoBan::OnCheat { to from spellid } {
	variable LOG
	variable DESTROY_LOOT
	variable DEL_ACCOUNT
	variable BAN_ACCOUNT
	variable LOG_FILE

	if { [ ::GetObjectType $from ] != 4 } {
		return
	}

	set guid [ ::GetGuid $from ]
	set account_info [ ::GmTools::gtGetAccountInfo [ ::GmTools::gtGetAccount $guid ] ]
	set account [ lindex $account_info 1 ]
	set ip [ lindex $account_info 3 ]
	set name [ ::GetName $from ]
	set target [ ::Custom::GetName $to ]

	if { $account == "" } {
		set account $guid
	}

	if { $ip == "" } {
		set ip [ ::AutoBan::GetIPByName $name ]
	}

	if { $DESTROY_LOOT && [ ::GetObjectType $to ] == 3 } {
		::Loot $from $to 33000 5
	}

	if { $BAN_ACCOUNT && [ ::GetPlevel $from ] < 2 || $BAN_ACCOUNT > 1 } {
		::AutoBan::AddToBanFile $ip
		::GmTools::gtBan $account
		::KickPlayer $from
	}

	if { $DEL_ACCOUNT } {
		::GmTools::gtDelAccount $account
	}

	if { $LOG } {
		::Custom::Log "account=$account ip=$ip name=$name spell=$spellid target=$target" $LOG_FILE
	}
}


#
#	proc ::AutoBan::OnLogin { to from spellid }
#
# trigger procedure fired when a player logs in
#
proc ::AutoBan::OnLogin { to from spellid } {
	variable LOG
	variable DEL_ACCOUNT
	variable BAN_ACCOUNT
	variable IsBanned
	variable LOG_FILE

	set guid [ ::GetGuid $from ]
	set account_info [ ::GmTools::gtGetAccountInfo [ ::GmTools::gtGetAccount $guid ] ]
	set ip [ lindex $account_info 3 ]
	set name [ ::GetName $from ]

	if { $ip == "" } {
		set ip [ ::AutoBan::GetIPByName $name ]
	}

	if { [ info exists IsBanned($ip) ] } {
		set account [ lindex $account_info 1 ]

		if { $account == "" } {
			set account $guid
		}

		if { $BAN_ACCOUNT && [ ::GetPlevel $from ] < 2 || $BAN_ACCOUNT > 1 } {
			::GmTools::gtBan $account
			::KickPlayer $from
		}

		if { $DEL_ACCOUNT } {
			::GmTools::gtDelAccount $account
		}

		if { $LOG } {
			::Custom::Log "account=$account ip=$ip name=$name event=\"login from banned ip\"" $LOG_FILE
		}
	}
}


#
#	proc ::AutoBan::GetIPByName { name }
#
# get IP from stat.xml if dbconsole fails (which doesn't seem to work properly
# with very long guids)
#
proc ::AutoBan::GetIPByName { name } {
	set file "www/stat.xml"

	if { ! [ file exists $file ] } {
		return
	}

	set found 0
	set hstat [ open $file ]

	while { [ gets $hstat line ] != -1 } {
		if { [ string match -nocase "*<name>*" $line ] } {
			set name [ lindex [ split $line "<>" ] 2 ]
			set found 1
		} elseif { $found && [ string match -nocase "*<ip>*" $line ] } {
			return [ lindex [ split $line "<>" ] 2 ]
		}
	}

	close $hstat
}


#
#	proc ::AutoBan::AddToBanFile { ip }
#
# add a IP to the permanent ban list
#
proc ::AutoBan::AddToBanFile { ip } {
	variable BAN_FILE
	variable IsBanned

	if { $ip != "" && ! [ info exists IsBanned($ip) ] } {
		set IsBanned($ip) 1

		if { $BAN_FILE != "" } {
			if { ! [ file exists $BAN_FILE ] } {
				set line "\[banned\]\n"
			}

			append line "ip=$ip"
			set hban [ open $BAN_FILE a ]
			puts $hban $line
			close $hban
		}
	}
}


#
#	proc ::AutoBan::LoadBanFile {}
#
# read the permanent ban list from file
#
proc ::AutoBan::LoadBanFile {} {
	variable BAN_FILE
	variable IsBanned

	if { $BAN_FILE == "" } { return }

	foreach { section data } [ ::Custom::ReadConf $BAN_FILE ] {
		if { [ string compare -nocase $section "banned" ] } {
			continue
		}

		foreach { key value } $data {
			if { ! [ string compare -nocase $key "ip" ] } {
				set IsBanned($value) 1
			}
		}
	}
}


#
#	proc ::AutoBan::Init {}
#
# initialization / registration of the spell scripts to monitor
#
proc ::AutoBan::Init {} {
	variable CheatSpells

	# initialization / register the spell scripts
	::AutoBan::LoadBanFile
	::Custom::AddSpellScript "::AutoBan::OnCheat" $CheatSpells
	::Custom::AddSpellScript "::AutoBan::OnLogin" 836
}


#
#	startup time command execution
#
# run the initialization procedure
#
::AutoBan::Init
