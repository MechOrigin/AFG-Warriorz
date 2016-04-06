# Start-TCL: n
# 
# Charge and Intercept system v1.0 by DeadDream
# Modified v1.2 by seatleson 
#
# Modified by Delfin
#
# Compatible with Start-TCL 0.9.2
#

namespace eval ::ChargeSkills { 
	proc ::ChargeSkills::Charge { to from } { ::CastSpell $from $from 12695 }
	proc ::ChargeSkills::ChargeStun { from } { set to [ ::GetSelection $from ] ::CastSpell $from $to 7922 }
	proc ::ChargeSkills::Intercept1 { to from } { ::CastSpell $from $from 14530 }
	proc ::ChargeSkills::Intercept2 { to from } { ::CastSpell $from $from 17498 }
	proc ::ChargeSkills::Intercept3 { to from } { ::CastSpell $from $from 22863 }
	proc ::ChargeSkills::InterceptStun1 { from } { set to [ ::GetSelection $from ] ::CastSpell $from $to 20253 }
	proc ::ChargeSkills::InterceptStun2 { from } { set to [ ::GetSelection $from ] ::CastSpell $from $to 20614 }
	proc ::ChargeSkills::InterceptStun3 { from } { set to [ ::GetSelection $from ] ::CastSpell $from $to 20615 }
} 
