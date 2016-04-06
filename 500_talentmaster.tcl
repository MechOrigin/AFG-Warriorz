# StartTCL: 
# This Files is Scripts by someone else by Remodified By Khanbaba to make
# It compatible with the new tcl 1.9.2 system....
# Contact Site: http://uw-crew.com http://afgwarriorz.ath.cx khanbaba site
# Talent Resetting Master

::Custom::AddCommand {
	"remtalentonload" ::WoWEmu::Commands::setcp 
}

proc remtalentonload { player cargs } {
return ".remtalentonload $player $cargs" }

#	Talent Master
#	NPC Command

namespace eval talent_reset {
proc GossipHello { npc player } {
SendGossip $player $npc { text 4 "Please help me refocuse my talents!" }
}

proc GossipSelect { npc player option } {
set plevel [GetLevel $player]
if {$plevel < 10 } {
Say $npc 0 "You are too low level for me"
} else {
SendGossipComplete $player
set money -100000
set spellid 14867
set playertarget [GetSelection $player]

if { [ChangeMoney $player $money] == 1 } {
LearnSpell $player $spellid
Say $npc 0 "You have successfully reset your talent points"
Emote $npc 2
} else {
Say $npc 0 "You must pay 10 gold"
Emote $npc 274
}
SendSwitchGossip $player $npc 1
}
proc QuestStatus { npc player } {
return 1
}
}
}
