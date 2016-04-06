# Start-TCL: n

#
#
#
# This program is (c) 2006 by Aceindy <aceindy@gmail.com>
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
#               <http://www.gnu.org/copyleft/lesser.html>
#
#
# A lot of code of this program is based on the Lazarus Long's ngauction.scl
# who graciously allowed the licensing of this derivated work under the
# above License. This does not imply that the original code nor its
# versions are under the same license as long as they don't include
# code specific from this program. Only this program and derivated work from it
# are subject to the above License. The original code is (c)Lazarus Long
# and you must contact him for licensing details.
#
#
# Name:		ngjail.tcl
#
# Date:		2006-04-20
#
# Description:	NextGen Jailing System
#
# Author:	AceIndy  <aceindy@gmail.com>
#
#
# Please remove old jail procedure from scripts\tc\api\WoWEmu_Commands.tcl before use
#				proc ::WoWEmu::Commands::jail {player cargs} {
#							................
#							................
#							................
#							}
#
# syntax: .jail for <hrs> <reason> 		[GMlvl4]
#					.jail free									[GMlvl4]
#					.jail list									[GMlvl4]
#					.jail info									[GMlvl4]
# 				.jailconf	create		  			[GMlvl4]
# 				.jailconf	cleanup	  				[GMlvl4]
# 				.jailconf	drop	  				  [GMlvl4]
# 				.jailconf	version	  				[GMlvl4]
# 				.jailconf	info	  					[GMlvl4]
# 				.free 											[players]

##################################################
#	namespace eval ngjail {}
#
#	global setup
#
# Load the required SQLdb module
#
package require SQLdb

##################################################
#Create namespace ngjail
#
namespace eval ::ngjail {
	variable NAME "ngjail"
	variable VERSION "0.0.7"
	variable MIN_CUSTOM_VERSION "1.95"
	variable gm_level 6
  	
	# Set to 1 to set DEBUG on...
	variable DEBUG 0
	variable s_logprefix "[ clock format [ clock seconds ] -format %k:%M:%S ]:M"
	variable s_logDebug

	variable s_lang "default"
	# To use the system wide setting uncomment below and comment the above one
	# variable s_lang $::LANG

	# SQLdb handle
	variable handle

	# Language strings (en)
	variable c_dbg01 "Entered procedure "

	variable l_hlp01 "NextGen Jail system (v%2\$s) - Usage:%1\$c%1\$c%3\$s \[ %4\$s \| %5\$s \]%1\$c%4\$-13s - Will free you if jailtime is over"
	variable l_hlp02 "NextGen Jail System (v%2\$s) - Usage:%1\$c%1\$c%3\$s \[ %4\$s \| %5\$s \| %6\$s \| %7\$s \| %8\$s \]%1\$c%4\$-12s - Removes wasted space from the database%1\$c%5\$-14s - Drops the tables from sqldb%1\$c%6\$-14s - recreates the tables from scratch%1\$c%7\$-14s - displays the current program version%1\$c%8\$-15s - shows this info"
	variable l_hlp03 "NextGen Jail System (v%2\$s) - Usage:%1\$c%1\$c%3\$s \[ %4\$s \| %5\$s \| %6\$s \| %7\$s \| %8\$s \]%1\$c%4\$-1s <Hrs> <Reason>   - Jails selected player %1\$c%5\$-29s - Frees selected player from jail%1\$c%6\$-29s - clear Qflag on selected player%1\$c%7\$-31s - lists currently jailed%1\$c%8\$-30s - shows this info"

	variable l_ver01 "ngJail system script is at version %s"

	variable l_dba01 "You are not allowed to use this command!"
	variable l_dba02 "ngJail system (v%s) database"
	variable l_dba03 "Database cleanup done."
	variable l_dba04 "The tables were successfully dropped"
	variable l_dba05 "The tables were successfully updated."
	variable l_dba06 "The tables are already up to date."
	variable l_dba07 "Database tables already exist, if you want to recreate them use%2\$c\"%1\$s\"."
	variable l_dba08 "done"
	variable l_dba09 "Database tables setup %s."

	variable h_wrk01 "Error in ngJail system."
}
##################################################
#	proc ::ngjail::jailhelp { player }
#
# Returns a help screen depending on your level (hand called)
#
proc ::ngjail::jailhelp { } {
	variable VERSION
	variable DEBUG

	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc jailhelp{}:"
		puts "$s_logDEBUG $::ngjail::c_dbg01"
	}
		return [ format $::ngjail::l_hlp03 10 $VERSION ".jail" "for" "free" "reset" "list" "info" ]
}

