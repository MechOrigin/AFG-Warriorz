# StartTCL: n
#
# ====================================
#
# Channeling script v1.0 by seatlleson
#
# ====================================
#
# Modified by Delfin
#
# Start-TCL 0.9.2 compatible
#
#


namespace eval ::Channeling { 

	proc ::Channeling::Start { to from spell ticks } {
		global channelingarray
		global channelingtime
		global channelingpos
		global channelingtarget
		global channelingticks
		
		set channelingtime($from) [ clock seconds ]
		set channelingarray($from) $spell
		set channelingpos($from) [ ::GetPos $from ]
		set channelingtarget($from) $to
		set channelingticks($from) $ticks
	}

	proc ::Channeling::Maintain { to from spell } {
		global channelingarray
		global channelingtime
		global channelingpos
		global channelingtarget
	
		set channelingtime($from) [ expr { [ clock seconds ] + 1 } ]
		set channelingarray($from) $spell
		set channelingpos($from) [ ::GetPos $from ]
		set channelingtarget($from) $to
	
	}

	proc ::Channeling::StartAndMaintain { to from spell ticks } {
		global channelingarray
		global channelingtime
		global channelingpos
		global channelingtarget
		global channelingticks
	
		set channelingtime($from) [ expr { [ clock seconds ] + 1 } ]
		set channelingarray($from) $spell
		set channelingpos($from) [ ::GetPos $from ]
		set channelingtarget($from) $to
		if { [ info exists channelingticks ($from) ] == 0 } {
			set channelingticks($from) [ expr {$ticks-1} ]
		} 
	}

	proc ::Channeling::StartAndMaintainA { to from spell ticks } {
		global channelingarrayA
		global channelingtimeA
		global channelingposA
		global channelingticksA
	
		set channelingtimeA($from) [ expr { [ clock seconds ] + 1 } ]
		set channelingarrayA($from) $spell
		set channelingposA($from) [ ::GetPos $from ]
		if { [ info exists channelingticksA($from) ] == 0 } {
			set channelingticksA($from) [ expr {$ticks-1} ]
		} 
	}
}

trace add execution ::GetQFlag leave "::WoWEmu::channelinghandler"
trace add execution ::GetQFlag leave "::WoWEmu::channelinghandlerA"

