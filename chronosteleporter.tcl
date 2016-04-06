namespace eval Teleporter_chronos {
proc GossipHello { npc player } {
set side [GetSide $player]
set Alliance1 { text 1 "Onyxia's Lair" }
set Alliance2 { text 1 "Molten Core" }
set Alliance3 { text 1 "Zul'Gurub" }
set Alliance4 { text 1 "Blackwing Lair" }
set Alliance5 { text 1 "Stratholme" }
set Alliance6 { text 1 "Dire Maul" }
set Alliance7 { text 1 "Scarlet Monastery" }
set Alliance8 { text 1 "Razorfen Kraul" }
set Horde1 { text 1 "Onyxia's Lair" }
set Horde2 { text 1 "Molten Core" }
set Horde3 { text 1 "Zul'Gurub" }
set Horde4 { text 1 "Blackwing Lair" }
set Horde5 { text 1 "Stratholme" }
set Horde6 { text 1 "Chronos Battleground" }
set Horde7 { text 1 "Scarlet Monastery" }
set Horde8 { text 1 "Razorfen Kraul" }
if { $side == "Alliance" } {
SendGossip $player $npc $Alliance1 $Alliance2 $Alliance3 $Alliance4 $Alliance5 $Alliance6 $Alliance7 $Alliance8
} else { SendGossip $player $npc $Horde1 $Horde2 $Horde3 $Horde4 $Horde5 $Horde6 $Horde7 $Horde8 }}
proc GossipSelect { npc player option } {
set side [GetSide $player]
switch $option {
0 { if { $side == "Alliance" } { Teleport $player 249 29.242701 -22.181200 10.527200 } else { Teleport $player 249 29.242701 -22.181200 10.527200 }}
1 { if { $side == "Alliance" } { Teleport $player 409 1093.46 -469.41 -105.70 3.99 } else { Teleport $player 409 1093.46 -469.41 -105.70 3.99 }}
2 { if { $side == "Alliance" } { Teleport $player 309 -11916.095703 -1239.402832 92.287262 } else { Teleport $player 309 -11916.095703 -1239.402832 92.287262 }}
3 { if { $side == "Alliance" } { Teleport $player 469 -7596.16 -1056.62 408.157 } else { Teleport $player 469 -7596.16 -1056.62 408.157 }}
4 { if { $side == "Alliance" } { Teleport $player 329 3593.15 -3646.56 138.50 5.33 } else { Teleport $player 329 3593.15 -3646.56 138.50 5.33 }}
5 { if { $side == "Alliance" } { Teleport $player 429 34.35 160.70 -3.47 0.72 } else { Teleport $player 429 34.35 160.70 -3.47 0.72}}
6 { if { $side == "Alliance" } { Teleport $player 189 1688.57 1052.42 18.68 1.14 } else { Teleport $player 189 1688.57 1052.42 18.68 1.14}}
7 { if { $side == "Alliance" } { Teleport $player 1 -4467.63 -1670.51 81.8819 } else { Teleport $player 1 -4467.63 -1670.51 81.8819}}}}
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

set loadinfo "Chronos Instance Teleporter Loaded"
puts "[clock format [clock seconds] -format %H:%M:%S]:M:$loadinfo"