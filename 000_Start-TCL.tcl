# StartTCL: 000
#
# Start-TCL.tcl
#

#
# Unknown variables
#
load ini.dll
array set userpos {}


### RestState Config ###
# time in seconds for full rest 30 (bubbles maximum)
set resttimefull 3600

# max distance in rest zone
set restdistoff 200

# if player level changed reset time resting and set Normal state (0 - off, 1 - on)
set restlvlreset 1

# check player side in rest zone (0 - off, 1 - on)
set restsidecheck 1