##################################################
#	proc ::acecustom::help { player }
#
# Returns a help screen depending on your level (hand called)
#
proc ::ngjail::help { player } {
	variable VERSION
	variable DEBUG

	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc help{}:"
		puts "$s_logDEBUG $::ngjail::c_dbg01"
	}

	if { [ ::GetPlevel $player ] < $::ngjail::gm_level } {
		return [ format $::ngjail::l_hlp01 10 $VERSION ".free" "" ]
	} else {
		return [ format $::ngjail::l_hlp02 10 $VERSION ".jailconf" "cleanup" "drop" "create" "version" "info" ]
	}
}

##################################################
#	proc ::ngjail::setSQLdb { }
#
# Internal procedure to set, check and update the SQLdb database when needed
# This procedure runs once during init.
#
proc ::ngjail::setSQLdb { } {
	variable DEBUG
	variable handle

	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc setSQLdb{}:"
		puts "$s_logDEBUG $::ngjail::c_dbg01"
	}

	if { ! [ ::SQLdb::booleanSQLdb $handle "SELECT * FROM `$::SQLdb::NAME` WHERE (`name` = '$::ngjail::NAME')" ] } {
		if { [ ::SQLdb::existsSQLdb $handle `ngjail` ] } {
			::ngjail::db 0 drop
			::ngjail::db 0 create
		} else {
			::ngjail::db 0 create
		}
		::SQLdb::querySQLdb $handle "INSERT INTO `$::SQLdb::NAME` (`name`, `version`) VALUES('$::ngjail::NAME', '$::ngjail::VERSION')"
	} else {
		set s_oldver [ ::SQLdb::firstcellSQLdb $handle "SELECT `version` FROM `$SQLdb::NAME` WHERE (`name` = '$::ngjail::NAME')" ]

		if { [ expr { $s_oldver > $::ngjail::VERSION } ] } {
			if { $DEBUG } {
				return -code error "$s_logDEBUG The current version of $::ngjail::NAME ($::ngjail::VERSION) is older that the previous one ($s_oldver), downgrade unsupported, use .jailconf drop!"
			} else {
				return -code error "$SQLdb::s_logprefix: The current version of $::ngjail::NAME ($::ngjail::VERSION) is older that the previous one ($s_oldver), downgrade unsupported, use .jailconf drop!"
			}
		} elseif { [ expr { $s_oldver < $::ngjail::VERSION } ] } {
			::ngjail::db 0 drop
			::ngjail::db 0 create
			::SQLdb::querySQLdb $handle "UPDATE `$SQLdb::NAME` SET `version` = '$::ngjail::VERSION', `previous` = '$s_oldver', `date` = CURRENT_TIMESTAMP WHERE (`name` = '$::ngjail::NAME')"
		} else {
			::ngjail::db 0 create
		}
	}
}

