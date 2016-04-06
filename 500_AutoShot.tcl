# AutoShot v1.3
# by Seatleson & Raverouk (Agro settings in by Valleriani)
################################################################ 

namespace eval AutoShot {
proc Bow { to from } {
after 2000 
if {[GetObjectType $to] != 4} { SetQFlag $from "longrange"; SetQFlag $to "longrange" }
set selection [GetSelection $from]
if {![GetHealthPCT $to]} {
return "You target is Dead!"
}
CastSpell $from $to 75
}
proc Wand { to from } {
after 2000 
if {[GetObjectType $to] != 4} { SetQFlag $from "longrange"; SetQFlag $to "longrange" }
set selection [GetSelection $from]
if {![GetHealthPCT $to]} {
return "You target is Dead!"
}
CastSpell $from $to 5019
}
}

 