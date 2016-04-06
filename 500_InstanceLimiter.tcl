# StartTCL: n

namespace eval ::InstanceLimiter {
	variable trigger_level
	array set trigger_level {
		45 26
		78 11
		101 19
		107 20
		145 14
		228 11
		244 21
		257 16
		286 31
		324 20
		442 30
		446 41
		523 20
		527 0
		610 26
		612 26
		614 26
		902 31
		924 40
		1466 48
		1468 44
		2216 43
		2217 46
		2214 51
		2230 10
		2567 41
		2848 56
		2886 56
		3133 36
		3134 36
		3183 52
		3184 52
		3185 52
		3186 52
		3187 52
		3189 52
		3726 56
		3930 56
	}
	variable trigger_teleport
	array set trigger_teleport {
		45 {189 1688.57 1052.42 18.68 1.14}
		78 {36 -16.40 -383.07 61.78 1.86}
		101 {34 54.23 0.28 -18.34 6.26}
		107 {35 -0.91 40.57 -24.23 1.59}
		145 {33 -228.19 2110.56 76.89 1.22}
		228 {43 -163.49 132.95 -73.66 5.83}
		244 {47 1943.00 1544.63 82.00 1.38}
		257 {48 -151.89 106.96 -39.87 4.53}
		286 {70 -226.80 49.09 -46.03 1.39}
		324 {90 -332.22 -2.28 -150.86 2.77}
		442 {129 2592.55 1107.50 51.29 4.74}
		446 {109 -319.24 99.90 -131.85 3.19}
		523 {90 -736.51 2.71 -249.99 3.14}
		527 {1 8795.801758 969.427429 30.195545 3.398674}
		610 {189 855.11 1320.76 18.67 0.30}
		612 {189 1608.38 -320.50 18.67 5.97}
		614 {189 254.99 -206.82 18.68 5.76}
		902 {70 -211.23 385.09 -38.72 1.31}
		924 {209 1213.52 841.59 8.93 6.09}
		1466 {230 458.32 26.52 -70.67 4.95}
		1468 {229 78.784691 -228.056717 49.692474 4.765266}
		2216 {329 3393.550781 -3390.980713 143.164185 1.554557}
		2217 {329 3392.955078 -3366.750488 142.843719 4.692227}
		2214 {329 3593.15 -3646.56 138.50 5.33}
		2230 {389 3.81 -14.82 -17.84 4.39}
		2567 {289 196.37 127.05 134.91 6.09}
		2848 {249 30.68 -60.80 -5.27 4.58}
		2886 {409 1093.46 -469.41 -105.70 3.99}
		3133 {349 1019.69 -458.31 -43.43 0.31}
		3134 {349 752.91 -616.53 -33.11 1.37}
		3183 {429 47.63 -155.27 -2.71 6.01}
		3184 {429 -201.11 -328.66 -2.72 5.22}
		3185 {429 16.43 -836.91 -31.19 0.07}
		3186 {429 -64.23 160.13 -3.47 2.99}
		3187 {429 34.35 160.70 -3.47 0.72}
		3189 {429 254.79 -17.09 -2.56 5.25}
		3726 {469 -7674.47 -1108.38 396.65 0.61}
		3930 {309 -11915.751953 -1233.407837 92.287125}
	}
	variable trigger_name
	array set trigger_name {
		45 "Scarlet Monastery"
		78 "The DeadMines"
		101 "The Stockade"
		107 "Stormwind Vault"
		145 "Shadowfang Keep"
		228 "Wailing Caverns"
		244 "Razorfen Kraul"
		257 "Blackphantom Deeps"
		286 "Uldaman"
		324 "Gnomeregan"
		442 "Razorfen Downs"
		446 "Altar of Atal'Hakkar"
		523 "Gnomeregan Train Depot"
		610 "Scarlet Monastery Mini West"
		612 "Scarlet Monastery Mini East"
		614 "Scarlet Monastery Big East"
		902 "Uldaman"
		924 "Zul'Farrak"
		1466 "Blackrock Mountain"
		1468 "Blackrock Spire"
		2216 "Stratholme"
		2217 "Stratholme"
		2214 "Stratholme"
		2230 "Ragefire Chasm"
		2567 "Shadowprey Village"
		2848 "Onyxia's Lair"
		2886 "The Molten Bridge"
		3133 "Maraudon"
		3134 "Maraudon"
		3183 "Dire Maul"
		3184 "Dire Maul"
		3185 "Dire Maul"
		3186 "Dire Maul"
		3187 "Dire Maul"
		3189 "Dire Maul"
		3726 "Blackwing Lair"
		3930 "Zul´Gurub"
	}
}
proc ::InstanceLimiter::AreaTrigger { player trigger_number } {
	variable trigger_level
	variable trigger_teleport
	variable trigger_name
	if { $trigger_number == 527 } { TaxiNodeExplorered $player 26 }
	if { [ ::GetLevel $player ] >= $trigger_level($trigger_number) } {
		::Custom::TeleportPos $player $trigger_teleport($trigger_number)
	} else {
		Say $player 0 "I must be a level $trigger_level($trigger_number) to enter in $trigger_name($trigger_number)."
	}
}


namespace eval ::Exploredtrigger {}
	proc ::Exploredtrigger::AreaTrigger { player trigger_number } {
		TaxiNodeExplorered $player 27
}

namespace eval UnusedTriggers {
	proc AreaTrigger { player trigger_number } { return }
}