# Start-TCL: n
#

#
# A Better broadcast by Rama v1.0 #
#

namespace eval broadcastcmd {
 ::Custom::AddCommand "b" "::broadcastcmd::broad"
proc broad { player cargs } {
if { [GetPlevel $player] <4 } { return "You cant use this Command!" }
set cargs [ split $cargs ]
switch [ lindex $cargs 0 ] {
"save" {
 	set fcargs [expr [ lindex $cargs 1 ]]
 	if { $fcargs > "0" && $fcargs < "500" } {
set file [open "extra/broadcast/($fcargs).txt" w+]
set text "[ lrange $cargs 2 end ]"
puts $file $text
close $file
return "|cFFFFA333Message Saved!"
	} else {
		return "This number is too Large!" }
}
"use" {
	set fcargs [ lindex $cargs 1 ]
 	if { $fcargs > "0" || $fcargs < "500" } {
 		if {[file exists "extra/broadcast/($fcargs).txt"]} {
set file [open "extra/broadcast/($fcargs).txt"]
set name [GetName $player]
set data [read $file]
return ".broadcast $data |cFFFFA333($name)"
close $file
} else { return "|cFFFFA333This Message don't exist" }
}
}
"list" {
	set fcargs [ lindex $cargs 1 ]
 	if { $fcargs > "0" || $fcargs < "500" } {
 		if {[file exists "extra/broadcast/($fcargs).txt"]} {
set file [open "extra/broadcast/($fcargs).txt" r+]
set data [read $file]
close $file
return "|cFFF0002FMESSAGE: |cFFFFA333$data"
} else { return "|cFFFFA333This Message don't exist" }
}
}
"listauto" {
	if {[file exists "extra/broadcast/autobroadcast.txt"]} {
set file "extra/broadcast/autobroadcast.txt"
set rfile [open $file r+]
set data [read $rfile]
close $rfile
return "|cFFF0002FMESSAGE: |cFFFFA333$data"
} else { return "|cFFFFA333You havent set any Automessage" }
}
"auto" {
set file [open "extra/broadcast/autobroadcast.txt" w+]
set text "[ lrange $cargs 1 end ]"
puts $file $text
close $file
return "|cFFFFA333Auto Broadcast Created!"
}
}
set name [GetName $player]
return ".broadcast $cargs |cFFFFA333($name)"
}
}
