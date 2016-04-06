namespace eval afgteleporter { 
proc GossipHello { npc player } { 
set side [GetSide $player] 
set Alliance1 { text 1 "Level 50-99  Area" } 
set Alliance2 { text 1 "Level 100-149 Area" } 
set Alliance3 { text 1 "Level 150-199 Area" } 
set Alliance4 { text 1 "Level 200+ Ah'Qirraj Area" } 
set Alliance5 { text 1 "Pvp Arena" } 
set Alliance6 { text 1 "Shopping Centre" }
set Alliance7 { text 1 "Alliance Home" }
set Alliance8 { text 1 "High Level Class Trainers" }
set Alliance9 { text 1 "Fun Quests Zone + Portals to All Area" }
set Alliance10 { text 1 "Hyjal All in One Map Level 1  -  255+" }
set Alliance11 { text 1 "Level 255 Lost City of Giants Outland" }
set Alliance12 { text 1 "Chronos Battleground" }
set Alliance13 { text 1 "Holy Shopping Center" }
set Horde1 { text 1 "Level 50-99  Area" } 
set Horde2 { text 1 "Level 100-149 Area" } 
set Horde3 { text 1 "Level 150-199 Area" } 
set Horde4 { text 1 "Level 200+ Ah'Qirraj Area" } 
set Horde5 { text 1 "Pvp Arena" } 
set Horde6 { text 1 "Shopping Centre" }
set Horde7 { text 1 "Horde Home" }
set Horde8 { text 1 "High Level Class Trainers" }
set Horde9 { text 1 "Fun Quests Zone + Portals to All Area" }
set Horde10 { text 1 "All in One Map Level 1  -  255+" }
set Horde11 { text 1 "Level 255 Lost City of Giants Outland" }
set Horde12 { text 1 "Chronos Battleground" }
set Horde13 { text 1 "Holy Shopping Center" }
if { $side == "Alliance" } { 
SendGossip $player $npc $Alliance1 $Alliance2 $Alliance3 $Alliance4 $Alliance5 $Alliance6 $Alliance7 $Alliance8 $Alliance9 $Alliance10 $Alliance11 $Alliance12 $Alliance13
} else { SendGossip $player $npc $Horde1 $Horde2 $Horde3 $Horde4 $Horde5 $Horde6 $Horde7 $Horde8 $Horde9 $Horde10 $Horde11 $Horde12 $Horde13 }} 
proc GossipSelect { npc player option } { 
set side [GetSide $player] 
switch $option { 
0 { if { $side == "Alliance" } { Teleport $player 0 -10375.000977 -420.966339 63.623833 } else { Teleport $player 1 -627.069763 -2519.464600 91.769150  }} 
1 { if { $side == "Alliance" } { Teleport $player 1 -5561.212404 -3506.160156 -56.342495 } else { Teleport $player 0 -11131.926758 -1829.380371 71.837288 }} 
2 { if { $side == "Alliance" } { Teleport $player 249 29.337132 -64.540482 -5.248760 } else { Teleport $player 230 1116.37 -458.124 -102.811 }} 
3 { if { $side == "Alliance" } { Teleport $player 509 -8452.962891 1534.351929 31.908718 } else { Teleport $player 509 -8452.962891 1534.351929 31.908718 }} 
4 { if { $side == "Alliance" } { Teleport $player 0 -13227.692383 230.985336 33.228024 } else { Teleport $player 0 -13227.692383 230.985336 33.228024 }} 
5 { if { $side == "Alliance" } { Teleport $player 30 20.236010 -299.914551 14.033436 } else { Teleport $player 30 20.236010 -299.914551 14.033436 }}
6 { if { $side == "Alliance" } { Teleport $player 0 -9465.568359 63.404495 55.859825 } else { Teleport $player 1 1508.765991 -4414.758301 19.632452 }}
7 { if { $side == "Alliance" } { Teleport $player 30 353.021484 -301.219360 -42.987320 } else { Teleport $player 30 353.021484 -301.219360 -42.987320 }}
8 { if { $side == "Alliance" } { Teleport $player 30 -239.810837 -258.487823 4.859903 } else { Teleport $player 30 -239.810837 -258.487823 4.859903 }}
9 { if { $side == "Alliance" } { Teleport $player 1 4631.812012 -3828.89346 943.290405 } else { Teleport $player 1 4631.812012 -3828.89346 943.290405 }}
10 { if { $side == "Alliance" } { Teleport $player 0 -14958.5 12761.6 36.038 } else { Teleport $player 0 -14958.5 12761.6 36.038 }} 
11 { if { $side == "Alliance" } { Teleport $player 529 1295.180298 1291.109375 -12.680262 } else { Teleport $player 529 1295.180298 1291.109375 -12.680262 }}
12 { if { $side == "Alliance" } { Teleport $player 0 -8513.49 861.197 111.039 } else { Teleport $player 0 -8513.49 861.197 111.039 }}}}
proc GetSide { player } { 
set race [GetRace $player] 
switch $race { 
1 {return "Alliance"} 
3 {return "Alliance"} 
4 {return "Alliance"} 
7 {return "Alliance"} 
2 {return "Horde"} 
5 {return "Horde"} 
6 {return "Horde"} 
8 {return "Horde"}}} 
}


