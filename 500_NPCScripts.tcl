# Start-TCL: n
#

#
# NPC's scripts
#

namespace eval CaptainNoteo {
	proc GossipHello { npc player } {
		SendGossip $player $npc { text 0 "Teleport me" }\
	}

	proc GossipSelect { npc player option } {
		switch $option {
			0 { Teleport $player 0 -3734 -593 7 } }
		SendGossipComplete $player
	}
	
	proc QueryQuest { npc player questid } { }
	
	proc QuestStatus { npc player } { return 1 }
	
	proc QuestHello { npc player } { }
	
	proc QuestSelect { npc player questid } { }
	
	proc QuestAccept { npc player questid } { }
	
	proc QuestChooseReward { npc player questid choose } { }
}


#
#Script - DeathGuard Randolph
#

namespace eval DeathguardRandolph { }
	proc DeathguardRandolph::GossipHello { npc player } {
		SendGossipComplete $player
		SendSwitchGossip $player $npc 1 }
	
	proc DeathguardRandolph::GossipSelect { npc player option } {
		if {( $option==9 )} {
			SendGossip $player $npc\
			{ text 0 "Greetings" } 
		}
		if {( $option==1 )} {
			SendGossip $player $npc\
			{ text 0 "Sorry this village has no bank." } 
		}
		if {( $option==2 )} {
			SendGossip $player $npc\
			{ text 0 "The trainers can all be found in the building Next to the GraveYard." } 
		}
		if {( $option==3 )} {
			SendGossip $player $npc\
			{ text 0 "Sorry this Village has no profession trainers." } 
		}
		if {( $option==4 )} {
			SendGossip $player $npc\
			{ text 0 "Sorry This village has no inn." } 
		}
		if {( $option==5 )} {
			SendGossip $player $npc\
			{ text 0 "Suppliers can found in the buildings oposite the graveyard" } 
		}
		if {( $option==6 )} {
			SendGossip $player $npc\
			{ text 0 "Merchants can be found in the buildings oposite the graveyard" } 
		}
		if {( $option==7 )} {
			SendGossip $player $npc\
			{ text 0 "Sorry this village has no Stable Master." } 
		}
		if {( $option==8 )} {
			SendGossip $player $npc\
			{ text 0 "Sorry this village has no Gryphon Master." } 
		} 
	}

	proc DeathguardRandolph::QueryQuest { npc player questid } { }

	proc DeathguardRandolph::QuestStatus { npc player } {
		set reply 4
	return $reply
	}

	proc DeathguardRandolph::QuestHello { npc player } {
		set PlayerMessage { text 0 "Hi there, how may I help you today?" }
		set PlayerMessage1 { text 1 "Bank" }
		set PlayerMessage2 { text 2 "Spell Trainers" }
		set PlayerMessage3 { text 3 "Profession Trainers" }
		set PlayerMessage4 { text 4 "Inn" }
		set PlayerMessage5 { text 5 "General Suppliers" }
		set PlayerMessage6 { text 6 "Merchants" }
		set PlayerMessage7 { text 7 "Stable Master" }
		set PlayerMessage8 { text 8 "Gryphon Master" }
		SendGossip $player $npc $PlayerMessage $PlayerMessage1 $PlayerMessage2 $PlayerMessage3 $PlayerMessage4 $PlayerMessage5 $PlayerMessage6 $PlayerMessage7 $PlayerMessage8 
	}

	proc DeathguardRandolph::QuestSelect { npc player questid } { }
	
	proc DeathguardRandolph::QuestAccept { npc player questid } { }
	
	proc DeathguardRandolph::QuestChooseReward { npc player questid choose } { }

 #
 #Script - DeathGuard Bartrand
 #

