namespace eval challenge { 
proc GossipHello { npc player } { 
set side [GetSide $player] 
set Alliance1 { text 1 "Level 50  Area" } 
set Alliance2 { text 1 "Level 100 Area" } 
set Alliance3 { text 1 "Level 150 Area" } 
set Alliance4 { text 1 "Level 200 Area" } 
set Alliance5 { text 1 "Pvp Arena" } 
set Alliance6 { text 1 "Shopping Centre" }
set Alliance7 { text 1 "Alliance Home" }
set Alliance8 { text 1 "Class Trainers" }
set Alliance9 { text 1 "Portals to All Area" }
set Horde1 { text 1 "Level 50  Area" } 
set Horde2 { text 1 "Level 100 Area" } 
set Horde3 { text 1 "Level 150 Area" } 
set Horde4 { text 1 "Level 200 Area" } 
set Horde5 { text 1 "Pvp Arena" } 
set Horde6 { text 1 "Shopping Centre" }
set Horde7 { text 1 "Horde Home" }
set Horde8 { text 1 "Class Trainers" }
set Horde9 { text 1 "Portals to All Custom Area" }
if { $side == "Alliance" } { 
SendGossip $player $npc $Alliance1 $Alliance2 $Alliance3 $Alliance4 $Alliance5 $Alliance6 $Alliance7 $Alliance8 $Alliance9
} else { SendGossip $player $npc $Horde1 $Horde2 $Horde3 $Horde4 $Horde5 $Horde6 $Horde7 $Horde8 $Horde9 }} 
proc GossipSelect { npc player option } { 
set side [GetSide $player] 
switch $option { 
0 { if { $side == "Alliance" } { Teleport $player 0 -10375.000977 -420.966339 63.623833 } else { Teleport $player 1 -627.069763 -2519.464600 91.769150  }} 
1 { if { $side == "Alliance" } { Teleport $player 1 -5561.212404 -3506.160156 -56.342495 } else { Teleport $player 0 -11131.926758 -1829.380371 71.837288 }} 
2 { if { $side == "Alliance" } { Teleport $player 249 29.337132 -64.540482 -5.248760 } else { Teleport $player 230 1116.37 -458.124 -102.811 }} 
3 { if { $side == "Alliance" } { Teleport $player 47 1944.274170 1547.079102 82.389999 } else { Teleport $player 1 4789.310547 -6907.062988 96.165627 }} 
4 { if { $side == "Alliance" } { Teleport $player 0 -13227.692383 230.985336 33.228024 } else { Teleport $player 0 -13227.692383 230.985336 33.228024 }} 
5 { if { $side == "Alliance" } { Teleport $player 30 -39.809570 -291.090027 15.0758572 } else { Teleport $player 30 -39.809570 -291.090027 15.0758572 }}
6 { if { $side == "Alliance" } { Teleport $player 0 -9465.568359 63.404495 55.859825 } else { Teleport $player 1 1508.765991 -4414.758301 19.632452 }}
7 { if { $side == "Alliance" } { Teleport $player 30 -39.809570 -291.090027 15.0758572 } else { Teleport $player 30 -39.809570 -291.090027 15.0758572 }}
8 { if { $side == "Alliance" } { Teleport $player 30 -39.809570 -291.090027 15.0758572 } else { Teleport $player 30 -39.809570 -291.090027 15.0758572 }}}}  
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
