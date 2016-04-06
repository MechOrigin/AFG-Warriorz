# start-tcl: n
#
#################################
# PickPoket Script by skel v0.3 #
#################################
##########################################################################
#######################pickpocket v 0.41 by Skel/test/######################
##############################################################################

namespace eval vor {
proc vol { from to } {

#################################

set mdata [GetEntry $to]

#################итемсы которые необходимы для прохождения некоторых квестов##############
switch $mdata{
6846 {AddItem $from 7675}
6909 {AddItem $from 7737}
6494 {AddItem $from 7208}
6497 {AddItem $from 7231}
7051 {AddItem $from 7923}
7287 {AddItem $from 2478}
6188 {AddItem $from 19775}
8766 {AddItem $from 20023}
6768 {AddItem $from 20022}
5719 {AddItem $from 20022}
}
##########################
set Classe [GetClass $from]
set to [GetSelection $from]
set plevel [GetLevel $from]
set PName [GetName $from]
set got [GetObjectType $to]
set currenttime [clock seconds]
set lastvol 0
set skill 1
#####################проверка на существование файла
if {([file exists "data/vol/$PName"] == 1) } { set tfile [open "data/vol/$PName" r]
set lastvol [gets $tfile]
set skill [gets $tfile]
close $tfile }
#########################################################
if { [GetObjectType $to] == 3 } {
set Ttype [GetScpValue "creatures.scp" "creature [GetEntry $to]" "type"]
set TName [GetScpValue "creatures.scp" "creature [GetEntry $to]" "name"]
if {$Ttype==7} {
set diff [expr $currenttime - $lastvol]
set wait [expr 600-$diff]
if { $diff < 600 } { Say $from 0 "|cff008000 i need wait $wait seconds" }
if {$diff >600} {
set clevel [GetLevel $to]
if {$clevel< 10} {
set itemlist "118 2589 2570"
set ichance 10}
if {$clevel< 60} {
set itemlist "118 2589 2570"
set ichance 10}
##########################
if { $clevel >= $plevel} {
set ldiff [expr ($clevel-$plevel)]
set ratio [expr (($clevel*$skill)/($ldiff+1)*2.0)]
puts ">>>>>>>>>>>>$ratio" }

#########################

if { $plevel >$clevel} {
set ldiff [expr ($plevel-$clevel)]

set ratio [expr (($clevel*$skill)/$ldiff*10.0)]
puts " ratio=$ratio"
}
########################################

set rnd [expr {int(rand()*$ratio*2)}]
puts "random money $rnd "
###########################
#макс скил = левел х 5 ##
###########################
set max [expr ($plevel*5)]
puts "max skill $max"

#######рост скила###########

if {$rnd < $max} {
set Tadd [open "data/vol/$PName" w]
set skill [expr $skill+1]
if {$skill >= $max } {set skill $max }
puts $Tadd $currenttime
puts $Tadd $skill
close $Tadd
}


if {$rnd>=$max} {
set form [expr {int(rand()*1000)} ]
set chance [expr ($form +$skill)]
set mchance [expr (1000- $ichance*10)]"
puts "player chance to get item = $ichance %"
puts "player random procent without skill [expr ($form)/(10*1)] %"
puts "player random procent with skill [expr ($chance)/(10*1)] %"
if {$chance >= $mchance } {
set item [lindex $itemlist [expr {int(rand()*[llength $itemlist])}]]
AddItem $from $item
set itname [GetScpValue "items.scp" "item $item" "name"]
Say $from 0 "|cffffff00 i got $rnd money and $itname from mob"
}

ChangeMoney $from $rnd

set Tadd [open "data/vol/$PName" w]
puts $Tadd $currenttime
puts $Tadd $skill
close $Tadd
if {$chance < $mchance } {Say $from 0 "|cffffff00 i got $rnd money from mob"}
#Say $to 0 "I'm feeling something strange... Oh, my God, I lost $rnd bronze!"

} else {
Say $from 0 "|cffff0000 I miss my Pick...my skill now $skill"
}
}
}


###################################################################
if {$Ttype !=7} { Say $from 0 "|cFFF0002F Nothing to rob" } }
#####################################################################
if { [GetObjectType $to] != 3 } { set VLevel [GetLevel $to]
set diff [expr $currenttime - $lastvol]
set wait [expr 600-$diff]
if { $diff < 600 } { Say $from 0 "|cff008000 i need wait $wait seconds" }
if {$diff >600} {
set clevel [GetLevel $to]
if { $clevel >=$plevel} {
set ldiff [expr ($clevel-$plevel)]
set ratio [expr (($clevel*$skill)/($ldiff+1)*1.0)]
puts "$ratio" }
#########################
if { $plevel >$clevel} {
set ldiff [expr ($plevel-$cevel)]
set ratio [expr (($clevel*$skill)/$ldiff*10.0)]
puts " ratio=$ratio"
}
########################################

set rnd [expr {int(rand()*$ratio*2)}]
puts "random money $rnd "

#макс скил = левел х 5
###########################
set max [expr ($plevel*5)]
puts "max skill $max"
###########################
#рост скила
###########################
if {$rnd < $max} {
set Tadd [open "data/vol/$PName" w]
set skill [expr $skill+1]
puts $Tadd $currenttime
puts $Tadd $skill
close $Tadd
}


if {$rnd>=$max} {

if {[ChangeMoney $to -$rnd] == 1} { ChangeMoney $from $rnd
set Tadd [open "data/vol/$PName" w]
set skill [expr ($skill+1)]
puts $Tadd $currenttime
puts $Tadd $skill
Say $to 0 "I lost my $rnd bronze..."

} else {
Say $from 0 "|cffff0000 I miss my Pick...my skill now $skill"
}





####################################################
}
}
}


}
}