##################################################
#	proc ::ngjail::db { player cargs }
#
# Setup/cleanup the database (hand called)
#
# ( make sure the this line:
#
# ::Custom::AddCommand "ace" "::ngjail::db"
#
# is mentioned at the bottom of this file
#
proc ::ngjail::db { player cargs } {
	variable VERSION
	variable DEBUG
	variable handle

	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc db{}:"
		puts "$s_logDEBUG $::ngjail::c_dbg01"
	}

	set i_maxchar 127
	set s_ret [ format $::ngjail::l_dba02 $VERSION ]

	switch [ string tolower $cargs ] {
		"version" -
		"dbversion" {
			return "$s_ret:\n\n[ ::SQLdb::versionSQLdb $handle ]"
		}
		"cleanup" {
			::SQLdb::cleanupSQLdb $handle
			return "$s_ret:\n\n$::ngjail::l_dba03"
		}
		"drop" {
			if { [ ::SQLdb::existsSQLdb $handle `ngjail` ] } {
				::SQLdb::querySQLdb $handle "DROP TABLE `ngjail`"
			}
			::SQLdb::cleanupSQLdb $handle
			set s_done $::ngjail::l_dba04
		}
		"create" {
			set create 0
			if { ! [ ::SQLdb::existsSQLdb $handle `ngjail` ] } {
				::SQLdb::querySQLdb $handle "CREATE TABLE `ngjail` (`name` VARCHAR($i_maxchar) PRIMARY KEY NOT NULL DEFAULT '', `jaildate` VARCHAR($i_maxchar), `jailtime` VARCHAR($i_maxchar),  `pos` VARCHAR($i_maxchar), `bindpos` VARCHAR($i_maxchar), `reason` VARCHAR($i_maxchar) NOT NULL DEFAULT 'Autojailed', `jail` INTEGER NOT NULL DEFAULT 0 )"
				incr create
			}
			if { $create == 0 } {	
				append s_ret ":\n\n" [ format $::ngjail::l_dba07 ".jailconf drop" 10 ]
			} else {
				if { ! [ info exists s_done ] } {
					set s_done $::ngjail::l_dba08
				}
				append s_ret ":\n\n" [ format $::ngjail::l_dba09 $s_done ]
			}
				return $s_ret
		}
		"info" -
		"help" -
		default {
			return [ ::ngjail::help $player ]
		}
	}
}
##################################################
#Procedure list data
# also re-syncs QFlag 'Jailed' 
#
proc ::ngjail::jail_list { } {
	variable DEBUG
	variable handle


	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc jail_list{}:"
		puts "$s_logDEBUG $::ngjail::c_dbg01"
	}
	set ret ""
	set todaysdate [clock seconds]

	foreach name_row [ ::SQLdb::querySQLdb $handle "SELECT * FROM `ngjail` WHERE ( `jail` = 1 )" ] {
		foreach { name jaildate jailtime pos bindpos reason jail } $name_row {
			set timeleft [format "%.2f" [expr ($jaildate - $todaysdate + $jailtime)/3600.0 ]]
			append ret "\n|cFF0000FFPlayer: |cFFFF0000$name |cFF0000FFwas jailed for |cFFFFA333$reason |cFF0000FFremaining |cFFFFA333$timeleft |cFF0000FFhours \n|cFF0000FFSaved pos: |cFFFFA333$pos"
				SetQFlag $name "jailed"
		}
	}
	if { $ret == "" } {set ret "Nobody is in jail"}
	return "$ret"
}

##################################################
#Procedures jail 
#
proc ::ngjail::DoJail { player cargs } {
	variable VERSION
	variable DEBUG
	variable reason "AutoJailed"
	variable pos
	variable jailtime
	
	set mode [lindex $cargs 0]
	set sele [::GetSelection $player]
	set pos [ ::GetPos $player ]
	switch $mode {
			"for" {
				switch [llength $cargs] {
					2 {
						set jailtime [expr [lindex $cargs 1] * 3600 ] 
						set reason  "Autojailed"
						set fin [::ngjail::Jail $sele ]
						puts $fin
						return "$fin"
					}
					3 {
						set jailtime [expr [lindex $cargs 1] * 3600 ] 
						set reason  [lindex $cargs 2 ]
						set fin [::ngjail::Jail $sele ]
						return "$fin"
					}
				}
			}
			"free" {
				return [::ngjail::JailFree $sele]
			}
			"list" {
			return [ ::ngjail::jail_list ]
			}
			"reset" {
				ClearQFlag $sele "jailed"
				return "Qflag cleared"
			}
			"info" -
			"help" -
			default {
				return [ ::ngjail::jailhelp ]
			}
	}
}

proc ::ngjail::DoFree { player cargs} {
	variable VERSION
	variable DEBUG
	variable handle
	
	set pname [::GetName $player]
	set todaysdate [clock seconds]

	if { [ ::SQLdb::booleanSQLdb $handle "SELECT name FROM `ngjail` WHERE ( `name` = '$pname' AND `jail` = 1)" ] } {
	foreach name_row [ ::SQLdb::querySQLdb $handle "SELECT * FROM `ngjail` WHERE ( `name` = '$pname' AND `jail` = 1 )" ] {
		foreach { name jaildate jailtime pos bindpos reason jail } $name_row {
			set timeleft [format "%.2f" [expr ($jaildate - $todaysdate + $jailtime)/3600.0 ]]
			if { $timeleft > 0 } {
					set fin "You are not allowed to leave yet, still $timeleft hrs to go" 
				} else {
					set fin [::ngjail::JailFree $pname]
				}
			}
		}
	} else {
		set fin "You are not in jail"
	}
	return $fin
}

