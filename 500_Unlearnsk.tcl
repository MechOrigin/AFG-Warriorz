# StartTCL: n

namespace eval Profi {
proc GossipHello { npc player } {
set Unl [GetScpValue "creatures.scp" "creature [GetEntry $npc]" "Unlearnsk"]
if { $Unl == 1 } {
set option0 { text 2 "I need to Unlearn Blacksmithing" }
set option1 { text 2 "I need to Unlearn Alchemy" }
set option2 { text 2 "I need to Unlearn Enchanting" }
set option3 { text 2 "I need to Unlearn Herbalism" }
set option4 { text 2 "I need to Unlearn Leatherworking" }
set option5 { text 2 "I need to Unlearn Mining" }
set option6 { text 2 "I need to Unlearn Skinning" }
set option7 { text 2 "I need to Unlearn Tailoring" }
set option8 { text 2 "I need to Unlearn Engineering" }
set option9 { text 0 "No Thanks. I got go. Bye" }
}
SendGossip $player $npc { npctext 190008 } \ $option0 $option1 $option2 $option3 $option4 $option5 $option6 $option7 $option8 $option9
Emote $npc 66
Emote $player 66
}

proc GossipSelect { npc player option } {
set playertarget [GetSelection $player]
switch $option {
0 {
LearnSpell $player 260000
Say $npc 0 "You unlearned the Blacksmithing skill"
SendGossipComplete $player
}
1 {
LearnSpell $player 260001
Say $npc 0 "You unlearned the Alchemy skill"
SendGossipComplete $player
}
2 {
LearnSpell $player 260002
Say $npc 0 "You unlearned the Enchanting skill"
SendGossipComplete $player
}
3 {
LearnSpell $player 260003
Say $npc 0 "You unlearned the Herbalism skill"
SendGossipComplete $player
}
4 {
LearnSpell $player 260004
Say $npc 0 "You unlearned the Leatherworking skill"
SendGossipComplete $player
}
5 {
LearnSpell $player 260005
Say $npc 0 "You unlearned the Mining skill"
SendGossipComplete $player
}
6 {
LearnSpell $player 260006
Say $npc 0 "You unlearned the Skinning skill"
SendGossipComplete $player
}
7 {
LearnSpell $player 260007
Say $npc 0 "You unlearned the Tailoring skill"
SendGossipComplete $player
}
8 {
LearnSpell $player 260008
Say $npc 0 "You unlearned the Engineering skill"
SendGossipComplete $player
}
9 {
set msg "Good bye."
SendGossipComplete $player
}
}
}

proc QuestStatus { npc player } {
set reply 7
return $reply
}
}

namespace eval Profi2 {
proc GossipHello { npc player } {
set Unl [GetScpValue "creatures.scp" "creature [GetEntry $npc]" "Unlearnsk"]
if { $Unl == 2 } {
set option0 { text 2 "I need to Unlearn First Aid" }
set option1 { text 2 "I need to Unlearn Cooking" }
set option2 { text 2 "I need to Unlearn Fishing" }
set option3 { text 0 "No Thanks. I got go. Bye" }
}
SendGossip $player $npc { npctext 190009 } \ $option0 $option1 $option2 $option3
Emote $npc 66
Emote $player 66
}

proc GossipSelect { npc player option } {
set playertarget [GetSelection $player]
switch $option {
0 {
LearnSpell $player 260009
Say $npc 0 "You unlearned First Aid"
SendGossipComplete $player
}
1 {
LearnSpell $player 260010
Say $npc 0 "You unlearned Cooking"
SendGossipComplete $player
}
2 {
LearnSpell $player 260011
Say $npc 0 "You unlearned Fishing"
SendGossipComplete $player
}
3 {
set msg "Bye."
SendGossipComplete $player
}
}
}
proc QuestStatus { npc player } {
set reply 7
return $reply
}
}

namespace eval Profi3 {
proc GossipHello { npc player } {
set Unl [GetScpValue "creatures.scp" "creature [GetEntry $npc]" "Unlearnsk"]
if { $Unl == 3 } {
set option0 { text 2 "I need to Unlearn Horse Ride" }
set option1 { text 2 "I need to Unlearn Wolf Ride" }
set option2 { text 2 "I need to Unlearn Tiger Ride" }
set option3 { text 2 "I need to Unlearn Ram Ride" }
set option4 { text 2 "I need to Unlearn Raptor Ride" }
set option5 { text 2 "I need to Unlearn Undead Horsemanship Ride" }
set option6 { text 2 "I need to Unlearn Kodo Ride" }
set option7 { text 2 "I need to Unlearn Mechanostrider Piloting" }
set option8 { text 0 "No Thanks. I got go. Bye" }
}
SendGossip $player $npc { npctext 190010 } \ $option0 $option1 $option2 $option3 $option4 $option5 $option6 $option7 $option8 
Emote $npc 66
Emote $player 66
}

proc GossipSelect { npc player option } {
set playertarget [GetSelection $player]
switch $option {
0 {
LearnSpell $player 260012
Say $npc 0 "You unlearned Horse Riding"
SendGossipComplete $player
}
1 {
LearnSpell $player 260013
Say $npc 0 "You unlearned Wolf Riding"
SendGossipComplete $player
}
2 {
LearnSpell $player 260014
Say $npc 0 "You unlearned Tiger Riding"
SendGossipComplete $player
}
3 {
LearnSpell $player 260015
Say $npc 0 "You unlearned Ram Riding"
SendGossipComplete $player
}
4 {
LearnSpell $player 260016
Say $npc 0 "You unlearned Raptor Riding"
SendGossipComplete $player
}
5 {
LearnSpell $player 260017
Say $npc 0 "You unlearned Undead Horsemanship Riding"
SendGossipComplete $player
}
6 {
LearnSpell $player 260018
Say $npc 0 "You unlearned Undead Kodo Riding"
SendGossipComplete $player
}
7 {
LearnSpell $player 260019
Say $npc 0 "You unlearned Mechanostrider Piloting"
SendGossipComplete $player
}
8 {
set msg "Bye."
SendGossipComplete $player
}
}
}
proc QuestStatus { npc player } {
set reply 7
return $reply
}
}

set loadinfo "--..UNLEARN V3 SYSTEM LOADED..--" 
puts "[clock format [clock seconds] -format %H:%M:%S]:M:$loadinfo"

