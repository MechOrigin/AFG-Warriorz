# Start-TCL: n
#

#
# Race System v0.1.1 by Snake
#

namespace eval RaceVendor {
	proc GossipHello { npc player } {
		set started [Race::GetStarted]
		if { $started != "Yes" } {
			set name [GetName $player]
			set file "extra/Race_Stuff/$name.ini"
		if { [file exists $file] } { 
			Say $npc 0 "You have already bet, you are allowed to make one bet per race" 
		} else {
			SendGossip $player $npc { text 0 "100 Gold" }\
			SendGossip $player $npc { text 0 "10 Gold" }\
			SendGossip $player $npc { text 0 "1 Gold" }\
			SendGossip $player $npc { text 0 "10 Silver" }\
			SendGossip $player $npc { text 0 "1 Silver" }\
			SendGossip $player $npc { text 0 "10 Copper" }\
			SendGossip $player $npc { text 0 "1 Copper" }\
			} 
		} else {
			Say $npc 0 "The race has started, you can't bet" 
		}
	}

	proc GossipSelect { npc player option } {
		set money [Race::GetMoneyOption $option]
			switch $option {
				0 { set resultado [Race::Proceso $player $money]
					Say $npc 0 "$resultado"
					SendGossipComplete $player }
				1 { set resultado [Race::Proceso $player $money]
					Say $npc 0 "$resultado"
					SendGossipComplete $player}
				2 { set resultado [Race::Proceso $player $money]
					Say $npc 0 "$resultado"
					SendGossipComplete $player}
				3 { set resultado [Race::Proceso $player $money]
					Say $npc 0 "$resultado"
					SendGossipComplete $player}
				4 { set resultado [Race::Proceso $player $money]
					Say $npc 0 "$resultado"
					SendGossipComplete $player}
				5 { set resultado [Race::Proceso $player $money]
					Say $npc 0 "$resultado"
					SendGossipComplete $player}
				6 { set resultado [Race::Proceso $player $money]
					Say $npc 0 "$resultado"
					SendGossipComplete $player}
				}
		Race::WayPoint_Start npc
	}
}

namespace eval RaceReward {
	proc GossipHello { npc player } {
		set started [Race::GetStarted]
		if { $started == "No" } {
			set name [GetName $player]
		if { [file exists "extra/Race_Stuff/$name.ini"] } { 
			SendGossip $player $npc { text 0 "Give me the results!" } 
			} else {
				Say $npc 0 "You didn't bet on this race" }
			} else { 
				Say $npc 0 "The race hasn't finished yet" }
	}
	
	proc GossipSelect { npc player option } {
		switch $option {
			0 { set winner [Race::GetWinner]
				set name [GetName $player]
				set file "extra/Race_Stuff/$name.ini"
				set side [Race::InfoforIni $player]
				set money [Race::GetMoney $player]
				set moneyx [expr ($money*2)]
				set r [Race::GetRaceNumber]
				set rn [ expr ($r+1) ]
				set rf [ expr ($r-1) ]
				set frf [GetQFlag $player "Race$rn"]
				set frn [GetQFlag $player "Race$r"]
				set g [GetQFlag $player "Game"]
				if { $r == 0 } { 
					Say $npc 0 "The race hasn't started yet" } else {
				if { $g == 1 } { 
					Say $npc 0 "The race hasn't started yet" } else {
				if { $frn == 1 } {
				if { $winner == $side } {
					file delete $file
					ChangeMoney $player +$moneyx
					ClearQFlag $player "Race$r"
						Say $npc 0 "Congratulations, you won!"
					} else { 
						file delete $file
					ClearQFlag $player "Race$r"
						Say $npc 0 "You lost!" }
					} else {
						if {$frf == 1} {
							Say $npc 0 "The race hasn't started yet"
					} else {
						file delete $file
						Say $npc 0 "Your bet if from an old race, you bet will be deleted"
						ClearQFlag $player "Race$rn"
						ClearQFlag $player "Race$rf"
						}
					}
				}
			}
		SendGossipComplete $player }
		}
	}
}

namespace eval Race {
	proc waypoint_273_Wait { npc } {
		set started [Race::GetStarted]
		if { $started == "Yes" } {
			SetWayPoint $npc 273 
		}
	}
	
	proc WayPoint_Start { npc } {
		set file "extra/Race_Stuff/Started.txt"
		set fileo [open $file w]
			puts $fileo Yes
		close $fileo
		set file "extra/Race_Stuff/Winner.txt"
		set filer [open $file w]
			puts $filer ""
		close $filer}
	
	proc WayPoint_End { npc } {
		set file "extra/Race_Stuff/Started.txt"
		set fileo [open $file w]
			puts $fileo No
		close $fileo
		set entry [GetEntry $npc]
		set side [GetScpValue "creatures.scp" "creature $entry" "side"]
		set winner [Race::GetWinner]
		if { $side == "Alliance" } {
			set enemy Horde 
		} else { 
			set enemy Alliance }
		if { $winner == $enemy } { 
			Say $npc 0 "Damn, i lost!" } else {
		set filew [open "extra/Race_Stuff/Winner.txt" w]
			puts $filew $side
		close $filew
		set r [Race::GetRaceNumber]
		set rn [ expr ($r+1) ]
		set filenumber [open "extra/Race_Stuff/RaceNumber.txt" w]
			puts $filenumber $rn
		close $filenumber}}
	
	proc GetWinner {} {
		set file "extra/Race_Stuff/Winner.txt"
		set filer [open $file r]
		set who [gets $filer]
			close $filer
		return $who
	}
	
	proc GetRaceNumber {} {
		set file "extra/Race_Stuff/RaceNumber.txt"
		set filer [open $file r]
		set number [gets $filer]
			close $filer
		return $number
	}
	
	proc GetStarted {} {
		set file "extra/Race_Stuff/Started.txt"
		set filer [open $file r]
		set yesno [gets $filer]
			close $filer
		return $yesno
	}

	proc CreateFile { player } {
		set name [GetName $player]
		set file "extra/Race_Stuff/$name.ini"
		set filer [open $file w+]}
	
	proc SetFlag { player } {
		set r [Race::GetRaceNumber]
		set rn [expr ($r+1)]
		SetQFlag $player "Race$rn"
		return "Thanks for beting"
	}
	
	proc InfoforIni { player } {
		set race [GetRace $player]
			switch $race {
				1 {return "Alliance"}
				3 {return "Alliance"}
				4 {return "Alliance"}
				7 {return "Alliance"}
				2 {return "Horde"}
				5 {return "Horde"}
				6 {return "Horde"}
				8 {return "Horde"}
			}
	}
	
	proc GetMoneyOption { option } {
		set g 00
		set money1 100$g$g
		set money2 10$g$g
		set money3 1$g$g
		set money4 10$g
		set money5 1$g
		set money6 10
		set money7 1
			switch $option {
				0 {return $money1}
				1 {return $money2}
				2 {return $money3}
				3 {return $money4}
				4 {return $money5}
				5 {return $money6}
				6 {return $money7}
			}
	}
	
	proc Proceso { player money } {
		if {![ChangeMoney $player -$money] } {
		return "You don't have enough money" } else {
		set filew [Race::CreateFile $player]
			puts $filew "$money"
			close $filew
		set bet [Race::SetFlag $player]
		return "$bet"}
	}
	
	proc GetMoney { player } {
		set name [GetName $player]
		set filer [open "extra/Race_Stuff/$name.ini" r]
		set money [gets $filer]
		close $filer
		return $money
	}
	
	puts "[clock format [clock seconds] -format %k:%M:%S]:M:Race System v0.1.1 by Snake Loaded"
}

