# Start-TCL: n
#

namespace eval lvl_func {
	proc grade_level { level1 level2 } {
		set diff [expr {$level1-$level2}]
		if {$diff <= -10} {return 1
			} elseif {$diff >= -9 && $diff <= -5} {return 2
			} elseif {$diff >= -4 && $diff <= -3} {return 3
			} elseif {$diff >= -2 && $diff <= 2} {return 4
		} else {
			if {$level1 >= 60} {if {$diff > 12} {return 6} else {return 5}
				} elseif {$level1 <= 59 && $level1 >= 55} {if {$diff > 11} {return 6} else {return 5}
				} elseif {$level1 <= 54 && $level1 >= 50} {if {$diff > 10} {return 6} else {return 5}
				} elseif {$level1 <= 49 && $level1 >= 45} {if {$diff > 9} {return 6} else {return 5}
				} elseif {$level1 <= 44 && $level1 >= 40} {if {$diff > 8} {return 6} else {return 5}
				} elseif {$level1 <= 39 && $level1 >= 30} {if {$diff > 7} {return 6} else {return 5}
				} elseif {$level1 <= 29 && $level1 >= 20} {if {$diff > 6} {return 6} else {return 5}
				} elseif {$level1 <= 19 && $level1 >= 10} {if {$diff > 5} {return 6} else {return 5}
				} elseif {$level1 <= 9 && $level1 >= 1} {if {$diff > 4} {return 6} else {return 5}
			}
		}
	}
}
