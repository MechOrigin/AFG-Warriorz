# start-tcl: n
#
############################################
#    Tame System By GriffonHeart & LCF     #
# Modified by Savage, +checks & translated #
#Please preserve the credits & do not steal#
#the work of other scripters.              #
############################################

namespace eval Tame {
proc Taming {player target spellid} {
    puts [Distance $player $target]
        if {[Distance $player $target] > 30} {
            Say $player 0 "Failed. You have to be closer to the target."
            return}
        if {[GetCreatureType $target] != 1} {
            Say $player 0 "Failed. You have to select a target first."
            return}
        if {[GetCreatureType $target] == 7} {
            Say $player 0 "Failed. You cannot tame a NPC."
            return}
        if {[GetCreatureType $target] == 8} {
            Say $player 0 "Failed. You cannot tame a critter."
            return}
        if {[GetLevel $player] < [GetLevel $target]} {
            Say $player 0 "Failed. Your target level is too high to be tamed."
            return}
        set entry [GetEntry $target]
        set elite [GetScpValue creatures.scp "creature $entry" elite]
        if {$elite != "{}"} {
            Say $player 0 "Failed. You cannot tame an elite."
            return}
        CastSpell $player $target 13481
        Say $player 0 "Success! You have tamed a beast."
}

proc Quests { player target quest_mob quest item } {
        set mob [GetEntry $target]
        if {[GetClass $player] == 3} {
        if {$mob==$quest_mob} {
            CastSpell $player $target 13481
            SendQuestComplete $player $quest
            ConsumeItem $player $item
            puts "$quest"
        } else {Say $player 0 "Failed. You have not tamed the correct beast for this taming quest!"
        }
        } else {Say $player 0 "You are not a hunter!"}
}
}