namespace eval DeathguardBartrand { }
	proc DeathguardBartrand::GossipHello { npc player } {
		SendGossipComplete $player
		SendSwitchGossip $player $npc 1 }
	
	proc DeathguardBartrand::GossipSelect { npc player option } {
		if {( $option==9 )} {
			SendGossip $player $npc\
			{ text 0 "Greetings" } 
		}
		if {( $option==1 )} {
			SendGossip $player $npc\
			{ text 0 "Sorry this village has no bank." } 
		}
		if {( $option==2 )} {
			SendGossip $player $npc\
			{ text 0 "The trainers can all be found in the building Next to the GraveYard." } 
		}
		if {( $option==3 )} {
			SendGossip $player $npc\
			{ text 0 "Sorry this Village has no profession trainers." } 
		}
		if {( $option==4 )} {
			SendGossip $player $npc\
			{ text 0 "Sorry This village has no inn." } 
		}
		if {( $option==5 )} {
			SendGossip $player $npc\
			{ text 0 "Suppliers can found in the buildings oposite the graveyard" } 
		}
		if {( $option==6 )} {
			SendGossip $player $npc\
			{ text 0 "merhants can be found in the buildings oposite the graveyard" } 
		}
		if {( $option==7 )} {
			SendGossip $player $npc\
			{ text 0 "Sorry this village has no Stable Master." } 
		}
		if {( $option==8 )} {
			SendGossip $player $npc\
			{ text 0 "Sorry this village has no Gryphon Master." } 
		}
	}
	
	proc DeathguardBartrand::QueryQuest { npc player questid } { }

	proc DeathguardBartrand::QuestStatus { npc player } {
		set reply 4
	return $reply 
	}

	proc DeathguardBartrand::QuestHello { npc player } {
		set PlayerMessage { text 0 "Hi there, how may I help you today?" }
		set PlayerMessage1 { text 1 "Bank" }
		set PlayerMessage2 { text 2 "Spell Trainers" }
		set PlayerMessage3 { text 3 "Profession Trainers" }
		set PlayerMessage4 { text 4 "Inn" }
		set PlayerMessage5 { text 5 "General Suppliers" }
		set PlayerMessage6 { text 6 "Merchants" }
		set PlayerMessage7 { text 7 "Stable Master" }
		set PlayerMessage8 { text 8 "Gryphon Master" }
		SendGossip $player $npc $PlayerMessage $PlayerMessage1 $PlayerMessage2 $PlayerMessage3 $PlayerMessage4 $PlayerMessage5 $PlayerMessage6 $PlayerMessage7 $PlayerMessage8 
	}

	proc DeathguardBartrand::QuestSelect { npc player questid } { }
	
	proc DeathguardBartrand::QuestAccept { npc player questid } { }
	
	proc DeathguardBartrand::QuestChooseReward { npc player questid choose } { }

#
#Script - DeathGuard Abraham
#

namespace eval DeathguardAbraham { }
	proc DeathguardAbraham::GossipHello { npc player } {
		SendGossipComplete $player
		SendSwitchGossip $player $npc 1 
	}
	
	proc DeathguardAbraham::GossipSelect { npc player option } {
		if {( $option==0 )} {
			SendGossip $player $npc\
			{ text 0 "Brill is not far ahead, it is full of trainers and merchants, a stable master can be found there as well." } 
		} 
	}

	proc DeathguardAbraham::QueryQuest { npc player questid } { }
	
	proc DeathguardAbraham::QuestStatus { npc player } {
			set reply 4
		return $reply 
	}

	proc DeathguardAbraham::QuestHello { npc player } {
		SendGossip $player $npc { text 0 "Brill" } 
	}

	proc DeathguardAbraham::QuestSelect { npc player questid } { }
	
	proc DeathguardAbraham::QuestAccept { npc player questid } { }
	
	proc DeathguardAbraham::QuestChooseReward { npc player questid choose } { }

#
#Script - Ancient Of Lore
#

namespace eval AncientofLore { }
	proc AncientofLore::GossipHello { npc player } {
		SendGossipComplete $player
		SendSwitchGossip $player $npc 0
	}

	proc AncientofLore::GossipSelect { npc player option } { }

	proc AncientofLore::QueryQuest { npc player questid } { }

	proc AncientofLore::QuestStatus { npc player } {
		set reply 0
		if {([GetQuestStatus $player 952] == 3)} {
			return 5
		}
		return $reply
	}

	proc AncientofLore::QuestHello { npc player } {
		if {[GetQuestStatus $player 952] == 3} {
			SendGossip $player $npc { quest 952 "Grove of the Ancients." }
			return
			}
		set questCount 0
		set newQuest 0
		set gossipQuest 0
		set compliteQuest 0
		if {$questCount > 1} {
			SendQuestsList $player $npc
		} elseif { $newQuest != 0} {
			SendQuestDetails $player $npc $newQuest
		} elseif { $gossipQuest != 0} {
			SendGossip $player $npc $gossipQuest
		} elseif { $compliteQuest != 0} {
			SendQuestReward $player $npc $compliteQuest
		}
	}

	proc AncientofLore::QuestSelect { npc player questid } {
		if {([GetQuestStatus $player $questid] == 1) || (([GetQuestStatus $player $questid] == 3) && ($questid == 952))} {
			SendQuestReward $player $npc $questid
		} else {
			SendQuestDetails $player $npc $questid
		}
	}

	proc AncientofLore::QuestAccept { npc player questid } { }

	proc AncientofLore::QuestChooseReward { npc player questid choose } {
		SetQFlag $player "Q$questid"
	}