namespace eval afghonor { 
proc GossipHello { npc player } { 
set side [GetSide $player] 
set Alliance1 { text 1 "Horde Honor Area" } 
set Alliance2 { text 1 "Alliance Honor Area" } 
if { $side == "Alliance" } { 
SendGossip $player $npc $Alliance1 $Alliance2 
} else { SendGossip $player $npc $Horde1 $Horde2 }} 
proc GossipSelect { npc player option } { 
set side [GetSide $player] 
switch $option { 
0 { if { $side == "Alliance" } { Teleport $player 349 432.748627 18.501265 -132.348404 } else { Teleport $player 349 432.748627 18.501265 -132.348404  }} 
1 { if { $side == "Alliance" } { Teleport $player 429 42.204239 155.146362 -3.472723 } else { Teleport $player 429 42.204239 155.146362 -3.472723 }}}}
proc GetSide { player } { 
set race [GetRace $player] 
switch $race { 
1 {return "Alliance"} 
3 {return "Alliance"} 
4 {return "Alliance"} 
7 {return "Alliance"} 
2 {return "Horde"} 
5 {return "Horde"} 
6 {return "Horde"} 
8 {return "Horde"}}} 
}

::Custom::AddCommand {
	"area" ::WoWEmu::Commands::area 2
	"area2" ::WoWEmu::Commands::area 2
}

proc area { player cargs } {
if { [GetPlevel $player] <2 } { return "You are not allowed to use this command" }
set option [lindex $cargs 0]
if { $option == "" } {
set msg "\nAFGWarrioz Custom Area: \nTo ENTER Mix Area Level 1-250 type .area mix \nTo ENTER Level 50 Area type .area 50 \nTo ENTER Level 100 Area type .area 100 \nTo ENTER Level 150 Area type .area 150 \nTo ENTER Level 200 Area type .area 200 \nTo Return to Last Heartstone Saved Location type .area home \nFor information type .area info"
} else {
switch $option {
"mix" { Teleport $player 1 4631.812012 -3828.89346 943.290405 }
"50" { Teleport $player 0 -10375.000977 -420.966339 63.623833 }
"100" { Teleport $player 1 -5561.212404 -3506.160156 -56.342495 }
"150" { Teleport $player 249 29.337132 -64.540482 -5.248760 }
"200" { Teleport $player 509 -8452.962891 1534.351929 31.908718 }
"home" { Custom::TeleportPos $player [GetBindpoint $player] }
"info" { set msg "Help: \nThis is  Afghan Warrioz Fun Repack. Hope you Enjoy your stay :) \nFor Other Areas type .area2 \nSometimes commands doesnt work, either wait a bit or relogin \nDont KS, Dont use Hack, if you get caught you will be banned without warning. \nRepack Home site http://afgwarriorz.ath.cx" }
}
}
}
proc area2 { player cargs } {
if { [GetPlevel $player] <2 } { return "You are not allowed to use this command" }
set option [lindex $cargs 0]
if { $option == "" } {
set msg "\nAFGWarrioz Custom Area: \nTo ENTER Shopping Centre Area type .area2 shop \nTo ENTER Training Area type .area2 train \nTo ENTER PVP Arena type .area2 pvp \nTo ENTER Giant Area lvl 250+ type .area2 giant \nFor information type .area2 info"
} else {
switch $option {
"shop" { Teleport $player 30 -39.809570 -291.090027 15.0758572 }
"train" { Teleport $player 30 353.021484 -301.219360 -42.987320 }
"pvp" { Teleport $player 0 -13152.900391 342.729004 52.132801 }
"giant" { Teleport $player 0 -14958.5 12761.6 36.038 }
"info" { set msg "Help: \nThis is  Afghan Warrioz Fun Repack. Hope you Enjoy your stay :) \nFor Other Areas type .area  \nSometime commands doesnt work just wait abit or relogin \nDont KS, Dont use Hack, if you get caught you will be banned without warning \nRepack Home site http://afgwarriorz.ath.cx" }
}
}
}


set loadinfo "AFG Custom Area Teleporting system loaded" 
puts "[clock format [clock seconds] -format %H:%M:%S]:M:$loadinfo"