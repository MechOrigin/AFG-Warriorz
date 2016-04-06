# Start-TCL: n
#

namespace eval WantedPosterHogger {
	proc QueryQuest { obj player questlistid } {
		if { $questlistid == 93 } {
		if {[GetQFlag $player Q176] == 0} {
		if { [GetQuestStatus $player 176] == 1 } {
			SendQuestReward $player $obj 176 } else {
			SendQuestDetails $player $obj 176 }
			}
		}
	}
	
	proc QuestAccept { obj player questid } { }
	
	proc QuestChooseReward { obj player questid choose } { SetQFlag $player "Q$questid" } }


namespace eval WantedHogger {
	proc QueryQuest { obj player questlistid } {
		if { $questlistid == 93 } {
		if {[GetQFlag $player Q176] == 0} {
			if { [GetQuestStatus $player 176] == 1 } {
				SendQuestReward $player $obj 176
			} else {
				SendQuestDetails $player $obj 176
				}
			}
		}
	}

	proc QuestAccept { obj player questid } { }

	proc QuestChooseReward { obj player questid choose } {SetQFlag $player "Q$questid"}}

namespace eval TwilightTome {
	proc QueryQuest { obj player questlistid } {
		if { $questlistid == 549 } {
		if {[GetQFlag $player Q949] == 0} {
		if { ([GetQuestStatus $player 949] == 3)&&([GetLevel $player] >=15) } {
			SendQuestReward $player $obj 949
			}
		}
		if {[GetQFlag $player Q949] == 1} {
			if { ([GetQuestStatus $player 950] == 4)&&([GetLevel $player] >=15) } {
				SendQuestDetails $player $obj 950
				}
			}
		}
	}

	proc QuestAccept { obj player questid } { }

	proc QuestChooseReward { obj player questid choose } {
		SetQFlag $player "Q$questid"
		SendQuestDetails $player $obj 950
	}
}

namespace eval TheThreshwackonator4100 {
	proc GossipHello { npc player } {
		set pLvl [GetLevel $player]
		set qs2078 0
		SendSwitchGossip $player $npc 1
		if {([GetQuestStatus $player 2078] == 3) && ($pLvl >= 18) } {
			set qs2078 { text 1 "First Slot." }
		}
		SendGossip $player $npc $qs2078 {npctext 758}
	}

	proc GossipSelect { npc player option } {
		SendGossipComplete $player
	}

	proc QueryQuest { npc player questid } {
		SendQuestComplete $player 2078
	}
}

namespace eval PoorOldBlanchy {
	proc OnOpen { obj player lootid } {
		if {[GetQFlag $player Q151] == 0} {
		if { [GetQuestStatus $player 151] == 3 } {
			return 1
	} else {
		return 0
		}
	} else {
		return 0
		}
	}
}

namespace eval MillyHarvest {
	proc OnOpen { obj player lootid } {
		if {[GetQFlag $player Q3904] == 0} {
		if { [GetQuestStatus $player 3904] == 3 } {
			return 1
		} else {
			return 0
			}
		} else {
			return 0
		}
	}
}

namespace eval DeadFields {
	proc AreaTrigger { player trigger_number } {
		if {([GetQuestStatus $player 437] == 3) && ([GetQFlag $player "Q437"] == 0)} {
		SendQuestComplete $player 437 }
	}
}

namespace eval FrostmaneHold1 {
	proc AreaTrigger { player trigger_number } {
		SetQFlag $player t97
		if {([GetQFlag $player t97] == 1) && ([GetQFlag $player t168] == 1) && ([GetQFlag $player t169] == 1) && ([GetQFlag $player oneTimePass] == 0)} {
		SendQuestComplete $player 287
		ClearQFlag $player t97
		ClearQFlag $player t168
		ClearQFlag $player t169
		SetQFlag $player oneTimePass 
		} 
	}
}

namespace eval FrostmaneHold2 {
	proc AreaTrigger { player trigger_number } {
		SetQFlag $player t168
		if {([GetQFlag $player t97] == 1) && ([GetQFlag $player t168] == 1) && ([GetQFlag $player t169] == 1) && ([GetQFlag $player oneTimePass] == 0)} {
		SendQuestComplete $player 287
		ClearQFlag $player t97
		ClearQFlag $player t168
		ClearQFlag $player t169
		SetQFlag $player oneTimePass 
		}
	} 
}
 
namespace eval FrostmaneHold3 {
	proc AreaTrigger { player trigger_number } {
		SetQFlag $player t169
		if {([GetQFlag $player t97] == 1) && ([GetQFlag $player t168] == 1) && ([GetQFlag $player t169] == 1) && ([GetQFlag $player oneTimePass] == 0) } {
		SendQuestComplete $player 287
		ClearQFlag $player t97
		ClearQFlag $player t168
		ClearQFlag $player t169
		SetQFlag $player oneTimePass 
		}
	}
}

namespace eval Vilereef {
	proc AreaTrigger { player trigger_number } {
		SendQuestComplete $player 578 
	}
}
