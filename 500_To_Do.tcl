# start-tcl: n
#

namespace eval RoguesSell {
proc GossipHello { npc player } {
set playerClass [GetClass $player]
if { $playerClass == 4 } {
set gossipText1 { text 6 "I want to browse your goods..." }
} else {
Say $npc 0 "I am only Sell to Rogues!"
Emote $npc 5
return}
SendGossip $player $npc { npctext 33391 } $gossipText1
}
proc GossipSelect { npc player option } {
switch $option {
0 { VendorList $player $npc }
}
}
proc QueryQuest { npc player questid } { }
proc QuestStatus { npc player } {
set reply 0
return $reply}
proc QuestHello { npc player } {
Emote $npc 66}
}
