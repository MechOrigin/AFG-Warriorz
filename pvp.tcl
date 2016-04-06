namespace eval AllyPvPStone1 {
proc QueryQuest { npc player questid } {
Teleport $player 0 -13227.692383 230.985336 33.228024 #Ally_PvP_Area_Side
}
}

namespace eval HordePvPStone1 {
proc QueryQuest { npc player questid } {
Teleport $player 0 -14958.5 12761.6 36.0388 #Horde_PvP_Area_Side
}
}

namespace eval AllyPvPStone {
proc QueryQuest { npc player questid } {
Teleport $player 0 -13227.692383 230.985336 33.228024 #Ally_PvP_Area_Side
}
}

namespace eval HordePvPStone {
proc QueryQuest { npc player questid } {
Teleport $player 0 -13227.692383 230.985336 33.228024 #Horde_PvP_Area_Side
}
}
