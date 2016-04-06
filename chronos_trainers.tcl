
namespace eval Mage_13 {
proc GossipHello { npc player } {
 set gossipText1 { text 6 "I want to browse your goods..." }
 ClearQFlag $player tmpq
 set gossipText2 { text 3 "Train me." }
 SendGossip $player $npc { npctext 29998 } $gossipText1 $gossipText2
}
proc GossipSelect { npc player option } {
 switch $option {
 0 { VendorList $player $npc }
 1 { TrainerList $player $npc }
 }
}
proc QueryQuest { npc player questid } {
 SendQuestDetails $player $npc $questid
}
proc QuestStatus { npc player } {
 set reply 0
 return $reply
}
proc QuestHello { npc player } {
 Emote $npc 66
}
}

namespace eval Rogue_14 {
proc GossipHello { npc player } {
 set gossipText1 { text 6 "I want to browse your goods..." }
 ClearQFlag $player tmpq
 set gossipText2 { text 3 "Train me." }
 SendGossip $player $npc { npctext 29998 } $gossipText1 $gossipText2
}
proc GossipSelect { npc player option } {
 switch $option {
 0 { VendorList $player $npc }
 1 { TrainerList $player $npc }
 }
}
proc QueryQuest { npc player questid } {
 SendQuestDetails $player $npc $questid
}
proc QuestStatus { npc player } {
 set reply 0
 return $reply
}
proc QuestHello { npc player } {
 Emote $npc 66
}
}

namespace eval Druid_15 {
proc GossipHello { npc player } {
 set gossipText1 { text 6 "I want to browse your goods..." }
 ClearQFlag $player tmpq
 set gossipText2 { text 3 "Train me." }
 SendGossip $player $npc { npctext 29998 } $gossipText1 $gossipText2
}
proc GossipSelect { npc player option } {
 switch $option {
 0 { VendorList $player $npc }
 1 { TrainerList $player $npc }
 }
}
proc QueryQuest { npc player questid } {
 SendQuestDetails $player $npc $questid
}
proc QuestStatus { npc player } {
 set reply 0
 return $reply
}
proc QuestHello { npc player } {
 Emote $npc 66
}
}

namespace eval Warlock_17 {
proc GossipHello { npc player } {
 set gossipText1 { text 6 "I want to browse your goods..." }
 ClearQFlag $player tmpq
 set gossipText2 { text 3 "Train me." }
 SendGossip $player $npc { npctext 29998 } $gossipText1 $gossipText2
}
proc GossipSelect { npc player option } {
 switch $option {
 0 { VendorList $player $npc }
 1 { TrainerList $player $npc }
 }
}
proc QueryQuest { npc player questid } {
 SendQuestDetails $player $npc $questid
}
proc QuestStatus { npc player } {
 set reply 0
 return $reply
}
proc QuestHello { npc player } {
 Emote $npc 66
}
}

namespace eval Priest_18 {
proc GossipHello { npc player } {
 set gossipText1 { text 6 "I want to browse your goods..." }
 ClearQFlag $player tmpq
 set gossipText2 { text 3 "Train me." }
 SendGossip $player $npc { npctext 29998 } $gossipText1 $gossipText2
}
proc GossipSelect { npc player option } {
 switch $option {
 0 { VendorList $player $npc }
 1 { TrainerList $player $npc }
 }
}
proc QueryQuest { npc player questid } {
 SendQuestDetails $player $npc $questid
}
proc QuestStatus { npc player } {
 set reply 0
 return $reply
}
proc QuestHello { npc player } {
 Emote $npc 66
}
}

namespace eval Paladin_19 {
proc GossipHello { npc player } {
 set gossipText1 { text 6 "I want to browse your goods..." }
 ClearQFlag $player tmpq
 set gossipText2 { text 3 "Train me." }
 SendGossip $player $npc { npctext 29998 } $gossipText1 $gossipText2
}
proc GossipSelect { npc player option } {
 switch $option {
 0 { VendorList $player $npc }
 1 { TrainerList $player $npc }
 }
}
proc QueryQuest { npc player questid } {
 SendQuestDetails $player $npc $questid
}
proc QuestStatus { npc player } {
 set reply 0
 return $reply
}
proc QuestHello { npc player } {
 Emote $npc 66
}
}

namespace eval Shaman_20 {
proc GossipHello { npc player } {
 set gossipText1 { text 6 "I want to browse your goods..." }
 ClearQFlag $player tmpq
 set gossipText2 { text 3 "Train me." }
 SendGossip $player $npc { npctext 29998 } $gossipText1 $gossipText2
}
proc GossipSelect { npc player option } {
 switch $option {
 0 { VendorList $player $npc }
 1 { TrainerList $player $npc }
 }
}
proc QueryQuest { npc player questid } {
 SendQuestDetails $player $npc $questid
}
proc QuestStatus { npc player } {
 set reply 0
 return $reply
}
proc QuestHello { npc player } {
 Emote $npc 66
}
}