proc ::ngjail::Jail { player } {
	variable VERSION
	variable DEBUG
	variable handle
	variable reason
	variable pos
	variable jailtime

	set pname [::GetName $player]
	set timeleft [format "%.2f" [expr $jailtime/3600.0 ]]
	set bindpos [ ::GetBindpoint $player]

	if { [ ::SQLdb::booleanSQLdb $handle "SELECT name FROM `ngjail` WHERE (`name` = '$pname' AND 'jail' = 1)" ] } {
		return "$pname is already jailed" 
	} else {
		set jaildate [clock seconds]
		if { ! [ ::SQLdb::booleanSQLdb $handle "SELECT name FROM `ngjail` WHERE (`name` = '$pname')" ] } {
			::SQLdb::querySQLdb $handle "INSERT INTO `ngjail` (`name`, 'jaildate', 'jailtime', `pos`, `bindpos`, 'reason', 'jail' ) VALUES('$pname', '$jaildate', '$jailtime', '[ ::SQLdb::canonizeSQLdb $pos ]', '[ ::SQLdb::canonizeSQLdb $bindpos ]', '[ ::SQLdb::canonizeSQLdb $reason ]', 1 )"
		} else {
			::SQLdb::querySQLdb $handle "UPDATE `ngjail` SET 'jaildate' = '$jaildate', 'jailtime' = '$jailtime', `pos` = '[ ::SQLdb::canonizeSQLdb $pos ]', `bindpos` = '[ ::SQLdb::canonizeSQLdb $bindpos ]', 'reason' = '[ ::SQLdb::canonizeSQLdb $reason ]', jail = 1 WHERE (`name` = '$pname')"
		}
	}
	SetQFlag $player "jailed"
	SetBindpoint $player 13 0 0 0
	Teleport $player 13 0 0 0
	Say $player 0 "I am Jailed for $timeleft hrs because of $reason."
	return "$pname is now jailed for $timeleft hrs because of $reason."
}

proc ::ngjail::JailFree { player } {
	variable VERSION
	variable DEBUG
	variable handle
	set pname [::GetName $player]
	if { ! [ ::SQLdb::booleanSQLdb $handle "SELECT name FROM `ngjail` WHERE (`name` = '$pname' AND `jail` = 1)" ] } {
 		return "Selected player is not jailed" 
 	} else {
		foreach name_row [ ::SQLdb::querySQLdb $handle "SELECT * FROM `ngjail` WHERE (`name` = '$pname')" ] {
			foreach { name jaildate jailtime pos storedpos reason jail } $name_row {
			  ::SQLdb::querySQLdb $handle "UPDATE `ngjail` SET 'jail' = 0 WHERE (`name` = '$pname')"
			}
		}
		ClearQFlag $player "jailed"
		SetBindpoint $player [lindex $storedpos 0] [lindex $storedpos 1] [lindex $storedpos 2] [lindex $storedpos 3] ]
		Teleport $player [lindex $pos 0] [lindex $pos 1] [lindex $pos 2] [lindex $pos 3] ]
		Say $player 0 "I have been released from jail"
		return "$pname is now free"
	}
	return "please select someone first"
}
	


#################################################
# Initialise ngjail	
#
proc ::ngjail::init {} {
	if { [ info exists "::start-tcl::VERSION" ] } {
		set ngjail::DEBUG $::DEBUG
		set ngjail::s_logprefix $::logPrefix
	}

	variable DEBUG
	variable s_logDebug
	variable handle
	set s_logDebug "$ngjail::s_logprefix:ngjail:DEBUG:"

	if { $DEBUG } {
		set s_logDEBUG "$s_logDebug proc init{}:"
		puts "$s_logDEBUG $ngjail::c_dbg01"
	}

	::Custom::ReadConf "scripts/conf/ngjail.conf"

	if { ! [ info exists handle ] } {
		set ::SQLdb::handle [ ::SQLdb::openSQLdb ]
	}

	set handle $::SQLdb::handle

	if { $DEBUG } {
		::SQLdb::traceSQLdb $handle ::ngjail::db_trace
	}

	::ngjail::setSQLdb

	set loadinfo "Nextgen Jail System v$::ngjail::VERSION by AceIndy loaded"
	puts "[clock format [clock seconds] -format %k:%M:%S]:M:$loadinfo"
}

#Add commands to WoWEmu (and set access lvl)
::Custom::AddCommand {"jailconf" ::ngjail::db 4}
::Custom::AddCommand {"jail" ::ngjail::DoJail 4}
::Custom::AddCommand {"free" ::ngjail::DoFree 0}

::ngjail::init
