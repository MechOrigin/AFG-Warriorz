# StartTCL: n
#
# MobSpeaking.tcl
#

namespace eval mobspeaking {
	proc npcsaywp { npc } {
		set entry [GetEntry $npc]
		set npcname [GetScpValue "creatures.scp" "creature $entry" "name"]
		set file "extra/npcsay/$npcname"
			if { ![file exists "extra/npcsay/$npcname"] } { return 0 }
		set id [open $file r]
		set buff [read $id]
		set l [split $buff \n]
		close $id
		set n [expr {int(rand()* [llength $l])}]
		set line [lindex $l $n]
			if { $line != ""} {
    		Say $npc 0 "$line"
		}
	}
}