namespace eval Blacksmith_21 {
proc GossipHello { npc player } {
 set gossipText1 { text 6 "I want to browse your goods..." }
 ClearQFlag $player tmpq
 set gossipText2 { text 3 "Train me." }
 SendGossip $player $npc { npctext 29998 } $gossipText1 $gossipText2
}
proc GossipSelect { npc player option } {
 switch $option {
 0 { VendorList $player $npc }
 1 { TrainerList $player $npc }
 }
}
proc QueryQuest { npc player questid } {
 SendQuestDetails $player $npc $questid
}
proc QuestStatus { npc player } {
 set reply 0
 return $reply
}
proc QuestHello { npc player } {
 Emote $npc 66
}
}

namespace eval Alchemy_22 {
proc GossipHello { npc player } {
 set gossipText1 { text 6 "I want to browse your goods..." }
 ClearQFlag $player tmpq
 set gossipText2 { text 3 "Train me." }
 SendGossip $player $npc { npctext 29998 } $gossipText1 $gossipText2
}
proc GossipSelect { npc player option } {
 switch $option {
 0 { VendorList $player $npc }
 1 { TrainerList $player $npc }
 }
}
proc QueryQuest { npc player questid } {
 SendQuestDetails $player $npc $questid
}
proc QuestStatus { npc player } {
 set reply 0
 return $reply
}
proc QuestHello { npc player } {
 Emote $npc 66
}
}

namespace eval Enchanting_23 {
proc GossipHello { npc player } {
 set gossipText1 { text 6 "I want to browse your goods..." }
 ClearQFlag $player tmpq
 set gossipText2 { text 3 "Train me." }
 SendGossip $player $npc { npctext 29998 } $gossipText1 $gossipText2
}
proc GossipSelect { npc player option } {
 switch $option {
 0 { VendorList $player $npc }
 1 { TrainerList $player $npc }
 }
}
proc QueryQuest { npc player questid } {
 SendQuestDetails $player $npc $questid
}
proc QuestStatus { npc player } {
 set reply 0
 return $reply
}
proc QuestHello { npc player } {
 Emote $npc 66
}
}

namespace eval Leatherworking_25 {
proc GossipHello { npc player } {
 set gossipText1 { text 6 "I want to browse your goods..." }
 ClearQFlag $player tmpq
 set gossipText2 { text 3 "Train me." }
 SendGossip $player $npc { npctext 29998 } $gossipText1 $gossipText2
}
proc GossipSelect { npc player option } {
 switch $option {
 0 { VendorList $player $npc }
 1 { TrainerList $player $npc }
 }
}
proc QueryQuest { npc player questid } {
 SendQuestDetails $player $npc $questid
}
proc QuestStatus { npc player } {
 set reply 0
 return $reply
}
proc QuestHello { npc player } {
 Emote $npc 66
}
}

namespace eval Mining_26 {
proc GossipHello { npc player } {
 set gossipText1 { text 6 "I want to browse your goods..." }
 ClearQFlag $player tmpq
 set gossipText2 { text 3 "Train me." }
 SendGossip $player $npc { npctext 29998 } $gossipText1 $gossipText2
}
proc GossipSelect { npc player option } {
 switch $option {
 0 { VendorList $player $npc }
 1 { TrainerList $player $npc }
 }
}
proc QueryQuest { npc player questid } {
 SendQuestDetails $player $npc $questid
}
proc QuestStatus { npc player } {
 set reply 0
 return $reply
}
proc QuestHello { npc player } {
 Emote $npc 66
}
}

namespace eval Tailoring_28 {
proc GossipHello { npc player } {
 set gossipText1 { text 6 "I want to browse your goods..." }
 ClearQFlag $player tmpq
 set gossipText2 { text 3 "Train me." }
 SendGossip $player $npc { npctext 29998 } $gossipText1 $gossipText2
}
proc GossipSelect { npc player option } {
 switch $option {
 0 { VendorList $player $npc }
 1 { TrainerList $player $npc }
 }
}
proc QueryQuest { npc player questid } {
 SendQuestDetails $player $npc $questid
}
proc QuestStatus { npc player } {
 set reply 0
 return $reply
}
proc QuestHello { npc player } {
 Emote $npc 66
}
}

namespace eval Cooking_32 {
proc GossipHello { npc player } {
 set gossipText1 { text 6 "I want to browse your goods..." }
 ClearQFlag $player tmpq
 set gossipText2 { text 3 "Train me." }
 SendGossip $player $npc { npctext 29998 } $gossipText1 $gossipText2
}
proc GossipSelect { npc player option } {
 switch $option {
 0 { VendorList $player $npc }
 1 { TrainerList $player $npc }
 }
}
proc QueryQuest { npc player questid } {
 SendQuestDetails $player $npc $questid
}
proc QuestStatus { npc player } {
 set reply 0
 return $reply
}
proc QuestHello { npc player } {
 Emote $npc 66
}
}

namespace eval Fishing_33 {
proc GossipHello { npc player } {
 set gossipText1 { text 6 "I want to browse your goods..." }
 ClearQFlag $player tmpq
 set gossipText2 { text 3 "Train me." }
 SendGossip $player $npc { npctext 29998 } $gossipText1 $gossipText2
}
proc GossipSelect { npc player option } {
 switch $option {
 0 { VendorList $player $npc }
 1 { TrainerList $player $npc }
 }
}
proc QueryQuest { npc player questid } {
 SendQuestDetails $player $npc $questid
}
proc QuestStatus { npc player } {
 set reply 0
 return $reply
}
proc QuestHello { npc player } {
 Emote $npc 66
}
}


