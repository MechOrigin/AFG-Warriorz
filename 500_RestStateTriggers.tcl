# Start-TCL: n

namespace eval RestState {
	variable area_trigger
	array set area_trigger {
		71 1
		562 1
		682 1
		707 1
		708 1
		709 1
		710 1
		712 1
		713 1
		715 1
		716 1
		717 1
		719 2
		720 2
		721 2
		722 2
		742 2
		743 0
		843 2
		844 2
		862 0
		982 2
		1022 2
		1023 0
		1024 1
		1025 2
		1606 2
		1646 2
		2266 1
		2267 2
		2286 2
		2287 0
		2610 2
	}
	proc Side { player } {
		set race [ ::GetRace $player ]
		if {$race == 1 || $race == 3 || $race == 4 || $race == 7} {
			return 1
		} else {
			return 2
		}
	}
	proc AreaTrigger { player trigger_number } {
		variable restsidecheck
		variable area_trigger
		if { $trigger_number == 716 } { TaxiNodeExplorered $player 27 }
		switch $area_trigger($trigger_number) {
			0 { RestState::resting $player }
			1 { 
				if { $restsidecheck == 1 && [Side $player] == 1 } {
					RestState::resting $player
				} elseif { $restsidecheck == 0 } {
					RestState::resting $player
				}
			}
			2 {
				if { $restsidecheck == 1 && [Side $player] == 2 } {
					RestState::resting $player
				} elseif { $restsidecheck == 0 } {
					RestState::resting $player
				}
			}
			default { return }
		}
		return
	}
}
