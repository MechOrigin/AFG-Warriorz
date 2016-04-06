# Start-TCL: 998 
#
# This will update the PHP map.
#
namespace eval GPS {
	proc mapupdate {player args} {
		global mapuserpos
		set joueur [GetName $player]
		set mapxyz [GetPos $player]
		if { [info exists mapuserpos(0)]!=1 } { set mapuserpos(0) [clock seconds]}
		set check [expr [clock seconds]-86400]
		if { $mapuserpos(0) < $check} { 
		unset mapuserpos 
		return
		}
		set mapuserpos($joueur) "| $joueur $mapxyz"
		if { $mapuserpos(0) < [expr $check+86340]} { 
			set mapfh [open "PHPServer/playerxyz.save" w+]
			foreach bouda [array get mapuserpos] {
			 puts $mapfh "|[lindex $bouda 1]|[lindex $bouda 2] [lindex $bouda 3] [lindex $bouda 4] [lindex $bouda 5]"
			}
			close $mapfh
		}
	}
}

::Custom::AddCommand "mapupdate" "::GPS::mapupdate"