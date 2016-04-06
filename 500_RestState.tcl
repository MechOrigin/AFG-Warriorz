# Start-TCL: n

namespace eval RestState {
  proc create_reststatedb {player cargs} {
    if {[::GetPlevel $player] < 6} {return "You are not allowed to use this command!"}
    if {$cargs == "redo"} {reststate eval {DROP TABLE `reststate`}}
    reststate eval {CREATE TABLE IF NOT EXISTS `reststate` (`name` TEXT, `level` TEXT, `time` TEXT, `x` TEXT, `y` TEXT, `z` TEXT)}
    return "RestState System database setup done."
  }
  proc reststatestatus {player cargs} {
    ::SetQFlag $player reststatecheck
    if {[RestState::restxpcount $player] == 1} {return "ERR_EXHAUSTION_RESTED"}
    return "ERR_EXHAUSTION_NORMAL"
  }
  proc restingcheck {player cargs} {
    variable restdistoff
    if {$cargs == "login"} {
      if {[::GetQFlag $player resting]} {return "RESTING_ON"}
      return "RESTING_OFF"    
    }
    if {![::GetQFlag $player resting]} {return "RESTING_OFF"}
    set pos [::GetPos $player]
    set x [lindex $pos 1]
    set y [lindex $pos 2]
    set z [lindex $pos 3]
    set pname [::GetName $player]
    set exist [reststate eval {SELECT `name` FROM `reststate` WHERE (`name` = $pname)}]
    if {$exist == ""} {return "RESTING_OFF"}
    set read [reststate eval {SELECT `x`, `y`, `z` FROM `reststate` WHERE (`name` LIKE $pname)}]
    set x_rest [lindex $read 0]
    set y_rest [lindex $read 1]
    set z_rest [lindex $read 2]
    set distinrest [expr {int(sqrt((($x - $x_rest)*($x - $x_rest)) + (($y - $y_rest)*($y - $y_rest)) + (($z - $z_rest)*($z - $z_rest))))}]
    if {$distinrest >= $restdistoff} {
      ::ClearQFlag $player resting
      return "RESTING_OFF"
    }
    RestState::reststatestatus $player 0
  }
  proc reststatusreset {player cargs} {
    if {[::GetPlevel $player] < 4} {return "You are not allowed to use this command"}
    if {[::GetObjectType [::GetSelection $player]] != 4} {return "You must select target player first!"}
    set target [::GetSelection $player]
    ::ClearQFlag $target resting
    ::ClearQFlag $target rested
    set tname [::GetName $target]
    set tlevel [::GetLevel $target]
    set timenow [clock seconds]
    set pos [::GetPos $target]
    set x [lindex $pos 1]
    set y [lindex $pos 2]
    set z [lindex $pos 3]
    reststate eval {UPDATE `reststate` set `name` = $tname, `level` = $tlevel, `time` = $timenow, `x`= $x, `y` = $y, `z` = $z WHERE (`name` = $tname)}
    Say $target 0 "|cFFFFFF00EXHAUSTION_NORMAL|r"
    return "Player $tname now have status Normal."
  }
  proc resting {player} {
    if {[::GetQFlag $player resting]} {return}
    set pname [::GetName $player]
    set plevel [::GetLevel $player]
    set timenow [clock seconds]
    set pos [::GetPos $player]
    set x [lindex $pos 1]
    set y [lindex $pos 2]
    set z [lindex $pos 3]
    if {[::GetQFlag $player rested]} {
      set rested_xp_001 [::GetQFlag $player rested_xp_001]
      set rested_xp_002 [::GetQFlag $player rested_xp_002]
      set rested_xp_003 [::GetQFlag $player rested_xp_003]
      set rested_xp_004 [::GetQFlag $player rested_xp_004]
      set rested_xp_005 [::GetQFlag $player rested_xp_005]
      set rested_xp_006 [::GetQFlag $player rested_xp_006]
      set rested_xp_007 [::GetQFlag $player rested_xp_007]
      set rested_xp_008 [::GetQFlag $player rested_xp_008]
      set rested_xp_009 [::GetQFlag $player rested_xp_009]
      set rested_xp_010 [::GetQFlag $player rested_xp_010]
      set rested_xp_011 [::GetQFlag $player rested_xp_011]
      set rested_xp_012 [::GetQFlag $player rested_xp_012]
      set rested_xp_013 [::GetQFlag $player rested_xp_013]
      set rested_xp_014 [::GetQFlag $player rested_xp_014]
      set rested_xp_015 [::GetQFlag $player rested_xp_015]
      set rested_xp_016 [::GetQFlag $player rested_xp_016]
      set rested_xp_017 [::GetQFlag $player rested_xp_017]
      set rested_xp_018 [::GetQFlag $player rested_xp_018]
      set rested_xp_019 [::GetQFlag $player rested_xp_019]
      set rested_xp_020 [::GetQFlag $player rested_xp_020]
      set rested_xp_021 [::GetQFlag $player rested_xp_021]
      set rested_xp_022 [::GetQFlag $player rested_xp_022]
      set rested_xp_023 [::GetQFlag $player rested_xp_023]
      set rested_xp_024 [::GetQFlag $player rested_xp_024]
      set rested_xp_025 [::GetQFlag $player rested_xp_025]
      set rested_xp_026 [::GetQFlag $player rested_xp_026]
      set rested_xp_027 [::GetQFlag $player rested_xp_027]
      set rested_xp_028 [::GetQFlag $player rested_xp_028]
      set rested_xp_029 [::GetQFlag $player rested_xp_029]
      set rested_xp_030 [::GetQFlag $player rested_xp_030]
      set rested_xp_031 [::GetQFlag $player rested_xp_031]
      set rested_xp_032 [::GetQFlag $player rested_xp_032]
      set rested_xp_033 [::GetQFlag $player rested_xp_033]
      set rested_xp_034 [::GetQFlag $player rested_xp_034]
      set rested_xp_035 [::GetQFlag $player rested_xp_035]
      set rested_xp_036 [::GetQFlag $player rested_xp_036]
      set rested_xp_037 [::GetQFlag $player rested_xp_037]
      set rested_xp_038 [::GetQFlag $player rested_xp_038]
      set rested_xp_039 [::GetQFlag $player rested_xp_039]
      set rested_xp_040 [::GetQFlag $player rested_xp_040]
      set rested_xp_041 [::GetQFlag $player rested_xp_041]
      set rested_xp_042 [::GetQFlag $player rested_xp_042]
      set rested_xp_043 [::GetQFlag $player rested_xp_043]
      set rested_xp_044 [::GetQFlag $player rested_xp_044]
      set rested_xp_045 [::GetQFlag $player rested_xp_045]
      set rested_xp_046 [::GetQFlag $player rested_xp_046]
      set rested_xp_047 [::GetQFlag $player rested_xp_047]
      set rested_xp_048 [::GetQFlag $player rested_xp_048]
      set rested_xp_049 [::GetQFlag $player rested_xp_049]
      set rested_xp_050 [::GetQFlag $player rested_xp_050]
      set rested_xp_051 [::GetQFlag $player rested_xp_051]
      set rested_xp_052 [::GetQFlag $player rested_xp_052]
      set rested_xp_053 [::GetQFlag $player rested_xp_053]
      set rested_xp_054 [::GetQFlag $player rested_xp_054]
      set rested_xp_055 [::GetQFlag $player rested_xp_055]
      set rested_xp_056 [::GetQFlag $player rested_xp_056]
      set rested_xp_057 [::GetQFlag $player rested_xp_057]
      set rested_xp_058 [::GetQFlag $player rested_xp_058]
      set rested_xp_059 [::GetQFlag $player rested_xp_059]
      set rested_xp_060 [::GetQFlag $player rested_xp_060]
      set rested_xp_061 [::GetQFlag $player rested_xp_061]
      set rested_xp_062 [::GetQFlag $player rested_xp_062]
      set rested_xp_063 [::GetQFlag $player rested_xp_063]
      set rested_xp_064 [::GetQFlag $player rested_xp_064]
      set rested_xp_065 [::GetQFlag $player rested_xp_065]
      set rested_xp_066 [::GetQFlag $player rested_xp_066]
      set rested_xp_067 [::GetQFlag $player rested_xp_067]
      set rested_xp_068 [::GetQFlag $player rested_xp_068]
      set rested_xp_069 [::GetQFlag $player rested_xp_069]
      set rested_xp_070 [::GetQFlag $player rested_xp_070]
      set rested_xp_071 [::GetQFlag $player rested_xp_071]
      set rested_xp_072 [::GetQFlag $player rested_xp_072]
      set rested_xp_073 [::GetQFlag $player rested_xp_073]
      set rested_xp_074 [::GetQFlag $player rested_xp_074]
      set rested_xp_075 [::GetQFlag $player rested_xp_075]
      set rested_xp_076 [::GetQFlag $player rested_xp_076]
      set rested_xp_077 [::GetQFlag $player rested_xp_077]
      set rested_xp_078 [::GetQFlag $player rested_xp_078]
      set rested_xp_079 [::GetQFlag $player rested_xp_079]
      set rested_xp_080 [::GetQFlag $player rested_xp_080]
      set rested_xp_081 [::GetQFlag $player rested_xp_081]
      set rested_xp_082 [::GetQFlag $player rested_xp_082]
      set rested_xp_083 [::GetQFlag $player rested_xp_083]
      set rested_xp_084 [::GetQFlag $player rested_xp_084]
      set rested_xp_085 [::GetQFlag $player rested_xp_085]
      set rested_xp_086 [::GetQFlag $player rested_xp_086]
      set rested_xp_087 [::GetQFlag $player rested_xp_087]
      set rested_xp_088 [::GetQFlag $player rested_xp_088]
      set rested_xp_089 [::GetQFlag $player rested_xp_089]
      set rested_xp_090 [::GetQFlag $player rested_xp_090]
      set rested_xp_091 [::GetQFlag $player rested_xp_091]
      set rested_xp_092 [::GetQFlag $player rested_xp_092]
      set rested_xp_093 [::GetQFlag $player rested_xp_093]
      set rested_xp_094 [::GetQFlag $player rested_xp_094]
      set rested_xp_095 [::GetQFlag $player rested_xp_095]
      set rested_xp_096 [::GetQFlag $player rested_xp_096]
      set rested_xp_097 [::GetQFlag $player rested_xp_097]
      set rested_xp_098 [::GetQFlag $player rested_xp_098]
      set rested_xp_099 [::GetQFlag $player rested_xp_099]
      set rested_xp_100 [::GetQFlag $player rested_xp_100]
      set rested_xp_101 [::GetQFlag $player rested_xp_101]
      set rested_xp_102 [::GetQFlag $player rested_xp_102]
      set rested_xp_103 [::GetQFlag $player rested_xp_103]
      set rested_xp_104 [::GetQFlag $player rested_xp_104]
      set rested_xp_105 [::GetQFlag $player rested_xp_105]
      set rested_xp_106 [::GetQFlag $player rested_xp_106]
      set rested_xp_107 [::GetQFlag $player rested_xp_107]
      set rested_xp_108 [::GetQFlag $player rested_xp_108]
      set rested_xp_109 [::GetQFlag $player rested_xp_109]
      set rested_xp_110 [::GetQFlag $player rested_xp_110]
      set rested_xp_111 [::GetQFlag $player rested_xp_111]
      set rested_xp_112 [::GetQFlag $player rested_xp_112]
      set rested_xp_113 [::GetQFlag $player rested_xp_113]
      set rested_xp_114 [::GetQFlag $player rested_xp_114]
      set rested_xp_115 [::GetQFlag $player rested_xp_115]
      set rested_xp_116 [::GetQFlag $player rested_xp_116]
      set rested_xp_117 [::GetQFlag $player rested_xp_117]
      set rested_xp_118 [::GetQFlag $player rested_xp_118]
      set rested_xp_119 [::GetQFlag $player rested_xp_119]
      set rested_xp_120 [::GetQFlag $player rested_xp_120]
      set rested_xp_121 [::GetQFlag $player rested_xp_121]
      set rested_xp_122 [::GetQFlag $player rested_xp_122]
      set rested_xp_123 [::GetQFlag $player rested_xp_123]
      set rested_xp_124 [::GetQFlag $player rested_xp_124]
      set rested_xp_125 [::GetQFlag $player rested_xp_125]
      set rested_xp_126 [::GetQFlag $player rested_xp_126]
      set rested_xp_127 [::GetQFlag $player rested_xp_127]
      set rested_xp_128 [::GetQFlag $player rested_xp_128]
      set rested_xp_129 [::GetQFlag $player rested_xp_129]
      set rested_xp_130 [::GetQFlag $player rested_xp_130]
      set rested_xp_131 [::GetQFlag $player rested_xp_131]
      set rested_xp_132 [::GetQFlag $player rested_xp_132]
      set rested_xp_133 [::GetQFlag $player rested_xp_133]
      set rested_xp_134 [::GetQFlag $player rested_xp_134]
      set rested_xp_135 [::GetQFlag $player rested_xp_135]
      set rested_xp_136 [::GetQFlag $player rested_xp_136]
      set rested_xp_137 [::GetQFlag $player rested_xp_137]
      set rested_xp_138 [::GetQFlag $player rested_xp_138]
      set rested_xp_139 [::GetQFlag $player rested_xp_139]
      set rested_xp_140 [::GetQFlag $player rested_xp_140]
      set rested_xp_141 [::GetQFlag $player rested_xp_141]
      set rested_xp_142 [::GetQFlag $player rested_xp_142]
      set rested_xp_143 [::GetQFlag $player rested_xp_143]
      set rested_xp_144 [::GetQFlag $player rested_xp_144]
      set rested_xp_145 [::GetQFlag $player rested_xp_145]
      set rested_xp_146 [::GetQFlag $player rested_xp_146]
      set rested_xp_147 [::GetQFlag $player rested_xp_147]
      set rested_xp_148 [::GetQFlag $player rested_xp_148]
      set rested_xp_149 [::GetQFlag $player rested_xp_149]
      set rested_xp_150 [::GetQFlag $player rested_xp_150]
      set rested_xp_151 [::GetQFlag $player rested_xp_151]
      set rested_xp_152 [::GetQFlag $player rested_xp_152]
      set rested_xp_153 [::GetQFlag $player rested_xp_153]
      set rested_xp_154 [::GetQFlag $player rested_xp_154]
      set rested_xp_155 [::GetQFlag $player rested_xp_155]
      set rested_xp_156 [::GetQFlag $player rested_xp_156]
      set rested_xp_157 [::GetQFlag $player rested_xp_157]
      set rested_xp_158 [::GetQFlag $player rested_xp_158]
      set rested_xp_159 [::GetQFlag $player rested_xp_159]
      set rested_xp_160 [::GetQFlag $player rested_xp_160]
      set rested_xp_161 [::GetQFlag $player rested_xp_161]
      set rested_xp_162 [::GetQFlag $player rested_xp_162]
      set rested_xp_163 [::GetQFlag $player rested_xp_163]
      set rested_xp_164 [::GetQFlag $player rested_xp_164]
      set rested_xp_165 [::GetQFlag $player rested_xp_165]
      set rested_xp_166 [::GetQFlag $player rested_xp_166]
      set rested_xp_167 [::GetQFlag $player rested_xp_167]
      set rested_xp_168 [::GetQFlag $player rested_xp_168]
      set rested_xp_169 [::GetQFlag $player rested_xp_169]
      set rested_xp_170 [::GetQFlag $player rested_xp_170]
      set rested_xp_171 [::GetQFlag $player rested_xp_171]
      set rested_xp_172 [::GetQFlag $player rested_xp_172]
      set rested_xp_173 [::GetQFlag $player rested_xp_173]
      set rested_xp_174 [::GetQFlag $player rested_xp_174]
      set rested_xp_175 [::GetQFlag $player rested_xp_175]
      set rested_xp_176 [::GetQFlag $player rested_xp_176]
      set rested_xp_177 [::GetQFlag $player rested_xp_177]
      set rested_xp_178 [::GetQFlag $player rested_xp_178]
      set rested_xp_179 [::GetQFlag $player rested_xp_179]
      set rested_xp_180 [::GetQFlag $player rested_xp_180]
      if {$rested_xp_001 == 1} {::SetQFlag $player rested_xp_001}
      if {$rested_xp_002 == 1} {::SetQFlag $player rested_xp_002}
      if {$rested_xp_003 == 1} {::SetQFlag $player rested_xp_003}
      if {$rested_xp_004 == 1} {::SetQFlag $player rested_xp_004}
      if {$rested_xp_005 == 1} {::SetQFlag $player rested_xp_005}
      if {$rested_xp_006 == 1} {::SetQFlag $player rested_xp_006}
      if {$rested_xp_007 == 1} {::SetQFlag $player rested_xp_007}
      if {$rested_xp_008 == 1} {::SetQFlag $player rested_xp_008}
      if {$rested_xp_009 == 1} {::SetQFlag $player rested_xp_009}
      if {$rested_xp_010 == 1} {::SetQFlag $player rested_xp_010}
      if {$rested_xp_011 == 1} {::SetQFlag $player rested_xp_011}
      if {$rested_xp_012 == 1} {::SetQFlag $player rested_xp_012}
      if {$rested_xp_013 == 1} {::SetQFlag $player rested_xp_013}
      if {$rested_xp_014 == 1} {::SetQFlag $player rested_xp_014}
      if {$rested_xp_015 == 1} {::SetQFlag $player rested_xp_015}
      if {$rested_xp_016 == 1} {::SetQFlag $player rested_xp_016}
      if {$rested_xp_017 == 1} {::SetQFlag $player rested_xp_017}
      if {$rested_xp_018 == 1} {::SetQFlag $player rested_xp_018}
      if {$rested_xp_019 == 1} {::SetQFlag $player rested_xp_019}
      if {$rested_xp_020 == 1} {::SetQFlag $player rested_xp_020}
      if {$rested_xp_021 == 1} {::SetQFlag $player rested_xp_021}
      if {$rested_xp_022 == 1} {::SetQFlag $player rested_xp_022}
      if {$rested_xp_023 == 1} {::SetQFlag $player rested_xp_023}
      if {$rested_xp_024 == 1} {::SetQFlag $player rested_xp_024}
      if {$rested_xp_025 == 1} {::SetQFlag $player rested_xp_025}
      if {$rested_xp_026 == 1} {::SetQFlag $player rested_xp_026}
      if {$rested_xp_027 == 1} {::SetQFlag $player rested_xp_027}
      if {$rested_xp_028 == 1} {::SetQFlag $player rested_xp_028}
      if {$rested_xp_029 == 1} {::SetQFlag $player rested_xp_029}
      if {$rested_xp_030 == 1} {::SetQFlag $player rested_xp_030}
      if {$rested_xp_031 == 1} {::SetQFlag $player rested_xp_031}
      if {$rested_xp_032 == 1} {::SetQFlag $player rested_xp_032}
      if {$rested_xp_033 == 1} {::SetQFlag $player rested_xp_033}
      if {$rested_xp_034 == 1} {::SetQFlag $player rested_xp_034}
      if {$rested_xp_035 == 1} {::SetQFlag $player rested_xp_035}
      if {$rested_xp_036 == 1} {::SetQFlag $player rested_xp_036}
      if {$rested_xp_037 == 1} {::SetQFlag $player rested_xp_037}
      if {$rested_xp_038 == 1} {::SetQFlag $player rested_xp_038}
      if {$rested_xp_039 == 1} {::SetQFlag $player rested_xp_039}
      if {$rested_xp_040 == 1} {::SetQFlag $player rested_xp_040}
      if {$rested_xp_041 == 1} {::SetQFlag $player rested_xp_041}
      if {$rested_xp_042 == 1} {::SetQFlag $player rested_xp_042}
      if {$rested_xp_043 == 1} {::SetQFlag $player rested_xp_043}
      if {$rested_xp_044 == 1} {::SetQFlag $player rested_xp_044}
      if {$rested_xp_045 == 1} {::SetQFlag $player rested_xp_045}
      if {$rested_xp_046 == 1} {::SetQFlag $player rested_xp_046}
      if {$rested_xp_047 == 1} {::SetQFlag $player rested_xp_047}
      if {$rested_xp_048 == 1} {::SetQFlag $player rested_xp_048}
      if {$rested_xp_049 == 1} {::SetQFlag $player rested_xp_049}
      if {$rested_xp_050 == 1} {::SetQFlag $player rested_xp_050}
      if {$rested_xp_051 == 1} {::SetQFlag $player rested_xp_051}
      if {$rested_xp_052 == 1} {::SetQFlag $player rested_xp_052}
      if {$rested_xp_053 == 1} {::SetQFlag $player rested_xp_053}
      if {$rested_xp_054 == 1} {::SetQFlag $player rested_xp_054}
      if {$rested_xp_055 == 1} {::SetQFlag $player rested_xp_055}
      if {$rested_xp_056 == 1} {::SetQFlag $player rested_xp_056}
      if {$rested_xp_057 == 1} {::SetQFlag $player rested_xp_057}
      if {$rested_xp_058 == 1} {::SetQFlag $player rested_xp_058}
      if {$rested_xp_059 == 1} {::SetQFlag $player rested_xp_059}
      if {$rested_xp_060 == 1} {::SetQFlag $player rested_xp_060}
      if {$rested_xp_061 == 1} {::SetQFlag $player rested_xp_061}
      if {$rested_xp_062 == 1} {::SetQFlag $player rested_xp_062}
      if {$rested_xp_063 == 1} {::SetQFlag $player rested_xp_063}
      if {$rested_xp_064 == 1} {::SetQFlag $player rested_xp_064}
      if {$rested_xp_065 == 1} {::SetQFlag $player rested_xp_065}
      if {$rested_xp_066 == 1} {::SetQFlag $player rested_xp_066}
      if {$rested_xp_067 == 1} {::SetQFlag $player rested_xp_067}
      if {$rested_xp_068 == 1} {::SetQFlag $player rested_xp_068}
      if {$rested_xp_069 == 1} {::SetQFlag $player rested_xp_069}
      if {$rested_xp_070 == 1} {::SetQFlag $player rested_xp_070}
      if {$rested_xp_071 == 1} {::SetQFlag $player rested_xp_071}
      if {$rested_xp_072 == 1} {::SetQFlag $player rested_xp_072}
      if {$rested_xp_073 == 1} {::SetQFlag $player rested_xp_073}
      if {$rested_xp_074 == 1} {::SetQFlag $player rested_xp_074}
      if {$rested_xp_075 == 1} {::SetQFlag $player rested_xp_075}
      if {$rested_xp_076 == 1} {::SetQFlag $player rested_xp_076}
      if {$rested_xp_077 == 1} {::SetQFlag $player rested_xp_077}
      if {$rested_xp_078 == 1} {::SetQFlag $player rested_xp_078}
      if {$rested_xp_079 == 1} {::SetQFlag $player rested_xp_079}
      if {$rested_xp_080 == 1} {::SetQFlag $player rested_xp_080}
      if {$rested_xp_081 == 1} {::SetQFlag $player rested_xp_081}
      if {$rested_xp_082 == 1} {::SetQFlag $player rested_xp_082}
      if {$rested_xp_083 == 1} {::SetQFlag $player rested_xp_083}
      if {$rested_xp_084 == 1} {::SetQFlag $player rested_xp_084}
      if {$rested_xp_085 == 1} {::SetQFlag $player rested_xp_085}
      if {$rested_xp_086 == 1} {::SetQFlag $player rested_xp_086}
      if {$rested_xp_087 == 1} {::SetQFlag $player rested_xp_087}
      if {$rested_xp_088 == 1} {::SetQFlag $player rested_xp_088}
      if {$rested_xp_089 == 1} {::SetQFlag $player rested_xp_089}
      if {$rested_xp_090 == 1} {::SetQFlag $player rested_xp_090}
      if {$rested_xp_091 == 1} {::SetQFlag $player rested_xp_091}
      if {$rested_xp_092 == 1} {::SetQFlag $player rested_xp_092}
      if {$rested_xp_093 == 1} {::SetQFlag $player rested_xp_093}
      if {$rested_xp_094 == 1} {::SetQFlag $player rested_xp_094}
      if {$rested_xp_095 == 1} {::SetQFlag $player rested_xp_095}
      if {$rested_xp_096 == 1} {::SetQFlag $player rested_xp_096}
      if {$rested_xp_097 == 1} {::SetQFlag $player rested_xp_097}
      if {$rested_xp_098 == 1} {::SetQFlag $player rested_xp_098}
      if {$rested_xp_099 == 1} {::SetQFlag $player rested_xp_099}
      if {$rested_xp_100 == 1} {::SetQFlag $player rested_xp_100}
      if {$rested_xp_101 == 1} {::SetQFlag $player rested_xp_101}
      if {$rested_xp_102 == 1} {::SetQFlag $player rested_xp_102}
      if {$rested_xp_103 == 1} {::SetQFlag $player rested_xp_103}
      if {$rested_xp_104 == 1} {::SetQFlag $player rested_xp_104}
      if {$rested_xp_105 == 1} {::SetQFlag $player rested_xp_105}
      if {$rested_xp_106 == 1} {::SetQFlag $player rested_xp_106}
      if {$rested_xp_107 == 1} {::SetQFlag $player rested_xp_107}
      if {$rested_xp_108 == 1} {::SetQFlag $player rested_xp_108}
      if {$rested_xp_109 == 1} {::SetQFlag $player rested_xp_109}
      if {$rested_xp_110 == 1} {::SetQFlag $player rested_xp_110}
      if {$rested_xp_111 == 1} {::SetQFlag $player rested_xp_111}
      if {$rested_xp_112 == 1} {::SetQFlag $player rested_xp_112}
      if {$rested_xp_113 == 1} {::SetQFlag $player rested_xp_113}
      if {$rested_xp_114 == 1} {::SetQFlag $player rested_xp_114}
      if {$rested_xp_115 == 1} {::SetQFlag $player rested_xp_115}
      if {$rested_xp_116 == 1} {::SetQFlag $player rested_xp_116}
      if {$rested_xp_117 == 1} {::SetQFlag $player rested_xp_117}
      if {$rested_xp_118 == 1} {::SetQFlag $player rested_xp_118}
      if {$rested_xp_119 == 1} {::SetQFlag $player rested_xp_119}
      if {$rested_xp_120 == 1} {::SetQFlag $player rested_xp_120}
      if {$rested_xp_121 == 1} {::SetQFlag $player rested_xp_121}
      if {$rested_xp_122 == 1} {::SetQFlag $player rested_xp_122}
      if {$rested_xp_123 == 1} {::SetQFlag $player rested_xp_123}
      if {$rested_xp_124 == 1} {::SetQFlag $player rested_xp_124}
      if {$rested_xp_125 == 1} {::SetQFlag $player rested_xp_125}
      if {$rested_xp_126 == 1} {::SetQFlag $player rested_xp_126}
      if {$rested_xp_127 == 1} {::SetQFlag $player rested_xp_127}
      if {$rested_xp_128 == 1} {::SetQFlag $player rested_xp_128}
      if {$rested_xp_129 == 1} {::SetQFlag $player rested_xp_129}
      if {$rested_xp_130 == 1} {::SetQFlag $player rested_xp_130}
      if {$rested_xp_131 == 1} {::SetQFlag $player rested_xp_131}
      if {$rested_xp_132 == 1} {::SetQFlag $player rested_xp_132}
      if {$rested_xp_133 == 1} {::SetQFlag $player rested_xp_133}
      if {$rested_xp_134 == 1} {::SetQFlag $player rested_xp_134}
      if {$rested_xp_135 == 1} {::SetQFlag $player rested_xp_135}
      if {$rested_xp_136 == 1} {::SetQFlag $player rested_xp_136}
      if {$rested_xp_137 == 1} {::SetQFlag $player rested_xp_137}
      if {$rested_xp_138 == 1} {::SetQFlag $player rested_xp_138}
      if {$rested_xp_139 == 1} {::SetQFlag $player rested_xp_139}
      if {$rested_xp_140 == 1} {::SetQFlag $player rested_xp_140}
      if {$rested_xp_141 == 1} {::SetQFlag $player rested_xp_141}
      if {$rested_xp_142 == 1} {::SetQFlag $player rested_xp_142}
      if {$rested_xp_143 == 1} {::SetQFlag $player rested_xp_143}
      if {$rested_xp_144 == 1} {::SetQFlag $player rested_xp_144}
      if {$rested_xp_145 == 1} {::SetQFlag $player rested_xp_145}
      if {$rested_xp_146 == 1} {::SetQFlag $player rested_xp_146}
      if {$rested_xp_147 == 1} {::SetQFlag $player rested_xp_147}
      if {$rested_xp_148 == 1} {::SetQFlag $player rested_xp_148}
      if {$rested_xp_149 == 1} {::SetQFlag $player rested_xp_149}
      if {$rested_xp_150 == 1} {::SetQFlag $player rested_xp_150}
      if {$rested_xp_151 == 1} {::SetQFlag $player rested_xp_151}
      if {$rested_xp_152 == 1} {::SetQFlag $player rested_xp_152}
      if {$rested_xp_153 == 1} {::SetQFlag $player rested_xp_153}
      if {$rested_xp_154 == 1} {::SetQFlag $player rested_xp_154}
      if {$rested_xp_155 == 1} {::SetQFlag $player rested_xp_155}
      if {$rested_xp_156 == 1} {::SetQFlag $player rested_xp_156}
      if {$rested_xp_157 == 1} {::SetQFlag $player rested_xp_157}
      if {$rested_xp_158 == 1} {::SetQFlag $player rested_xp_158}
      if {$rested_xp_159 == 1} {::SetQFlag $player rested_xp_159}
      if {$rested_xp_160 == 1} {::SetQFlag $player rested_xp_160}
      if {$rested_xp_161 == 1} {::SetQFlag $player rested_xp_161}
      if {$rested_xp_162 == 1} {::SetQFlag $player rested_xp_162}
      if {$rested_xp_163 == 1} {::SetQFlag $player rested_xp_163}
      if {$rested_xp_164 == 1} {::SetQFlag $player rested_xp_164}
      if {$rested_xp_165 == 1} {::SetQFlag $player rested_xp_165}
      if {$rested_xp_166 == 1} {::SetQFlag $player rested_xp_166}
      if {$rested_xp_167 == 1} {::SetQFlag $player rested_xp_167}
      if {$rested_xp_168 == 1} {::SetQFlag $player rested_xp_168}
      if {$rested_xp_169 == 1} {::SetQFlag $player rested_xp_169}
      if {$rested_xp_170 == 1} {::SetQFlag $player rested_xp_170}
      if {$rested_xp_171 == 1} {::SetQFlag $player rested_xp_171}
      if {$rested_xp_172 == 1} {::SetQFlag $player rested_xp_172}
      if {$rested_xp_173 == 1} {::SetQFlag $player rested_xp_173}
      if {$rested_xp_174 == 1} {::SetQFlag $player rested_xp_174}
      if {$rested_xp_175 == 1} {::SetQFlag $player rested_xp_175}
      if {$rested_xp_176 == 1} {::SetQFlag $player rested_xp_176}
      if {$rested_xp_177 == 1} {::SetQFlag $player rested_xp_177}
      if {$rested_xp_178 == 1} {::SetQFlag $player rested_xp_178}
      if {$rested_xp_179 == 1} {::SetQFlag $player rested_xp_179}
      if {$rested_xp_180 == 1} {::SetQFlag $player rested_xp_180}
    } else {
      ::ClearQFlag $player rested
      ::ClearQFlag $player rested_xp_001
      ::ClearQFlag $player rested_xp_002
      ::ClearQFlag $player rested_xp_003
      ::ClearQFlag $player rested_xp_004
      ::ClearQFlag $player rested_xp_005
      ::ClearQFlag $player rested_xp_006
      ::ClearQFlag $player rested_xp_007
      ::ClearQFlag $player rested_xp_008
      ::ClearQFlag $player rested_xp_009
      ::ClearQFlag $player rested_xp_010
      ::ClearQFlag $player rested_xp_011
      ::ClearQFlag $player rested_xp_012
      ::ClearQFlag $player rested_xp_013
      ::ClearQFlag $player rested_xp_014
      ::ClearQFlag $player rested_xp_015
      ::ClearQFlag $player rested_xp_016
      ::ClearQFlag $player rested_xp_017
      ::ClearQFlag $player rested_xp_018
      ::ClearQFlag $player rested_xp_019
      ::ClearQFlag $player rested_xp_020
      ::ClearQFlag $player rested_xp_021
      ::ClearQFlag $player rested_xp_022
      ::ClearQFlag $player rested_xp_023
      ::ClearQFlag $player rested_xp_024
      ::ClearQFlag $player rested_xp_025
      ::ClearQFlag $player rested_xp_026
      ::ClearQFlag $player rested_xp_027
      ::ClearQFlag $player rested_xp_028
      ::ClearQFlag $player rested_xp_029
      ::ClearQFlag $player rested_xp_030
      ::ClearQFlag $player rested_xp_031
      ::ClearQFlag $player rested_xp_032
      ::ClearQFlag $player rested_xp_033
      ::ClearQFlag $player rested_xp_034
      ::ClearQFlag $player rested_xp_035
      ::ClearQFlag $player rested_xp_036
      ::ClearQFlag $player rested_xp_037
      ::ClearQFlag $player rested_xp_038
      ::ClearQFlag $player rested_xp_039
      ::ClearQFlag $player rested_xp_040
      ::ClearQFlag $player rested_xp_041
      ::ClearQFlag $player rested_xp_042
      ::ClearQFlag $player rested_xp_043
      ::ClearQFlag $player rested_xp_044
      ::ClearQFlag $player rested_xp_045
      ::ClearQFlag $player rested_xp_046
      ::ClearQFlag $player rested_xp_047
      ::ClearQFlag $player rested_xp_048
      ::ClearQFlag $player rested_xp_049
      ::ClearQFlag $player rested_xp_050
      ::ClearQFlag $player rested_xp_051
      ::ClearQFlag $player rested_xp_052
      ::ClearQFlag $player rested_xp_053
      ::ClearQFlag $player rested_xp_054
      ::ClearQFlag $player rested_xp_055
      ::ClearQFlag $player rested_xp_056
      ::ClearQFlag $player rested_xp_057
      ::ClearQFlag $player rested_xp_058
      ::ClearQFlag $player rested_xp_059
      ::ClearQFlag $player rested_xp_060
      ::ClearQFlag $player rested_xp_061
      ::ClearQFlag $player rested_xp_062
      ::ClearQFlag $player rested_xp_063
      ::ClearQFlag $player rested_xp_064
      ::ClearQFlag $player rested_xp_065
      ::ClearQFlag $player rested_xp_066
      ::ClearQFlag $player rested_xp_067
      ::ClearQFlag $player rested_xp_068
      ::ClearQFlag $player rested_xp_069
      ::ClearQFlag $player rested_xp_070
      ::ClearQFlag $player rested_xp_071
      ::ClearQFlag $player rested_xp_072
      ::ClearQFlag $player rested_xp_073
      ::ClearQFlag $player rested_xp_074
      ::ClearQFlag $player rested_xp_075
      ::ClearQFlag $player rested_xp_076
      ::ClearQFlag $player rested_xp_077
      ::ClearQFlag $player rested_xp_078
      ::ClearQFlag $player rested_xp_079
      ::ClearQFlag $player rested_xp_080
      ::ClearQFlag $player rested_xp_081
      ::ClearQFlag $player rested_xp_082
      ::ClearQFlag $player rested_xp_083
      ::ClearQFlag $player rested_xp_084
      ::ClearQFlag $player rested_xp_085
      ::ClearQFlag $player rested_xp_086
      ::ClearQFlag $player rested_xp_087
      ::ClearQFlag $player rested_xp_088
      ::ClearQFlag $player rested_xp_089
      ::ClearQFlag $player rested_xp_090
      ::ClearQFlag $player rested_xp_091
      ::ClearQFlag $player rested_xp_092
      ::ClearQFlag $player rested_xp_093
      ::ClearQFlag $player rested_xp_094
      ::ClearQFlag $player rested_xp_095
      ::ClearQFlag $player rested_xp_096
      ::ClearQFlag $player rested_xp_097
      ::ClearQFlag $player rested_xp_098
      ::ClearQFlag $player rested_xp_099
      ::ClearQFlag $player rested_xp_100
      ::ClearQFlag $player rested_xp_101
      ::ClearQFlag $player rested_xp_102
      ::ClearQFlag $player rested_xp_103
      ::ClearQFlag $player rested_xp_104
      ::ClearQFlag $player rested_xp_105
      ::ClearQFlag $player rested_xp_106
      ::ClearQFlag $player rested_xp_107
      ::ClearQFlag $player rested_xp_108
      ::ClearQFlag $player rested_xp_109
      ::ClearQFlag $player rested_xp_110
      ::ClearQFlag $player rested_xp_111
      ::ClearQFlag $player rested_xp_112
      ::ClearQFlag $player rested_xp_113
      ::ClearQFlag $player rested_xp_114
      ::ClearQFlag $player rested_xp_115
      ::ClearQFlag $player rested_xp_116
      ::ClearQFlag $player rested_xp_117
      ::ClearQFlag $player rested_xp_118
      ::ClearQFlag $player rested_xp_119
      ::ClearQFlag $player rested_xp_120
      ::ClearQFlag $player rested_xp_121
      ::ClearQFlag $player rested_xp_122
      ::ClearQFlag $player rested_xp_123
      ::ClearQFlag $player rested_xp_124
      ::ClearQFlag $player rested_xp_125
      ::ClearQFlag $player rested_xp_126
      ::ClearQFlag $player rested_xp_127
      ::ClearQFlag $player rested_xp_128
      ::ClearQFlag $player rested_xp_129
      ::ClearQFlag $player rested_xp_130
      ::ClearQFlag $player rested_xp_131
      ::ClearQFlag $player rested_xp_132
      ::ClearQFlag $player rested_xp_133
      ::ClearQFlag $player rested_xp_134
      ::ClearQFlag $player rested_xp_135
      ::ClearQFlag $player rested_xp_136
      ::ClearQFlag $player rested_xp_137
      ::ClearQFlag $player rested_xp_138
      ::ClearQFlag $player rested_xp_139
      ::ClearQFlag $player rested_xp_140
      ::ClearQFlag $player rested_xp_141
      ::ClearQFlag $player rested_xp_142
      ::ClearQFlag $player rested_xp_143
      ::ClearQFlag $player rested_xp_144
      ::ClearQFlag $player rested_xp_145
      ::ClearQFlag $player rested_xp_146
      ::ClearQFlag $player rested_xp_147
      ::ClearQFlag $player rested_xp_148
      ::ClearQFlag $player rested_xp_149
      ::ClearQFlag $player rested_xp_150
      ::ClearQFlag $player rested_xp_151
      ::ClearQFlag $player rested_xp_152
      ::ClearQFlag $player rested_xp_153
      ::ClearQFlag $player rested_xp_154
      ::ClearQFlag $player rested_xp_155
      ::ClearQFlag $player rested_xp_156
      ::ClearQFlag $player rested_xp_157
      ::ClearQFlag $player rested_xp_158
      ::ClearQFlag $player rested_xp_159
      ::ClearQFlag $player rested_xp_160
      ::ClearQFlag $player rested_xp_161
      ::ClearQFlag $player rested_xp_162
      ::ClearQFlag $player rested_xp_163
      ::ClearQFlag $player rested_xp_164
      ::ClearQFlag $player rested_xp_165
      ::ClearQFlag $player rested_xp_166
      ::ClearQFlag $player rested_xp_167
      ::ClearQFlag $player rested_xp_168
      ::ClearQFlag $player rested_xp_169
      ::ClearQFlag $player rested_xp_170
      ::ClearQFlag $player rested_xp_171
      ::ClearQFlag $player rested_xp_172
      ::ClearQFlag $player rested_xp_173
      ::ClearQFlag $player rested_xp_174
      ::ClearQFlag $player rested_xp_175
      ::ClearQFlag $player rested_xp_176
      ::ClearQFlag $player rested_xp_177
      ::ClearQFlag $player rested_xp_178
      ::ClearQFlag $player rested_xp_179
      ::ClearQFlag $player rested_xp_180
    }
    set exist [reststate eval {SELECT `name` FROM `reststate` WHERE (`name` = $pname)}]
    if {$exist != ""} {
      reststate eval {UPDATE `reststate` set `name` = $pname, `level` = $plevel, `time` = $timenow, `x`= $x, `y` = $y, `z` = $z WHERE (`name` = $pname)}
    } else {reststate eval {INSERT INTO `reststate` (`name`, `level`, `time`, `x`, `y`, `z`) VALUES ($pname, $plevel, $timenow, $x, $y, $z)}}
    ::SetQFlag $player resting
    Say $player 0 "|cFFFFFF00RESTING_ON|r"
  }
  proc restxpcount {player} {
    variable restlvlreset
    variable resttimefull
    set pname [::GetName $player]
    set plevel [::GetLevel $player]
    set rested_xp_001 [::GetQFlag $player rested_xp_001]
    set rested_xp_002 [::GetQFlag $player rested_xp_002]
    set rested_xp_003 [::GetQFlag $player rested_xp_003]
    set rested_xp_004 [::GetQFlag $player rested_xp_004]
    set rested_xp_005 [::GetQFlag $player rested_xp_005]
    set rested_xp_006 [::GetQFlag $player rested_xp_006]
    set rested_xp_007 [::GetQFlag $player rested_xp_007]
    set rested_xp_008 [::GetQFlag $player rested_xp_008]
    set rested_xp_009 [::GetQFlag $player rested_xp_009]
    set rested_xp_010 [::GetQFlag $player rested_xp_010]
    set rested_xp_011 [::GetQFlag $player rested_xp_011]
    set rested_xp_012 [::GetQFlag $player rested_xp_012]
    set rested_xp_013 [::GetQFlag $player rested_xp_013]
    set rested_xp_014 [::GetQFlag $player rested_xp_014]
    set rested_xp_015 [::GetQFlag $player rested_xp_015]
    set rested_xp_016 [::GetQFlag $player rested_xp_016]
    set rested_xp_017 [::GetQFlag $player rested_xp_017]
    set rested_xp_018 [::GetQFlag $player rested_xp_018]
    set rested_xp_019 [::GetQFlag $player rested_xp_019]
    set rested_xp_020 [::GetQFlag $player rested_xp_020]
    set rested_xp_021 [::GetQFlag $player rested_xp_021]
    set rested_xp_022 [::GetQFlag $player rested_xp_022]
    set rested_xp_023 [::GetQFlag $player rested_xp_023]
    set rested_xp_024 [::GetQFlag $player rested_xp_024]
    set rested_xp_025 [::GetQFlag $player rested_xp_025]
    set rested_xp_026 [::GetQFlag $player rested_xp_026]
    set rested_xp_027 [::GetQFlag $player rested_xp_027]
    set rested_xp_028 [::GetQFlag $player rested_xp_028]
    set rested_xp_029 [::GetQFlag $player rested_xp_029]
    set rested_xp_030 [::GetQFlag $player rested_xp_030]
    set rested_xp_031 [::GetQFlag $player rested_xp_031]
    set rested_xp_032 [::GetQFlag $player rested_xp_032]
    set rested_xp_033 [::GetQFlag $player rested_xp_033]
    set rested_xp_034 [::GetQFlag $player rested_xp_034]
    set rested_xp_035 [::GetQFlag $player rested_xp_035]
    set rested_xp_036 [::GetQFlag $player rested_xp_036]
    set rested_xp_037 [::GetQFlag $player rested_xp_037]
    set rested_xp_038 [::GetQFlag $player rested_xp_038]
    set rested_xp_039 [::GetQFlag $player rested_xp_039]
    set rested_xp_040 [::GetQFlag $player rested_xp_040]
    set rested_xp_041 [::GetQFlag $player rested_xp_041]
    set rested_xp_042 [::GetQFlag $player rested_xp_042]
    set rested_xp_043 [::GetQFlag $player rested_xp_043]
    set rested_xp_044 [::GetQFlag $player rested_xp_044]
    set rested_xp_045 [::GetQFlag $player rested_xp_045]
    set rested_xp_046 [::GetQFlag $player rested_xp_046]
    set rested_xp_047 [::GetQFlag $player rested_xp_047]
    set rested_xp_048 [::GetQFlag $player rested_xp_048]
    set rested_xp_049 [::GetQFlag $player rested_xp_049]
    set rested_xp_050 [::GetQFlag $player rested_xp_050]
    set rested_xp_051 [::GetQFlag $player rested_xp_051]
    set rested_xp_052 [::GetQFlag $player rested_xp_052]
    set rested_xp_053 [::GetQFlag $player rested_xp_053]
    set rested_xp_054 [::GetQFlag $player rested_xp_054]
    set rested_xp_055 [::GetQFlag $player rested_xp_055]
    set rested_xp_056 [::GetQFlag $player rested_xp_056]
    set rested_xp_057 [::GetQFlag $player rested_xp_057]
    set rested_xp_058 [::GetQFlag $player rested_xp_058]
    set rested_xp_059 [::GetQFlag $player rested_xp_059]
    set rested_xp_060 [::GetQFlag $player rested_xp_060]
    set rested_xp_061 [::GetQFlag $player rested_xp_061]
    set rested_xp_062 [::GetQFlag $player rested_xp_062]
    set rested_xp_063 [::GetQFlag $player rested_xp_063]
    set rested_xp_064 [::GetQFlag $player rested_xp_064]
    set rested_xp_065 [::GetQFlag $player rested_xp_065]
    set rested_xp_066 [::GetQFlag $player rested_xp_066]
    set rested_xp_067 [::GetQFlag $player rested_xp_067]
    set rested_xp_068 [::GetQFlag $player rested_xp_068]
    set rested_xp_069 [::GetQFlag $player rested_xp_069]
    set rested_xp_070 [::GetQFlag $player rested_xp_070]
    set rested_xp_071 [::GetQFlag $player rested_xp_071]
    set rested_xp_072 [::GetQFlag $player rested_xp_072]
    set rested_xp_073 [::GetQFlag $player rested_xp_073]
    set rested_xp_074 [::GetQFlag $player rested_xp_074]
    set rested_xp_075 [::GetQFlag $player rested_xp_075]
    set rested_xp_076 [::GetQFlag $player rested_xp_076]
    set rested_xp_077 [::GetQFlag $player rested_xp_077]
    set rested_xp_078 [::GetQFlag $player rested_xp_078]
    set rested_xp_079 [::GetQFlag $player rested_xp_079]
    set rested_xp_080 [::GetQFlag $player rested_xp_080]
    set rested_xp_081 [::GetQFlag $player rested_xp_081]
    set rested_xp_082 [::GetQFlag $player rested_xp_082]
    set rested_xp_083 [::GetQFlag $player rested_xp_083]
    set rested_xp_084 [::GetQFlag $player rested_xp_084]
    set rested_xp_085 [::GetQFlag $player rested_xp_085]
    set rested_xp_086 [::GetQFlag $player rested_xp_086]
    set rested_xp_087 [::GetQFlag $player rested_xp_087]
    set rested_xp_088 [::GetQFlag $player rested_xp_088]
    set rested_xp_089 [::GetQFlag $player rested_xp_089]
    set rested_xp_090 [::GetQFlag $player rested_xp_090]
    set rested_xp_091 [::GetQFlag $player rested_xp_091]
    set rested_xp_092 [::GetQFlag $player rested_xp_092]
    set rested_xp_093 [::GetQFlag $player rested_xp_093]
    set rested_xp_094 [::GetQFlag $player rested_xp_094]
    set rested_xp_095 [::GetQFlag $player rested_xp_095]
    set rested_xp_096 [::GetQFlag $player rested_xp_096]
    set rested_xp_097 [::GetQFlag $player rested_xp_097]
    set rested_xp_098 [::GetQFlag $player rested_xp_098]
    set rested_xp_099 [::GetQFlag $player rested_xp_099]
    set rested_xp_100 [::GetQFlag $player rested_xp_100]
    set rested_xp_101 [::GetQFlag $player rested_xp_101]
    set rested_xp_102 [::GetQFlag $player rested_xp_102]
    set rested_xp_103 [::GetQFlag $player rested_xp_103]
    set rested_xp_104 [::GetQFlag $player rested_xp_104]
    set rested_xp_105 [::GetQFlag $player rested_xp_105]
    set rested_xp_106 [::GetQFlag $player rested_xp_106]
    set rested_xp_107 [::GetQFlag $player rested_xp_107]
    set rested_xp_108 [::GetQFlag $player rested_xp_108]
    set rested_xp_109 [::GetQFlag $player rested_xp_109]
    set rested_xp_110 [::GetQFlag $player rested_xp_110]
    set rested_xp_111 [::GetQFlag $player rested_xp_111]
    set rested_xp_112 [::GetQFlag $player rested_xp_112]
    set rested_xp_113 [::GetQFlag $player rested_xp_113]
    set rested_xp_114 [::GetQFlag $player rested_xp_114]
    set rested_xp_115 [::GetQFlag $player rested_xp_115]
    set rested_xp_116 [::GetQFlag $player rested_xp_116]
    set rested_xp_117 [::GetQFlag $player rested_xp_117]
    set rested_xp_118 [::GetQFlag $player rested_xp_118]
    set rested_xp_119 [::GetQFlag $player rested_xp_119]
    set rested_xp_120 [::GetQFlag $player rested_xp_120]
    set rested_xp_121 [::GetQFlag $player rested_xp_121]
    set rested_xp_122 [::GetQFlag $player rested_xp_122]
    set rested_xp_123 [::GetQFlag $player rested_xp_123]
    set rested_xp_124 [::GetQFlag $player rested_xp_124]
    set rested_xp_125 [::GetQFlag $player rested_xp_125]
    set rested_xp_126 [::GetQFlag $player rested_xp_126]
    set rested_xp_127 [::GetQFlag $player rested_xp_127]
    set rested_xp_128 [::GetQFlag $player rested_xp_128]
    set rested_xp_129 [::GetQFlag $player rested_xp_129]
    set rested_xp_130 [::GetQFlag $player rested_xp_130]
    set rested_xp_131 [::GetQFlag $player rested_xp_131]
    set rested_xp_132 [::GetQFlag $player rested_xp_132]
    set rested_xp_133 [::GetQFlag $player rested_xp_133]
    set rested_xp_134 [::GetQFlag $player rested_xp_134]
    set rested_xp_135 [::GetQFlag $player rested_xp_135]
    set rested_xp_136 [::GetQFlag $player rested_xp_136]
    set rested_xp_137 [::GetQFlag $player rested_xp_137]
    set rested_xp_138 [::GetQFlag $player rested_xp_138]
    set rested_xp_139 [::GetQFlag $player rested_xp_139]
    set rested_xp_140 [::GetQFlag $player rested_xp_140]
    set rested_xp_141 [::GetQFlag $player rested_xp_141]
    set rested_xp_142 [::GetQFlag $player rested_xp_142]
    set rested_xp_143 [::GetQFlag $player rested_xp_143]
    set rested_xp_144 [::GetQFlag $player rested_xp_144]
    set rested_xp_145 [::GetQFlag $player rested_xp_145]
    set rested_xp_146 [::GetQFlag $player rested_xp_146]
    set rested_xp_147 [::GetQFlag $player rested_xp_147]
    set rested_xp_148 [::GetQFlag $player rested_xp_148]
    set rested_xp_149 [::GetQFlag $player rested_xp_149]
    set rested_xp_150 [::GetQFlag $player rested_xp_150]
    set rested_xp_151 [::GetQFlag $player rested_xp_151]
    set rested_xp_152 [::GetQFlag $player rested_xp_152]
    set rested_xp_153 [::GetQFlag $player rested_xp_153]
    set rested_xp_154 [::GetQFlag $player rested_xp_154]
    set rested_xp_155 [::GetQFlag $player rested_xp_155]
    set rested_xp_156 [::GetQFlag $player rested_xp_156]
    set rested_xp_157 [::GetQFlag $player rested_xp_157]
    set rested_xp_158 [::GetQFlag $player rested_xp_158]
    set rested_xp_159 [::GetQFlag $player rested_xp_159]
    set rested_xp_160 [::GetQFlag $player rested_xp_160]
    set rested_xp_161 [::GetQFlag $player rested_xp_161]
    set rested_xp_162 [::GetQFlag $player rested_xp_162]
    set rested_xp_163 [::GetQFlag $player rested_xp_163]
    set rested_xp_164 [::GetQFlag $player rested_xp_164]
    set rested_xp_165 [::GetQFlag $player rested_xp_165]
    set rested_xp_166 [::GetQFlag $player rested_xp_166]
    set rested_xp_167 [::GetQFlag $player rested_xp_167]
    set rested_xp_168 [::GetQFlag $player rested_xp_168]
    set rested_xp_169 [::GetQFlag $player rested_xp_169]
    set rested_xp_170 [::GetQFlag $player rested_xp_170]
    set rested_xp_171 [::GetQFlag $player rested_xp_171]
    set rested_xp_172 [::GetQFlag $player rested_xp_172]
    set rested_xp_173 [::GetQFlag $player rested_xp_173]
    set rested_xp_174 [::GetQFlag $player rested_xp_174]
    set rested_xp_175 [::GetQFlag $player rested_xp_175]
    set rested_xp_176 [::GetQFlag $player rested_xp_176]
    set rested_xp_177 [::GetQFlag $player rested_xp_177]
    set rested_xp_178 [::GetQFlag $player rested_xp_178]
    set rested_xp_179 [::GetQFlag $player rested_xp_179]
    set rested_xp_180 [::GetQFlag $player rested_xp_180]
    if {[::GetQFlag $player resting]} {
      set timenow [clock seconds]
      set read [reststate eval {SELECT `level`, `time` FROM `reststate` WHERE (`name` LIKE $pname)}]
      set levelold [lindex $read 0]
      set timeold [lindex $read 1]
      if {$levelold == "" && $timeold == ""} {
        ::ClearQFlag $player resting
        ::ClearQFlag $player rested
        return 0
      }
      if {$restlvlreset != 0} {
        if {$levelold != "" && $plevel != $levelold} {set timeold $timenow}
      }
      set timebubble [expr {int($resttimefull/30)}]
      set timerest [expr {$timenow - $timeold}]
      set bubble_rested [expr {int($timerest/$timebubble)}]
      if {$bubble_rested < 0} {set $bubble_rested 0}
      if {$bubble_rested >= 30} {set $bubble_rested 30}
      set bubble 0
      if {$plevel < 10} {
        if {$rested_xp_001 == 1} {set bubble 1}
        if {$rested_xp_002 == 1} {set bubble 2}
        if {$rested_xp_003 == 1} {set bubble 3}
        if {$rested_xp_004 == 1} {set bubble 4}
        if {$rested_xp_005 == 1} {set bubble 5}
        if {$rested_xp_006 == 1} {set bubble 6}
        if {$rested_xp_007 == 1} {set bubble 7}
        if {$rested_xp_008 == 1} {set bubble 8}
        if {$rested_xp_009 == 1} {set bubble 9}
        if {$rested_xp_010 == 1} {set bubble 10}
        if {$rested_xp_011 == 1} {set bubble 11}
        if {$rested_xp_012 == 1} {set bubble 12}
        if {$rested_xp_013 == 1} {set bubble 13}
        if {$rested_xp_014 == 1} {set bubble 14}
        if {$rested_xp_015 == 1} {set bubble 15}
        if {$rested_xp_016 == 1} {set bubble 16}
        if {$rested_xp_017 == 1} {set bubble 17}
        if {$rested_xp_018 == 1} {set bubble 18}
        if {$rested_xp_019 == 1} {set bubble 19}
        if {$rested_xp_020 == 1} {set bubble 20}
        if {$rested_xp_021 == 1} {set bubble 21}
        if {$rested_xp_022 == 1} {set bubble 22}
        if {$rested_xp_023 == 1} {set bubble 23}
        if {$rested_xp_024 == 1} {set bubble 24}
        if {$rested_xp_025 == 1} {set bubble 25}
        if {$rested_xp_026 == 1} {set bubble 26}
        if {$rested_xp_027 == 1} {set bubble 27}
        if {$rested_xp_028 == 1} {set bubble 28}
        if {$rested_xp_029 == 1} {set bubble 29}
        if {$rested_xp_030 == 1} {set bubble 30}
      }
      if {$plevel >= 10 && $plevel < 20} {
        if {$rested_xp_002 == 1 || $rested_xp_001 == 1} {set bubble 1}
        if {$rested_xp_004 == 1 || $rested_xp_003 == 1} {set bubble 2}
        if {$rested_xp_006 == 1 || $rested_xp_005 == 1} {set bubble 3}
        if {$rested_xp_008 == 1 || $rested_xp_007 == 1} {set bubble 4}
        if {$rested_xp_010 == 1 || $rested_xp_009 == 1} {set bubble 5}
        if {$rested_xp_012 == 1 || $rested_xp_011 == 1} {set bubble 6}
        if {$rested_xp_014 == 1 || $rested_xp_013 == 1} {set bubble 7}
        if {$rested_xp_016 == 1 || $rested_xp_015 == 1} {set bubble 8}
        if {$rested_xp_018 == 1 || $rested_xp_017 == 1} {set bubble 9}
        if {$rested_xp_020 == 1 || $rested_xp_019 == 1} {set bubble 10}
        if {$rested_xp_022 == 1 || $rested_xp_021 == 1} {set bubble 11}
        if {$rested_xp_024 == 1 || $rested_xp_023 == 1} {set bubble 12}
        if {$rested_xp_026 == 1 || $rested_xp_025 == 1} {set bubble 13}
        if {$rested_xp_028 == 1 || $rested_xp_027 == 1} {set bubble 14}
        if {$rested_xp_030 == 1 || $rested_xp_029 == 1} {set bubble 15}
        if {$rested_xp_032 == 1 || $rested_xp_031 == 1} {set bubble 16}
        if {$rested_xp_034 == 1 || $rested_xp_033 == 1} {set bubble 17}
        if {$rested_xp_036 == 1 || $rested_xp_035 == 1} {set bubble 18}
        if {$rested_xp_038 == 1 || $rested_xp_037 == 1} {set bubble 19}
        if {$rested_xp_040 == 1 || $rested_xp_039 == 1} {set bubble 20}
        if {$rested_xp_042 == 1 || $rested_xp_041 == 1} {set bubble 21}
        if {$rested_xp_044 == 1 || $rested_xp_043 == 1} {set bubble 22}
        if {$rested_xp_046 == 1 || $rested_xp_045 == 1} {set bubble 23}
        if {$rested_xp_048 == 1 || $rested_xp_047 == 1} {set bubble 24}
        if {$rested_xp_050 == 1 || $rested_xp_049 == 1} {set bubble 25}
        if {$rested_xp_052 == 1 || $rested_xp_051 == 1} {set bubble 26}
        if {$rested_xp_054 == 1 || $rested_xp_053 == 1} {set bubble 27}
        if {$rested_xp_056 == 1 || $rested_xp_055 == 1} {set bubble 28}
        if {$rested_xp_058 == 1 || $rested_xp_057 == 1} {set bubble 29}
        if {$rested_xp_060 == 1 || $rested_xp_059 == 1} {set bubble 30}
      }
      if {$plevel >= 20 && $plevel < 30} {
        if {$rested_xp_003 == 1 || $rested_xp_002 == 1 || $rested_xp_001 == 1} {set bubble 1}
        if {$rested_xp_006 == 1 || $rested_xp_005 == 1 || $rested_xp_004 == 1} {set bubble 2}
        if {$rested_xp_009 == 1 || $rested_xp_008 == 1 || $rested_xp_007 == 1} {set bubble 3}
        if {$rested_xp_012 == 1 || $rested_xp_011 == 1 || $rested_xp_010 == 1} {set bubble 4}
        if {$rested_xp_015 == 1 || $rested_xp_014 == 1 || $rested_xp_013 == 1} {set bubble 5}
        if {$rested_xp_018 == 1 || $rested_xp_017 == 1 || $rested_xp_016 == 1} {set bubble 6}
        if {$rested_xp_021 == 1 || $rested_xp_020 == 1 || $rested_xp_019 == 1} {set bubble 7}
        if {$rested_xp_024 == 1 || $rested_xp_023 == 1 || $rested_xp_022 == 1} {set bubble 8}
        if {$rested_xp_027 == 1 || $rested_xp_026 == 1 || $rested_xp_025 == 1} {set bubble 9}
        if {$rested_xp_030 == 1 || $rested_xp_029 == 1 || $rested_xp_028 == 1} {set bubble 10}
        if {$rested_xp_033 == 1 || $rested_xp_032 == 1 || $rested_xp_031 == 1} {set bubble 11}
        if {$rested_xp_036 == 1 || $rested_xp_035 == 1 || $rested_xp_034 == 1} {set bubble 12}
        if {$rested_xp_039 == 1 || $rested_xp_038 == 1 || $rested_xp_037 == 1} {set bubble 13}
        if {$rested_xp_042 == 1 || $rested_xp_041 == 1 || $rested_xp_040 == 1} {set bubble 14}
        if {$rested_xp_045 == 1 || $rested_xp_044 == 1 || $rested_xp_043 == 1} {set bubble 15}
        if {$rested_xp_048 == 1 || $rested_xp_047 == 1 || $rested_xp_046 == 1} {set bubble 16}
        if {$rested_xp_051 == 1 || $rested_xp_050 == 1 || $rested_xp_049 == 1} {set bubble 17}
        if {$rested_xp_054 == 1 || $rested_xp_053 == 1 || $rested_xp_052 == 1} {set bubble 18}
        if {$rested_xp_057 == 1 || $rested_xp_056 == 1 || $rested_xp_055 == 1} {set bubble 19}
        if {$rested_xp_060 == 1 || $rested_xp_059 == 1 || $rested_xp_058 == 1} {set bubble 20}
        if {$rested_xp_063 == 1 || $rested_xp_062 == 1 || $rested_xp_061 == 1} {set bubble 21}
        if {$rested_xp_066 == 1 || $rested_xp_065 == 1 || $rested_xp_064 == 1} {set bubble 22}
        if {$rested_xp_069 == 1 || $rested_xp_068 == 1 || $rested_xp_067 == 1} {set bubble 23}
        if {$rested_xp_072 == 1 || $rested_xp_071 == 1 || $rested_xp_070 == 1} {set bubble 24}
        if {$rested_xp_075 == 1 || $rested_xp_074 == 1 || $rested_xp_073 == 1} {set bubble 25}
        if {$rested_xp_078 == 1 || $rested_xp_077 == 1 || $rested_xp_076 == 1} {set bubble 26}
        if {$rested_xp_081 == 1 || $rested_xp_080 == 1 || $rested_xp_079 == 1} {set bubble 27}
        if {$rested_xp_084 == 1 || $rested_xp_083 == 1 || $rested_xp_082 == 1} {set bubble 28}
        if {$rested_xp_087 == 1 || $rested_xp_086 == 1 || $rested_xp_085 == 1} {set bubble 29}
        if {$rested_xp_090 == 1 || $rested_xp_089 == 1 || $rested_xp_088 == 1} {set bubble 30}
      }
      if {$plevel >= 30 && $plevel < 40} {
        if {$rested_xp_004 == 1 || $rested_xp_003 == 1 || $rested_xp_002 == 1 || $rested_xp_001 == 1} {set bubble 1}
        if {$rested_xp_008 == 1 || $rested_xp_007 == 1 || $rested_xp_006 == 1 || $rested_xp_005 == 1} {set bubble 2}
        if {$rested_xp_012 == 1 || $rested_xp_011 == 1 || $rested_xp_010 == 1 || $rested_xp_009 == 1} {set bubble 3}
        if {$rested_xp_016 == 1 || $rested_xp_015 == 1 || $rested_xp_014 == 1 || $rested_xp_013 == 1} {set bubble 4}
        if {$rested_xp_020 == 1 || $rested_xp_019 == 1 || $rested_xp_018 == 1 || $rested_xp_017 == 1} {set bubble 5}
        if {$rested_xp_024 == 1 || $rested_xp_023 == 1 || $rested_xp_022 == 1 || $rested_xp_021 == 1} {set bubble 6}
        if {$rested_xp_028 == 1 || $rested_xp_027 == 1 || $rested_xp_026 == 1 || $rested_xp_025 == 1} {set bubble 7}
        if {$rested_xp_032 == 1 || $rested_xp_031 == 1 || $rested_xp_030 == 1 || $rested_xp_029 == 1} {set bubble 8}
        if {$rested_xp_036 == 1 || $rested_xp_035 == 1 || $rested_xp_034 == 1 || $rested_xp_033 == 1} {set bubble 9}
        if {$rested_xp_040 == 1 || $rested_xp_039 == 1 || $rested_xp_038 == 1 || $rested_xp_037 == 1} {set bubble 10}
        if {$rested_xp_044 == 1 || $rested_xp_043 == 1 || $rested_xp_042 == 1 || $rested_xp_041 == 1} {set bubble 11}
        if {$rested_xp_048 == 1 || $rested_xp_047 == 1 || $rested_xp_046 == 1 || $rested_xp_045 == 1} {set bubble 12}
        if {$rested_xp_052 == 1 || $rested_xp_051 == 1 || $rested_xp_050 == 1 || $rested_xp_049 == 1} {set bubble 13}
        if {$rested_xp_056 == 1 || $rested_xp_055 == 1 || $rested_xp_054 == 1 || $rested_xp_053 == 1} {set bubble 14}
        if {$rested_xp_060 == 1 || $rested_xp_059 == 1 || $rested_xp_058 == 1 || $rested_xp_057 == 1} {set bubble 15}
        if {$rested_xp_064 == 1 || $rested_xp_063 == 1 || $rested_xp_062 == 1 || $rested_xp_061 == 1} {set bubble 16}
        if {$rested_xp_068 == 1 || $rested_xp_067 == 1 || $rested_xp_066 == 1 || $rested_xp_065 == 1} {set bubble 17}
        if {$rested_xp_072 == 1 || $rested_xp_071 == 1 || $rested_xp_070 == 1 || $rested_xp_069 == 1} {set bubble 18}
        if {$rested_xp_076 == 1 || $rested_xp_075 == 1 || $rested_xp_074 == 1 || $rested_xp_073 == 1} {set bubble 19}
        if {$rested_xp_080 == 1 || $rested_xp_079 == 1 || $rested_xp_078 == 1 || $rested_xp_077 == 1} {set bubble 20}
        if {$rested_xp_084 == 1 || $rested_xp_083 == 1 || $rested_xp_082 == 1 || $rested_xp_081 == 1} {set bubble 21}
        if {$rested_xp_088 == 1 || $rested_xp_087 == 1 || $rested_xp_086 == 1 || $rested_xp_085 == 1} {set bubble 22}
        if {$rested_xp_092 == 1 || $rested_xp_091 == 1 || $rested_xp_090 == 1 || $rested_xp_089 == 1} {set bubble 23}
        if {$rested_xp_096 == 1 || $rested_xp_095 == 1 || $rested_xp_094 == 1 || $rested_xp_093 == 1} {set bubble 24}
        if {$rested_xp_100 == 1 || $rested_xp_099 == 1 || $rested_xp_098 == 1 || $rested_xp_097 == 1} {set bubble 25}
        if {$rested_xp_104 == 1 || $rested_xp_103 == 1 || $rested_xp_102 == 1 || $rested_xp_101 == 1} {set bubble 26}
        if {$rested_xp_108 == 1 || $rested_xp_107 == 1 || $rested_xp_106 == 1 || $rested_xp_105 == 1} {set bubble 27}
        if {$rested_xp_112 == 1 || $rested_xp_111 == 1 || $rested_xp_110 == 1 || $rested_xp_109 == 1} {set bubble 28}
        if {$rested_xp_116 == 1 || $rested_xp_115 == 1 || $rested_xp_114 == 1 || $rested_xp_113 == 1} {set bubble 29}
        if {$rested_xp_120 == 1 || $rested_xp_119 == 1 || $rested_xp_118 == 1 || $rested_xp_117 == 1} {set bubble 30}
      }
      if {$plevel >= 40 && $plevel < 50} {
        if {$rested_xp_005 == 1 || $rested_xp_004 == 1 || $rested_xp_003 == 1 || $rested_xp_002 == 1 || $rested_xp_001 == 1} {set bubble 1}
        if {$rested_xp_010 == 1 || $rested_xp_009 == 1 || $rested_xp_008 == 1 || $rested_xp_007 == 1 || $rested_xp_006 == 1} {set bubble 2}
        if {$rested_xp_015 == 1 || $rested_xp_014 == 1 || $rested_xp_013 == 1 || $rested_xp_012 == 1 || $rested_xp_011 == 1} {set bubble 3}
        if {$rested_xp_020 == 1 || $rested_xp_019 == 1 || $rested_xp_018 == 1 || $rested_xp_017 == 1 || $rested_xp_016 == 1} {set bubble 4}
        if {$rested_xp_025 == 1 || $rested_xp_024 == 1 || $rested_xp_023 == 1 || $rested_xp_022 == 1 || $rested_xp_021 == 1} {set bubble 5}
        if {$rested_xp_030 == 1 || $rested_xp_029 == 1 || $rested_xp_028 == 1 || $rested_xp_027 == 1 || $rested_xp_026 == 1} {set bubble 6}
        if {$rested_xp_035 == 1 || $rested_xp_034 == 1 || $rested_xp_033 == 1 || $rested_xp_032 == 1 || $rested_xp_031 == 1} {set bubble 7}
        if {$rested_xp_040 == 1 || $rested_xp_039 == 1 || $rested_xp_038 == 1 || $rested_xp_037 == 1 || $rested_xp_036 == 1} {set bubble 8}
        if {$rested_xp_045 == 1 || $rested_xp_044 == 1 || $rested_xp_043 == 1 || $rested_xp_042 == 1 || $rested_xp_041 == 1} {set bubble 9}
        if {$rested_xp_050 == 1 || $rested_xp_049 == 1 || $rested_xp_048 == 1 || $rested_xp_047 == 1 || $rested_xp_046 == 1} {set bubble 10}
        if {$rested_xp_055 == 1 || $rested_xp_054 == 1 || $rested_xp_053 == 1 || $rested_xp_052 == 1 || $rested_xp_051 == 1} {set bubble 11}
        if {$rested_xp_060 == 1 || $rested_xp_059 == 1 || $rested_xp_058 == 1 || $rested_xp_057 == 1 || $rested_xp_056 == 1} {set bubble 12}
        if {$rested_xp_065 == 1 || $rested_xp_064 == 1 || $rested_xp_063 == 1 || $rested_xp_062 == 1 || $rested_xp_061 == 1} {set bubble 13}
        if {$rested_xp_070 == 1 || $rested_xp_069 == 1 || $rested_xp_068 == 1 || $rested_xp_067 == 1 || $rested_xp_066 == 1} {set bubble 14}
        if {$rested_xp_075 == 1 || $rested_xp_074 == 1 || $rested_xp_073 == 1 || $rested_xp_072 == 1 || $rested_xp_071 == 1} {set bubble 15}
        if {$rested_xp_080 == 1 || $rested_xp_079 == 1 || $rested_xp_078 == 1 || $rested_xp_077 == 1 || $rested_xp_076 == 1} {set bubble 16}
        if {$rested_xp_085 == 1 || $rested_xp_084 == 1 || $rested_xp_083 == 1 || $rested_xp_082 == 1 || $rested_xp_081 == 1} {set bubble 17}
        if {$rested_xp_090 == 1 || $rested_xp_089 == 1 || $rested_xp_088 == 1 || $rested_xp_087 == 1 || $rested_xp_086 == 1} {set bubble 18}
        if {$rested_xp_095 == 1 || $rested_xp_094 == 1 || $rested_xp_093 == 1 || $rested_xp_092 == 1 || $rested_xp_091 == 1} {set bubble 19}
        if {$rested_xp_100 == 1 || $rested_xp_099 == 1 || $rested_xp_098 == 1 || $rested_xp_097 == 1 || $rested_xp_096 == 1} {set bubble 20}
        if {$rested_xp_105 == 1 || $rested_xp_104 == 1 || $rested_xp_103 == 1 || $rested_xp_102 == 1 || $rested_xp_101 == 1} {set bubble 21}
        if {$rested_xp_110 == 1 || $rested_xp_109 == 1 || $rested_xp_108 == 1 || $rested_xp_107 == 1 || $rested_xp_106 == 1} {set bubble 22}
        if {$rested_xp_115 == 1 || $rested_xp_114 == 1 || $rested_xp_113 == 1 || $rested_xp_112 == 1 || $rested_xp_111 == 1} {set bubble 23}
        if {$rested_xp_120 == 1 || $rested_xp_119 == 1 || $rested_xp_118 == 1 || $rested_xp_117 == 1 || $rested_xp_116 == 1} {set bubble 24}
        if {$rested_xp_125 == 1 || $rested_xp_124 == 1 || $rested_xp_123 == 1 || $rested_xp_122 == 1 || $rested_xp_121 == 1} {set bubble 25}
        if {$rested_xp_130 == 1 || $rested_xp_129 == 1 || $rested_xp_128 == 1 || $rested_xp_127 == 1 || $rested_xp_126 == 1} {set bubble 26}
        if {$rested_xp_135 == 1 || $rested_xp_134 == 1 || $rested_xp_133 == 1 || $rested_xp_132 == 1 || $rested_xp_131 == 1} {set bubble 27}
        if {$rested_xp_140 == 1 || $rested_xp_139 == 1 || $rested_xp_138 == 1 || $rested_xp_137 == 1 || $rested_xp_136 == 1} {set bubble 28}
        if {$rested_xp_145 == 1 || $rested_xp_144 == 1 || $rested_xp_143 == 1 || $rested_xp_142 == 1 || $rested_xp_141 == 1} {set bubble 29}
        if {$rested_xp_150 == 1 || $rested_xp_149 == 1 || $rested_xp_148 == 1 || $rested_xp_147 == 1 || $rested_xp_146 == 1} {set bubble 30}
      }
      if {$plevel >= 50} {
        if {$rested_xp_006 == 1 || $rested_xp_005 == 1 || $rested_xp_004 == 1 || $rested_xp_003 == 1 || $rested_xp_002 == 1 || $rested_xp_001 == 1} {set bubble 1}
        if {$rested_xp_012 == 1 || $rested_xp_011 == 1 || $rested_xp_010 == 1 || $rested_xp_009 == 1 || $rested_xp_008 == 1 || $rested_xp_007 == 1} {set bubble 2}
        if {$rested_xp_018 == 1 || $rested_xp_017 == 1 || $rested_xp_016 == 1 || $rested_xp_015 == 1 || $rested_xp_014 == 1 || $rested_xp_013 == 1} {set bubble 3}
        if {$rested_xp_024 == 1 || $rested_xp_023 == 1 || $rested_xp_022 == 1 || $rested_xp_021 == 1 || $rested_xp_020 == 1 || $rested_xp_019 == 1} {set bubble 4}
        if {$rested_xp_030 == 1 || $rested_xp_029 == 1 || $rested_xp_028 == 1 || $rested_xp_027 == 1 || $rested_xp_026 == 1 || $rested_xp_025 == 1} {set bubble 5}
        if {$rested_xp_036 == 1 || $rested_xp_035 == 1 || $rested_xp_034 == 1 || $rested_xp_033 == 1 || $rested_xp_032 == 1 || $rested_xp_031 == 1} {set bubble 6}
        if {$rested_xp_042 == 1 || $rested_xp_041 == 1 || $rested_xp_040 == 1 || $rested_xp_039 == 1 || $rested_xp_038 == 1 || $rested_xp_037 == 1} {set bubble 7}
        if {$rested_xp_048 == 1 || $rested_xp_047 == 1 || $rested_xp_046 == 1 || $rested_xp_045 == 1 || $rested_xp_044 == 1 || $rested_xp_043 == 1} {set bubble 8}
        if {$rested_xp_054 == 1 || $rested_xp_053 == 1 || $rested_xp_052 == 1 || $rested_xp_051 == 1 || $rested_xp_050 == 1 || $rested_xp_049 == 1} {set bubble 9}
        if {$rested_xp_060 == 1 || $rested_xp_059 == 1 || $rested_xp_058 == 1 || $rested_xp_057 == 1 || $rested_xp_056 == 1 || $rested_xp_055 == 1} {set bubble 10}
        if {$rested_xp_066 == 1 || $rested_xp_065 == 1 || $rested_xp_064 == 1 || $rested_xp_063 == 1 || $rested_xp_062 == 1 || $rested_xp_061 == 1} {set bubble 11}
        if {$rested_xp_072 == 1 || $rested_xp_071 == 1 || $rested_xp_070 == 1 || $rested_xp_069 == 1 || $rested_xp_068 == 1 || $rested_xp_067 == 1} {set bubble 12}
        if {$rested_xp_078 == 1 || $rested_xp_077 == 1 || $rested_xp_076 == 1 || $rested_xp_075 == 1 || $rested_xp_074 == 1 || $rested_xp_073 == 1} {set bubble 13}
        if {$rested_xp_084 == 1 || $rested_xp_083 == 1 || $rested_xp_082 == 1 || $rested_xp_081 == 1 || $rested_xp_080 == 1 || $rested_xp_079 == 1} {set bubble 14}
        if {$rested_xp_090 == 1 || $rested_xp_089 == 1 || $rested_xp_088 == 1 || $rested_xp_087 == 1 || $rested_xp_086 == 1 || $rested_xp_085 == 1} {set bubble 15}
        if {$rested_xp_096 == 1 || $rested_xp_095 == 1 || $rested_xp_094 == 1 || $rested_xp_093 == 1 || $rested_xp_092 == 1 || $rested_xp_091 == 1} {set bubble 16}
        if {$rested_xp_102 == 1 || $rested_xp_101 == 1 || $rested_xp_100 == 1 || $rested_xp_099 == 1 || $rested_xp_098 == 1 || $rested_xp_097 == 1} {set bubble 17}
        if {$rested_xp_108 == 1 || $rested_xp_107 == 1 || $rested_xp_106 == 1 || $rested_xp_105 == 1 || $rested_xp_104 == 1 || $rested_xp_103 == 1} {set bubble 18}
        if {$rested_xp_114 == 1 || $rested_xp_113 == 1 || $rested_xp_112 == 1 || $rested_xp_111 == 1 || $rested_xp_110 == 1 || $rested_xp_109 == 1} {set bubble 19}
        if {$rested_xp_120 == 1 || $rested_xp_119 == 1 || $rested_xp_118 == 1 || $rested_xp_117 == 1 || $rested_xp_116 == 1 || $rested_xp_115 == 1} {set bubble 20}
        if {$rested_xp_126 == 1 || $rested_xp_125 == 1 || $rested_xp_124 == 1 || $rested_xp_123 == 1 || $rested_xp_122 == 1 || $rested_xp_121 == 1} {set bubble 21}
        if {$rested_xp_132 == 1 || $rested_xp_131 == 1 || $rested_xp_130 == 1 || $rested_xp_129 == 1 || $rested_xp_128 == 1 || $rested_xp_127 == 1} {set bubble 22}
        if {$rested_xp_138 == 1 || $rested_xp_137 == 1 || $rested_xp_136 == 1 || $rested_xp_135 == 1 || $rested_xp_134 == 1 || $rested_xp_133 == 1} {set bubble 23}
        if {$rested_xp_144 == 1 || $rested_xp_143 == 1 || $rested_xp_142 == 1 || $rested_xp_141 == 1 || $rested_xp_140 == 1 || $rested_xp_139 == 1} {set bubble 24}
        if {$rested_xp_150 == 1 || $rested_xp_149 == 1 || $rested_xp_148 == 1 || $rested_xp_147 == 1 || $rested_xp_146 == 1 || $rested_xp_145 == 1} {set bubble 25}
        if {$rested_xp_156 == 1 || $rested_xp_155 == 1 || $rested_xp_154 == 1 || $rested_xp_153 == 1 || $rested_xp_152 == 1 || $rested_xp_151 == 1} {set bubble 26}
        if {$rested_xp_162 == 1 || $rested_xp_161 == 1 || $rested_xp_160 == 1 || $rested_xp_159 == 1 || $rested_xp_158 == 1 || $rested_xp_157 == 1} {set bubble 27}
        if {$rested_xp_168 == 1 || $rested_xp_167 == 1 || $rested_xp_166 == 1 || $rested_xp_165 == 1 || $rested_xp_164 == 1 || $rested_xp_163 == 1} {set bubble 28}
        if {$rested_xp_174 == 1 || $rested_xp_173 == 1 || $rested_xp_172 == 1 || $rested_xp_171 == 1 || $rested_xp_170 == 1 || $rested_xp_169 == 1} {set bubble 29}
        if {$rested_xp_180 == 1 || $rested_xp_179 == 1 || $rested_xp_178 == 1 || $rested_xp_177 == 1 || $rested_xp_176 == 1 || $rested_xp_175 == 1} {set bubble 30}
      }
      set bubble [expr {int($bubble_rested + $bubble)}]
      if {$bubble < 0} {set bubble 0}
      if {$bubble >= 30} {set bubble 30}
      ::ClearQFlag $player rested_xp_001
      ::ClearQFlag $player rested_xp_002
      ::ClearQFlag $player rested_xp_003
      ::ClearQFlag $player rested_xp_004
      ::ClearQFlag $player rested_xp_005
      ::ClearQFlag $player rested_xp_006
      ::ClearQFlag $player rested_xp_007
      ::ClearQFlag $player rested_xp_008
      ::ClearQFlag $player rested_xp_009
      ::ClearQFlag $player rested_xp_010
      ::ClearQFlag $player rested_xp_011
      ::ClearQFlag $player rested_xp_012
      ::ClearQFlag $player rested_xp_013
      ::ClearQFlag $player rested_xp_014
      ::ClearQFlag $player rested_xp_015
      ::ClearQFlag $player rested_xp_016
      ::ClearQFlag $player rested_xp_017
      ::ClearQFlag $player rested_xp_018
      ::ClearQFlag $player rested_xp_019
      ::ClearQFlag $player rested_xp_020
      ::ClearQFlag $player rested_xp_021
      ::ClearQFlag $player rested_xp_022
      ::ClearQFlag $player rested_xp_023
      ::ClearQFlag $player rested_xp_024
      ::ClearQFlag $player rested_xp_025
      ::ClearQFlag $player rested_xp_026
      ::ClearQFlag $player rested_xp_027
      ::ClearQFlag $player rested_xp_028
      ::ClearQFlag $player rested_xp_029
      ::ClearQFlag $player rested_xp_030
      ::ClearQFlag $player rested_xp_031
      ::ClearQFlag $player rested_xp_032
      ::ClearQFlag $player rested_xp_033
      ::ClearQFlag $player rested_xp_034
      ::ClearQFlag $player rested_xp_035
      ::ClearQFlag $player rested_xp_036
      ::ClearQFlag $player rested_xp_037
      ::ClearQFlag $player rested_xp_038
      ::ClearQFlag $player rested_xp_039
      ::ClearQFlag $player rested_xp_040
      ::ClearQFlag $player rested_xp_041
      ::ClearQFlag $player rested_xp_042
      ::ClearQFlag $player rested_xp_043
      ::ClearQFlag $player rested_xp_044
      ::ClearQFlag $player rested_xp_045
      ::ClearQFlag $player rested_xp_046
      ::ClearQFlag $player rested_xp_047
      ::ClearQFlag $player rested_xp_048
      ::ClearQFlag $player rested_xp_049
      ::ClearQFlag $player rested_xp_050
      ::ClearQFlag $player rested_xp_051
      ::ClearQFlag $player rested_xp_052
      ::ClearQFlag $player rested_xp_053
      ::ClearQFlag $player rested_xp_054
      ::ClearQFlag $player rested_xp_055
      ::ClearQFlag $player rested_xp_056
      ::ClearQFlag $player rested_xp_057
      ::ClearQFlag $player rested_xp_058
      ::ClearQFlag $player rested_xp_059
      ::ClearQFlag $player rested_xp_060
      ::ClearQFlag $player rested_xp_061
      ::ClearQFlag $player rested_xp_062
      ::ClearQFlag $player rested_xp_063
      ::ClearQFlag $player rested_xp_064
      ::ClearQFlag $player rested_xp_065
      ::ClearQFlag $player rested_xp_066
      ::ClearQFlag $player rested_xp_067
      ::ClearQFlag $player rested_xp_068
      ::ClearQFlag $player rested_xp_069
      ::ClearQFlag $player rested_xp_070
      ::ClearQFlag $player rested_xp_071
      ::ClearQFlag $player rested_xp_072
      ::ClearQFlag $player rested_xp_073
      ::ClearQFlag $player rested_xp_074
      ::ClearQFlag $player rested_xp_075
      ::ClearQFlag $player rested_xp_076
      ::ClearQFlag $player rested_xp_077
      ::ClearQFlag $player rested_xp_078
      ::ClearQFlag $player rested_xp_079
      ::ClearQFlag $player rested_xp_080
      ::ClearQFlag $player rested_xp_081
      ::ClearQFlag $player rested_xp_082
      ::ClearQFlag $player rested_xp_083
      ::ClearQFlag $player rested_xp_084
      ::ClearQFlag $player rested_xp_085
      ::ClearQFlag $player rested_xp_086
      ::ClearQFlag $player rested_xp_087
      ::ClearQFlag $player rested_xp_088
      ::ClearQFlag $player rested_xp_089
      ::ClearQFlag $player rested_xp_090
      ::ClearQFlag $player rested_xp_091
      ::ClearQFlag $player rested_xp_092
      ::ClearQFlag $player rested_xp_093
      ::ClearQFlag $player rested_xp_094
      ::ClearQFlag $player rested_xp_095
      ::ClearQFlag $player rested_xp_096
      ::ClearQFlag $player rested_xp_097
      ::ClearQFlag $player rested_xp_098
      ::ClearQFlag $player rested_xp_099
      ::ClearQFlag $player rested_xp_100
      ::ClearQFlag $player rested_xp_101
      ::ClearQFlag $player rested_xp_102
      ::ClearQFlag $player rested_xp_103
      ::ClearQFlag $player rested_xp_104
      ::ClearQFlag $player rested_xp_105
      ::ClearQFlag $player rested_xp_106
      ::ClearQFlag $player rested_xp_107
      ::ClearQFlag $player rested_xp_108
      ::ClearQFlag $player rested_xp_109
      ::ClearQFlag $player rested_xp_110
      ::ClearQFlag $player rested_xp_111
      ::ClearQFlag $player rested_xp_112
      ::ClearQFlag $player rested_xp_113
      ::ClearQFlag $player rested_xp_114
      ::ClearQFlag $player rested_xp_115
      ::ClearQFlag $player rested_xp_116
      ::ClearQFlag $player rested_xp_117
      ::ClearQFlag $player rested_xp_118
      ::ClearQFlag $player rested_xp_119
      ::ClearQFlag $player rested_xp_120
      ::ClearQFlag $player rested_xp_121
      ::ClearQFlag $player rested_xp_122
      ::ClearQFlag $player rested_xp_123
      ::ClearQFlag $player rested_xp_124
      ::ClearQFlag $player rested_xp_125
      ::ClearQFlag $player rested_xp_126
      ::ClearQFlag $player rested_xp_127
      ::ClearQFlag $player rested_xp_128
      ::ClearQFlag $player rested_xp_129
      ::ClearQFlag $player rested_xp_130
      ::ClearQFlag $player rested_xp_131
      ::ClearQFlag $player rested_xp_132
      ::ClearQFlag $player rested_xp_133
      ::ClearQFlag $player rested_xp_134
      ::ClearQFlag $player rested_xp_135
      ::ClearQFlag $player rested_xp_136
      ::ClearQFlag $player rested_xp_137
      ::ClearQFlag $player rested_xp_138
      ::ClearQFlag $player rested_xp_139
      ::ClearQFlag $player rested_xp_140
      ::ClearQFlag $player rested_xp_141
      ::ClearQFlag $player rested_xp_142
      ::ClearQFlag $player rested_xp_143
      ::ClearQFlag $player rested_xp_144
      ::ClearQFlag $player rested_xp_145
      ::ClearQFlag $player rested_xp_146
      ::ClearQFlag $player rested_xp_147
      ::ClearQFlag $player rested_xp_148
      ::ClearQFlag $player rested_xp_149
      ::ClearQFlag $player rested_xp_150
      ::ClearQFlag $player rested_xp_151
      ::ClearQFlag $player rested_xp_152
      ::ClearQFlag $player rested_xp_153
      ::ClearQFlag $player rested_xp_154
      ::ClearQFlag $player rested_xp_155
      ::ClearQFlag $player rested_xp_156
      ::ClearQFlag $player rested_xp_157
      ::ClearQFlag $player rested_xp_158
      ::ClearQFlag $player rested_xp_159
      ::ClearQFlag $player rested_xp_160
      ::ClearQFlag $player rested_xp_161
      ::ClearQFlag $player rested_xp_162
      ::ClearQFlag $player rested_xp_163
      ::ClearQFlag $player rested_xp_164
      ::ClearQFlag $player rested_xp_165
      ::ClearQFlag $player rested_xp_166
      ::ClearQFlag $player rested_xp_167
      ::ClearQFlag $player rested_xp_168
      ::ClearQFlag $player rested_xp_169
      ::ClearQFlag $player rested_xp_170
      ::ClearQFlag $player rested_xp_171
      ::ClearQFlag $player rested_xp_172
      ::ClearQFlag $player rested_xp_173
      ::ClearQFlag $player rested_xp_174
      ::ClearQFlag $player rested_xp_175
      ::ClearQFlag $player rested_xp_176
      ::ClearQFlag $player rested_xp_177
      ::ClearQFlag $player rested_xp_178
      ::ClearQFlag $player rested_xp_179
      ::ClearQFlag $player rested_xp_180
      if {$plevel < 10} {
        if {$bubble == 1} {::SetQFlag $player rested_xp_001}
        if {$bubble == 2} {::SetQFlag $player rested_xp_002}
        if {$bubble == 3} {::SetQFlag $player rested_xp_003}
        if {$bubble == 4} {::SetQFlag $player rested_xp_004}
        if {$bubble == 5} {::SetQFlag $player rested_xp_005}
        if {$bubble == 6} {::SetQFlag $player rested_xp_006}
        if {$bubble == 7} {::SetQFlag $player rested_xp_007}
        if {$bubble == 8} {::SetQFlag $player rested_xp_008}
        if {$bubble == 9} {::SetQFlag $player rested_xp_009}
        if {$bubble == 10} {::SetQFlag $player rested_xp_010}
        if {$bubble == 11} {::SetQFlag $player rested_xp_011}
        if {$bubble == 12} {::SetQFlag $player rested_xp_012}
        if {$bubble == 13} {::SetQFlag $player rested_xp_013}
        if {$bubble == 14} {::SetQFlag $player rested_xp_014}
        if {$bubble == 15} {::SetQFlag $player rested_xp_015}
        if {$bubble == 16} {::SetQFlag $player rested_xp_016}
        if {$bubble == 17} {::SetQFlag $player rested_xp_017}
        if {$bubble == 18} {::SetQFlag $player rested_xp_018}
        if {$bubble == 19} {::SetQFlag $player rested_xp_019}
        if {$bubble == 20} {::SetQFlag $player rested_xp_020}
        if {$bubble == 21} {::SetQFlag $player rested_xp_021}
        if {$bubble == 22} {::SetQFlag $player rested_xp_022}
        if {$bubble == 23} {::SetQFlag $player rested_xp_023}
        if {$bubble == 24} {::SetQFlag $player rested_xp_024}
        if {$bubble == 25} {::SetQFlag $player rested_xp_025}
        if {$bubble == 26} {::SetQFlag $player rested_xp_026}
        if {$bubble == 27} {::SetQFlag $player rested_xp_027}
        if {$bubble == 28} {::SetQFlag $player rested_xp_028}
        if {$bubble == 29} {::SetQFlag $player rested_xp_029}
        if {$bubble == 30} {::SetQFlag $player rested_xp_030}
      }
      if {$plevel >= 10 && $plevel < 20} {
        if {$bubble == 1} {::SetQFlag $player rested_xp_002}
        if {$bubble == 2} {::SetQFlag $player rested_xp_004}
        if {$bubble == 3} {::SetQFlag $player rested_xp_006}
        if {$bubble == 4} {::SetQFlag $player rested_xp_008}
        if {$bubble == 5} {::SetQFlag $player rested_xp_010}
        if {$bubble == 6} {::SetQFlag $player rested_xp_012}
        if {$bubble == 7} {::SetQFlag $player rested_xp_014}
        if {$bubble == 8} {::SetQFlag $player rested_xp_016}
        if {$bubble == 9} {::SetQFlag $player rested_xp_018}
        if {$bubble == 10} {::SetQFlag $player rested_xp_020}
        if {$bubble == 11} {::SetQFlag $player rested_xp_022}
        if {$bubble == 12} {::SetQFlag $player rested_xp_024}
        if {$bubble == 13} {::SetQFlag $player rested_xp_026}
        if {$bubble == 14} {::SetQFlag $player rested_xp_028}
        if {$bubble == 15} {::SetQFlag $player rested_xp_030}
        if {$bubble == 16} {::SetQFlag $player rested_xp_032}
        if {$bubble == 17} {::SetQFlag $player rested_xp_034}
        if {$bubble == 18} {::SetQFlag $player rested_xp_036}
        if {$bubble == 19} {::SetQFlag $player rested_xp_038}
        if {$bubble == 20} {::SetQFlag $player rested_xp_040}
        if {$bubble == 21} {::SetQFlag $player rested_xp_042}
        if {$bubble == 22} {::SetQFlag $player rested_xp_044}
        if {$bubble == 23} {::SetQFlag $player rested_xp_046}
        if {$bubble == 24} {::SetQFlag $player rested_xp_048}
        if {$bubble == 25} {::SetQFlag $player rested_xp_050}
        if {$bubble == 26} {::SetQFlag $player rested_xp_052}
        if {$bubble == 27} {::SetQFlag $player rested_xp_054}
        if {$bubble == 28} {::SetQFlag $player rested_xp_056}
        if {$bubble == 29} {::SetQFlag $player rested_xp_058}
        if {$bubble == 30} {::SetQFlag $player rested_xp_060}
      }
      if {$plevel >= 20 && $plevel < 30} {
        if {$bubble == 1} {::SetQFlag $player rested_xp_003}
        if {$bubble == 2} {::SetQFlag $player rested_xp_006}
        if {$bubble == 3} {::SetQFlag $player rested_xp_009}
        if {$bubble == 4} {::SetQFlag $player rested_xp_012}
        if {$bubble == 5} {::SetQFlag $player rested_xp_015}
        if {$bubble == 6} {::SetQFlag $player rested_xp_018}
        if {$bubble == 7} {::SetQFlag $player rested_xp_021}
        if {$bubble == 8} {::SetQFlag $player rested_xp_024}
        if {$bubble == 9} {::SetQFlag $player rested_xp_027}
        if {$bubble == 10} {::SetQFlag $player rested_xp_030}
        if {$bubble == 11} {::SetQFlag $player rested_xp_033}
        if {$bubble == 12} {::SetQFlag $player rested_xp_036}
        if {$bubble == 13} {::SetQFlag $player rested_xp_039}
        if {$bubble == 14} {::SetQFlag $player rested_xp_042}
        if {$bubble == 15} {::SetQFlag $player rested_xp_045}
        if {$bubble == 16} {::SetQFlag $player rested_xp_048}
        if {$bubble == 17} {::SetQFlag $player rested_xp_051}
        if {$bubble == 18} {::SetQFlag $player rested_xp_054}
        if {$bubble == 19} {::SetQFlag $player rested_xp_057}
        if {$bubble == 20} {::SetQFlag $player rested_xp_060}
        if {$bubble == 21} {::SetQFlag $player rested_xp_063}
        if {$bubble == 22} {::SetQFlag $player rested_xp_066}
        if {$bubble == 23} {::SetQFlag $player rested_xp_069}
        if {$bubble == 24} {::SetQFlag $player rested_xp_072}
        if {$bubble == 25} {::SetQFlag $player rested_xp_075}
        if {$bubble == 26} {::SetQFlag $player rested_xp_078}
        if {$bubble == 27} {::SetQFlag $player rested_xp_081}
        if {$bubble == 28} {::SetQFlag $player rested_xp_084}
        if {$bubble == 29} {::SetQFlag $player rested_xp_087}
        if {$bubble == 30} {::SetQFlag $player rested_xp_090}
      }
      if {$plevel >= 30 && $plevel < 40} {
        if {$bubble == 1} {::SetQFlag $player rested_xp_004}
        if {$bubble == 2} {::SetQFlag $player rested_xp_008}
        if {$bubble == 3} {::SetQFlag $player rested_xp_012}
        if {$bubble == 4} {::SetQFlag $player rested_xp_016}
        if {$bubble == 5} {::SetQFlag $player rested_xp_020}
        if {$bubble == 6} {::SetQFlag $player rested_xp_024}
        if {$bubble == 7} {::SetQFlag $player rested_xp_028}
        if {$bubble == 8} {::SetQFlag $player rested_xp_032}
        if {$bubble == 9} {::SetQFlag $player rested_xp_036}
        if {$bubble == 10} {::SetQFlag $player rested_xp_040}
        if {$bubble == 11} {::SetQFlag $player rested_xp_044}
        if {$bubble == 12} {::SetQFlag $player rested_xp_048}
        if {$bubble == 13} {::SetQFlag $player rested_xp_052}
        if {$bubble == 14} {::SetQFlag $player rested_xp_056}
        if {$bubble == 15} {::SetQFlag $player rested_xp_060}
        if {$bubble == 16} {::SetQFlag $player rested_xp_064}
        if {$bubble == 17} {::SetQFlag $player rested_xp_068}
        if {$bubble == 18} {::SetQFlag $player rested_xp_072}
        if {$bubble == 19} {::SetQFlag $player rested_xp_076}
        if {$bubble == 20} {::SetQFlag $player rested_xp_080}
        if {$bubble == 21} {::SetQFlag $player rested_xp_084}
        if {$bubble == 22} {::SetQFlag $player rested_xp_088}
        if {$bubble == 23} {::SetQFlag $player rested_xp_092}
        if {$bubble == 24} {::SetQFlag $player rested_xp_096}
        if {$bubble == 25} {::SetQFlag $player rested_xp_100}
        if {$bubble == 26} {::SetQFlag $player rested_xp_104}
        if {$bubble == 27} {::SetQFlag $player rested_xp_108}
        if {$bubble == 28} {::SetQFlag $player rested_xp_112}
        if {$bubble == 29} {::SetQFlag $player rested_xp_116}
        if {$bubble == 30} {::SetQFlag $player rested_xp_120}
      }
      if {$plevel >= 40 && $plevel < 50} {
        if {$bubble == 1} {::SetQFlag $player rested_xp_005}
        if {$bubble == 2} {::SetQFlag $player rested_xp_010}
        if {$bubble == 3} {::SetQFlag $player rested_xp_015}
        if {$bubble == 4} {::SetQFlag $player rested_xp_020}
        if {$bubble == 5} {::SetQFlag $player rested_xp_025}
        if {$bubble == 6} {::SetQFlag $player rested_xp_030}
        if {$bubble == 7} {::SetQFlag $player rested_xp_035}
        if {$bubble == 8} {::SetQFlag $player rested_xp_040}
        if {$bubble == 9} {::SetQFlag $player rested_xp_045}
        if {$bubble == 10} {::SetQFlag $player rested_xp_050}
        if {$bubble == 11} {::SetQFlag $player rested_xp_055}
        if {$bubble == 12} {::SetQFlag $player rested_xp_060}
        if {$bubble == 13} {::SetQFlag $player rested_xp_065}
        if {$bubble == 14} {::SetQFlag $player rested_xp_070}
        if {$bubble == 15} {::SetQFlag $player rested_xp_075}
        if {$bubble == 16} {::SetQFlag $player rested_xp_080}
        if {$bubble == 17} {::SetQFlag $player rested_xp_085}
        if {$bubble == 18} {::SetQFlag $player rested_xp_090}
        if {$bubble == 19} {::SetQFlag $player rested_xp_095}
        if {$bubble == 20} {::SetQFlag $player rested_xp_100}
        if {$bubble == 21} {::SetQFlag $player rested_xp_105}
        if {$bubble == 22} {::SetQFlag $player rested_xp_110}
        if {$bubble == 23} {::SetQFlag $player rested_xp_115}
        if {$bubble == 24} {::SetQFlag $player rested_xp_120}
        if {$bubble == 25} {::SetQFlag $player rested_xp_125}
        if {$bubble == 26} {::SetQFlag $player rested_xp_130}
        if {$bubble == 27} {::SetQFlag $player rested_xp_135}
        if {$bubble == 28} {::SetQFlag $player rested_xp_140}
        if {$bubble == 29} {::SetQFlag $player rested_xp_145}
        if {$bubble == 30} {::SetQFlag $player rested_xp_150}
      }
      if {$plevel >= 50} {
        if {$bubble == 1} {::SetQFlag $player rested_xp_006}
        if {$bubble == 2} {::SetQFlag $player rested_xp_012}
        if {$bubble == 3} {::SetQFlag $player rested_xp_018}
        if {$bubble == 4} {::SetQFlag $player rested_xp_024}
        if {$bubble == 5} {::SetQFlag $player rested_xp_030}
        if {$bubble == 6} {::SetQFlag $player rested_xp_036}
        if {$bubble == 7} {::SetQFlag $player rested_xp_042}
        if {$bubble == 8} {::SetQFlag $player rested_xp_048}
        if {$bubble == 9} {::SetQFlag $player rested_xp_054}
        if {$bubble == 10} {::SetQFlag $player rested_xp_060}
        if {$bubble == 11} {::SetQFlag $player rested_xp_066}
        if {$bubble == 12} {::SetQFlag $player rested_xp_072}
        if {$bubble == 13} {::SetQFlag $player rested_xp_078}
        if {$bubble == 14} {::SetQFlag $player rested_xp_084}
        if {$bubble == 15} {::SetQFlag $player rested_xp_090}
        if {$bubble == 16} {::SetQFlag $player rested_xp_096}
        if {$bubble == 17} {::SetQFlag $player rested_xp_102}
        if {$bubble == 18} {::SetQFlag $player rested_xp_108}
        if {$bubble == 19} {::SetQFlag $player rested_xp_114}
        if {$bubble == 20} {::SetQFlag $player rested_xp_120}
        if {$bubble == 21} {::SetQFlag $player rested_xp_126}
        if {$bubble == 22} {::SetQFlag $player rested_xp_132}
        if {$bubble == 23} {::SetQFlag $player rested_xp_138}
        if {$bubble == 24} {::SetQFlag $player rested_xp_144}
        if {$bubble == 25} {::SetQFlag $player rested_xp_150}
        if {$bubble == 26} {::SetQFlag $player rested_xp_156}
        if {$bubble == 27} {::SetQFlag $player rested_xp_162}
        if {$bubble == 28} {::SetQFlag $player rested_xp_168}
        if {$bubble == 29} {::SetQFlag $player rested_xp_174}
        if {$bubble == 30} {::SetQFlag $player rested_xp_180}
      }
      if {$bubble >= 1} {::SetQFlag $player rested} else {::ClearQFlag $player rested}
    } else {
      if {[::GetQFlag $player reststatecheck]} {
        ::ClearQFlag $player reststatecheck
        if {[::GetQFlag $player rested]} {return 1}
        return 0
      }
      if {$restlvlreset != 0} {
        set read [reststate eval {SELECT `level`, `time` FROM `reststate` WHERE (`name` LIKE $pname)}]
        set levelold [lindex $read 0]
        if {$levelold != "" && $plevel != $levelold} {
          reststate eval {UPDATE `reststate` set `level` = $plevel WHERE (`name` = $pname)}
          ::ClearQFlag $player rested
          Say $player 0 "|cFFFFFF00EXHAUSTION_NORMAL|r"
          return 0
        }
      }
      if {$rested_xp_180 == 1} {
        ::ClearQFlag $player rested_xp_180
        ::SetQFlag $player rested_xp_179
      }
      if {$rested_xp_179 == 1} {
        ::ClearQFlag $player rested_xp_179
        ::SetQFlag $player rested_xp_178
      }
      if {$rested_xp_178 == 1} {
        ::ClearQFlag $player rested_xp_178
        ::SetQFlag $player rested_xp_177
      }
      if {$rested_xp_177 == 1} {
        ::ClearQFlag $player rested_xp_177
        ::SetQFlag $player rested_xp_176
      }
      if {$rested_xp_176 == 1} {
        ::ClearQFlag $player rested_xp_176
        ::SetQFlag $player rested_xp_175
      }
      if {$rested_xp_175 == 1} {
        ::ClearQFlag $player rested_xp_175
        ::SetQFlag $player rested_xp_174
      }
      if {$rested_xp_174 == 1} {
        ::ClearQFlag $player rested_xp_174
        ::SetQFlag $player rested_xp_173
      }
      if {$rested_xp_173 == 1} {
        ::ClearQFlag $player rested_xp_173
        ::SetQFlag $player rested_xp_172
      }
      if {$rested_xp_172 == 1} {
        ::ClearQFlag $player rested_xp_172
        ::SetQFlag $player rested_xp_171
      }
      if {$rested_xp_171 == 1} {
        ::ClearQFlag $player rested_xp_171
        ::SetQFlag $player rested_xp_170
      }
      if {$rested_xp_170 == 1} {
        ::ClearQFlag $player rested_xp_170
        ::SetQFlag $player rested_xp_169
      }
      if {$rested_xp_169 == 1} {
        ::ClearQFlag $player rested_xp_169
        ::SetQFlag $player rested_xp_168
      }
      if {$rested_xp_168 == 1} {
        ::ClearQFlag $player rested_xp_168
        ::SetQFlag $player rested_xp_167
      }
      if {$rested_xp_167 == 1} {
        ::ClearQFlag $player rested_xp_167
        ::SetQFlag $player rested_xp_166
      }
      if {$rested_xp_166 == 1} {
        ::ClearQFlag $player rested_xp_166
        ::SetQFlag $player rested_xp_165
      }
      if {$rested_xp_165 == 1} {
        ::ClearQFlag $player rested_xp_165
        ::SetQFlag $player rested_xp_164
      }
      if {$rested_xp_164 == 1} {
        ::ClearQFlag $player rested_xp_164
        ::SetQFlag $player rested_xp_163
      }
      if {$rested_xp_163 == 1} {
        ::ClearQFlag $player rested_xp_163
        ::SetQFlag $player rested_xp_162
      }
      if {$rested_xp_162 == 1} {
        ::ClearQFlag $player rested_xp_162
        ::SetQFlag $player rested_xp_161
      }
      if {$rested_xp_161 == 1} {
        ::ClearQFlag $player rested_xp_161
        ::SetQFlag $player rested_xp_160
      }
      if {$rested_xp_160 == 1} {
        ::ClearQFlag $player rested_xp_160
        ::SetQFlag $player rested_xp_159
      }
      if {$rested_xp_159 == 1} {
        ::ClearQFlag $player rested_xp_159
        ::SetQFlag $player rested_xp_158
      }
      if {$rested_xp_158 == 1} {
        ::ClearQFlag $player rested_xp_158
        ::SetQFlag $player rested_xp_157
      }
      if {$rested_xp_157 == 1} {
        ::ClearQFlag $player rested_xp_157
        ::SetQFlag $player rested_xp_156
      }
      if {$rested_xp_156 == 1} {
        ::ClearQFlag $player rested_xp_156
        ::SetQFlag $player rested_xp_155
      }
      if {$rested_xp_155 == 1} {
        ::ClearQFlag $player rested_xp_155
        ::SetQFlag $player rested_xp_154
      }
      if {$rested_xp_154 == 1} {
        ::ClearQFlag $player rested_xp_154
        ::SetQFlag $player rested_xp_153
      }
      if {$rested_xp_153 == 1} {
        ::ClearQFlag $player rested_xp_153
        ::SetQFlag $player rested_xp_152
      }
      if {$rested_xp_152 == 1} {
        ::ClearQFlag $player rested_xp_152
        ::SetQFlag $player rested_xp_151
      }
      if {$rested_xp_151 == 1} {
        ::ClearQFlag $player rested_xp_151
        ::SetQFlag $player rested_xp_150
      }
      if {$rested_xp_150 == 1} {
        ::ClearQFlag $player rested_xp_150
        ::SetQFlag $player rested_xp_149
      }
      if {$rested_xp_149 == 1} {
        ::ClearQFlag $player rested_xp_149
        ::SetQFlag $player rested_xp_148
      }
      if {$rested_xp_148 == 1} {
        ::ClearQFlag $player rested_xp_148
        ::SetQFlag $player rested_xp_147
      }
      if {$rested_xp_147 == 1} {
        ::ClearQFlag $player rested_xp_147
        ::SetQFlag $player rested_xp_146
      }
      if {$rested_xp_146 == 1} {
        ::ClearQFlag $player rested_xp_146
        ::SetQFlag $player rested_xp_145
      }
      if {$rested_xp_145 == 1} {
        ::ClearQFlag $player rested_xp_145
        ::SetQFlag $player rested_xp_144
      }
      if {$rested_xp_144 == 1} {
        ::ClearQFlag $player rested_xp_144
        ::SetQFlag $player rested_xp_143
      }
      if {$rested_xp_143 == 1} {
        ::ClearQFlag $player rested_xp_143
        ::SetQFlag $player rested_xp_142
      }
      if {$rested_xp_142 == 1} {
        ::ClearQFlag $player rested_xp_142
        ::SetQFlag $player rested_xp_141
      }
      if {$rested_xp_141 == 1} {
        ::ClearQFlag $player rested_xp_141
        ::SetQFlag $player rested_xp_140
      }
      if {$rested_xp_140 == 1} {
        ::ClearQFlag $player rested_xp_140
        ::SetQFlag $player rested_xp_139
      }
      if {$rested_xp_139 == 1} {
        ::ClearQFlag $player rested_xp_139
        ::SetQFlag $player rested_xp_138
      }
      if {$rested_xp_138 == 1} {
        ::ClearQFlag $player rested_xp_138
        ::SetQFlag $player rested_xp_137
      }
      if {$rested_xp_137 == 1} {
        ::ClearQFlag $player rested_xp_137
        ::SetQFlag $player rested_xp_136
      }
      if {$rested_xp_136 == 1} {
        ::ClearQFlag $player rested_xp_136
        ::SetQFlag $player rested_xp_135
      }
      if {$rested_xp_135 == 1} {
        ::ClearQFlag $player rested_xp_135
        ::SetQFlag $player rested_xp_134
      }
      if {$rested_xp_134 == 1} {
        ::ClearQFlag $player rested_xp_134
        ::SetQFlag $player rested_xp_133
      }
      if {$rested_xp_133 == 1} {
        ::ClearQFlag $player rested_xp_133
        ::SetQFlag $player rested_xp_132
      }
      if {$rested_xp_132 == 1} {
        ::ClearQFlag $player rested_xp_132
        ::SetQFlag $player rested_xp_131
      }
      if {$rested_xp_131 == 1} {
        ::ClearQFlag $player rested_xp_131
        ::SetQFlag $player rested_xp_130
      }
      if {$rested_xp_130 == 1} {
        ::ClearQFlag $player rested_xp_130
        ::SetQFlag $player rested_xp_129
      }
      if {$rested_xp_129 == 1} {
        ::ClearQFlag $player rested_xp_129
        ::SetQFlag $player rested_xp_128
      }
      if {$rested_xp_128 == 1} {
        ::ClearQFlag $player rested_xp_128
        ::SetQFlag $player rested_xp_127
      }
      if {$rested_xp_127 == 1} {
        ::ClearQFlag $player rested_xp_127
        ::SetQFlag $player rested_xp_126
      }
      if {$rested_xp_126 == 1} {
        ::ClearQFlag $player rested_xp_126
        ::SetQFlag $player rested_xp_125
      }
      if {$rested_xp_125 == 1} {
        ::ClearQFlag $player rested_xp_125
        ::SetQFlag $player rested_xp_124
      }
      if {$rested_xp_124 == 1} {
        ::ClearQFlag $player rested_xp_124
        ::SetQFlag $player rested_xp_123
      }
      if {$rested_xp_123 == 1} {
        ::ClearQFlag $player rested_xp_123
        ::SetQFlag $player rested_xp_122
      }
      if {$rested_xp_122 == 1} {
        ::ClearQFlag $player rested_xp_122
        ::SetQFlag $player rested_xp_121
      }
      if {$rested_xp_121 == 1} {
        ::ClearQFlag $player rested_xp_121
        ::SetQFlag $player rested_xp_120
      }
      if {$rested_xp_120 == 1} {
        ::ClearQFlag $player rested_xp_120
        ::SetQFlag $player rested_xp_119
      }
      if {$rested_xp_119 == 1} {
        ::ClearQFlag $player rested_xp_119
        ::SetQFlag $player rested_xp_118
      }
      if {$rested_xp_118 == 1} {
        ::ClearQFlag $player rested_xp_118
        ::SetQFlag $player rested_xp_117
      }
      if {$rested_xp_117 == 1} {
        ::ClearQFlag $player rested_xp_117
        ::SetQFlag $player rested_xp_116
      }
      if {$rested_xp_116 == 1} {
        ::ClearQFlag $player rested_xp_116
        ::SetQFlag $player rested_xp_115
      }
      if {$rested_xp_115 == 1} {
        ::ClearQFlag $player rested_xp_115
        ::SetQFlag $player rested_xp_114
      }
      if {$rested_xp_114 == 1} {
        ::ClearQFlag $player rested_xp_114
        ::SetQFlag $player rested_xp_113
      }
      if {$rested_xp_113 == 1} {
        ::ClearQFlag $player rested_xp_113
        ::SetQFlag $player rested_xp_112
      }
      if {$rested_xp_112 == 1} {
        ::ClearQFlag $player rested_xp_112
        ::SetQFlag $player rested_xp_111
      }
      if {$rested_xp_111 == 1} {
        ::ClearQFlag $player rested_xp_111
        ::SetQFlag $player rested_xp_110
      }
      if {$rested_xp_110 == 1} {
        ::ClearQFlag $player rested_xp_110
        ::SetQFlag $player rested_xp_109
      }
      if {$rested_xp_109 == 1} {
        ::ClearQFlag $player rested_xp_109
        ::SetQFlag $player rested_xp_108
      }
      if {$rested_xp_108 == 1} {
        ::ClearQFlag $player rested_xp_108
        ::SetQFlag $player rested_xp_107
      }
      if {$rested_xp_107 == 1} {
        ::ClearQFlag $player rested_xp_107
        ::SetQFlag $player rested_xp_106
      }
      if {$rested_xp_106 == 1} {
        ::ClearQFlag $player rested_xp_106
        ::SetQFlag $player rested_xp_105
      }
      if {$rested_xp_105 == 1} {
        ::ClearQFlag $player rested_xp_105
        ::SetQFlag $player rested_xp_104
      }
      if {$rested_xp_104 == 1} {
        ::ClearQFlag $player rested_xp_104
        ::SetQFlag $player rested_xp_103
      }
      if {$rested_xp_103 == 1} {
        ::ClearQFlag $player rested_xp_103
        ::SetQFlag $player rested_xp_102
      }
      if {$rested_xp_102 == 1} {
        ::ClearQFlag $player rested_xp_102
        ::SetQFlag $player rested_xp_101
      }
      if {$rested_xp_101 == 1} {
        ::ClearQFlag $player rested_xp_101
        ::SetQFlag $player rested_xp_100
      }
      if {$rested_xp_100 == 1} {
        ::ClearQFlag $player rested_xp_100
        ::SetQFlag $player rested_xp_099
      }
      if {$rested_xp_099 == 1} {
        ::ClearQFlag $player rested_xp_099
        ::SetQFlag $player rested_xp_098
      }
      if {$rested_xp_098 == 1} {
        ::ClearQFlag $player rested_xp_098
        ::SetQFlag $player rested_xp_097
      }
      if {$rested_xp_097 == 1} {
        ::ClearQFlag $player rested_xp_097
        ::SetQFlag $player rested_xp_096
      }
      if {$rested_xp_096 == 1} {
        ::ClearQFlag $player rested_xp_096
        ::SetQFlag $player rested_xp_095
      }
      if {$rested_xp_095 == 1} {
        ::ClearQFlag $player rested_xp_095
        ::SetQFlag $player rested_xp_094
      }
      if {$rested_xp_094 == 1} {
        ::ClearQFlag $player rested_xp_094
        ::SetQFlag $player rested_xp_093
      }
      if {$rested_xp_093 == 1} {
        ::ClearQFlag $player rested_xp_093
        ::SetQFlag $player rested_xp_092
      }
      if {$rested_xp_092 == 1} {
        ::ClearQFlag $player rested_xp_092
        ::SetQFlag $player rested_xp_091
      }
      if {$rested_xp_091 == 1} {
        ::ClearQFlag $player rested_xp_091
        ::SetQFlag $player rested_xp_090
      }
      if {$rested_xp_090 == 1} {
        ::ClearQFlag $player rested_xp_090
        ::SetQFlag $player rested_xp_089
      }
      if {$rested_xp_089 == 1} {
        ::ClearQFlag $player rested_xp_089
        ::SetQFlag $player rested_xp_088
      }
      if {$rested_xp_088 == 1} {
        ::ClearQFlag $player rested_xp_088
        ::SetQFlag $player rested_xp_087
      }
      if {$rested_xp_087 == 1} {
        ::ClearQFlag $player rested_xp_087
        ::SetQFlag $player rested_xp_086
      }
      if {$rested_xp_086 == 1} {
        ::ClearQFlag $player rested_xp_086
        ::SetQFlag $player rested_xp_085
      }
      if {$rested_xp_085 == 1} {
        ::ClearQFlag $player rested_xp_085
        ::SetQFlag $player rested_xp_084
      }
      if {$rested_xp_084 == 1} {
        ::ClearQFlag $player rested_xp_084
        ::SetQFlag $player rested_xp_083
      }
      if {$rested_xp_083 == 1} {
        ::ClearQFlag $player rested_xp_083
        ::SetQFlag $player rested_xp_082
      }
      if {$rested_xp_082 == 1} {
        ::ClearQFlag $player rested_xp_082
        ::SetQFlag $player rested_xp_081
      }
      if {$rested_xp_081 == 1} {
        ::ClearQFlag $player rested_xp_081
        ::SetQFlag $player rested_xp_080
      }
      if {$rested_xp_080 == 1} {
        ::ClearQFlag $player rested_xp_080
        ::SetQFlag $player rested_xp_079
      }
      if {$rested_xp_079 == 1} {
        ::ClearQFlag $player rested_xp_079
        ::SetQFlag $player rested_xp_078
      }
      if {$rested_xp_078 == 1} {
        ::ClearQFlag $player rested_xp_078
        ::SetQFlag $player rested_xp_077
      }
      if {$rested_xp_077 == 1} {
        ::ClearQFlag $player rested_xp_077
        ::SetQFlag $player rested_xp_076
      }
      if {$rested_xp_076 == 1} {
        ::ClearQFlag $player rested_xp_076
        ::SetQFlag $player rested_xp_075
      }
      if {$rested_xp_075 == 1} {
        ::ClearQFlag $player rested_xp_075
        ::SetQFlag $player rested_xp_074
      }
      if {$rested_xp_074 == 1} {
        ::ClearQFlag $player rested_xp_074
        ::SetQFlag $player rested_xp_073
      }
      if {$rested_xp_073 == 1} {
        ::ClearQFlag $player rested_xp_073
        ::SetQFlag $player rested_xp_072
      }
      if {$rested_xp_072 == 1} {
        ::ClearQFlag $player rested_xp_072
        ::SetQFlag $player rested_xp_071
      }
      if {$rested_xp_071 == 1} {
        ::ClearQFlag $player rested_xp_071
        ::SetQFlag $player rested_xp_070
      }
      if {$rested_xp_070 == 1} {
        ::ClearQFlag $player rested_xp_070
        ::SetQFlag $player rested_xp_069
      }
      if {$rested_xp_069 == 1} {
        ::ClearQFlag $player rested_xp_069
        ::SetQFlag $player rested_xp_068
      }
      if {$rested_xp_068 == 1} {
        ::ClearQFlag $player rested_xp_068
        ::SetQFlag $player rested_xp_067
      }
      if {$rested_xp_067 == 1} {
        ::ClearQFlag $player rested_xp_067
        ::SetQFlag $player rested_xp_066
      }
      if {$rested_xp_066 == 1} {
        ::ClearQFlag $player rested_xp_066
        ::SetQFlag $player rested_xp_065
      }
      if {$rested_xp_065 == 1} {
        ::ClearQFlag $player rested_xp_065
        ::SetQFlag $player rested_xp_064
      }
      if {$rested_xp_064 == 1} {
        ::ClearQFlag $player rested_xp_064
        ::SetQFlag $player rested_xp_063
      }
      if {$rested_xp_063 == 1} {
        ::ClearQFlag $player rested_xp_063
        ::SetQFlag $player rested_xp_062
      }
      if {$rested_xp_062 == 1} {
        ::ClearQFlag $player rested_xp_062
        ::SetQFlag $player rested_xp_061
      }
      if {$rested_xp_061 == 1} {
        ::ClearQFlag $player rested_xp_061
        ::SetQFlag $player rested_xp_060
      }
      if {$rested_xp_060 == 1} {
        ::ClearQFlag $player rested_xp_060
        ::SetQFlag $player rested_xp_059
      }
      if {$rested_xp_059 == 1} {
        ::ClearQFlag $player rested_xp_059
        ::SetQFlag $player rested_xp_058
      }
      if {$rested_xp_058 == 1} {
        ::ClearQFlag $player rested_xp_058
        ::SetQFlag $player rested_xp_057
      }
      if {$rested_xp_057 == 1} {
        ::ClearQFlag $player rested_xp_057
        ::SetQFlag $player rested_xp_056
      }
      if {$rested_xp_056 == 1} {
        ::ClearQFlag $player rested_xp_056
        ::SetQFlag $player rested_xp_055
      }
      if {$rested_xp_055 == 1} {
        ::ClearQFlag $player rested_xp_055
        ::SetQFlag $player rested_xp_054
      }
      if {$rested_xp_054 == 1} {
        ::ClearQFlag $player rested_xp_054
        ::SetQFlag $player rested_xp_053
      }
      if {$rested_xp_053 == 1} {
        ::ClearQFlag $player rested_xp_053
        ::SetQFlag $player rested_xp_052
      }
      if {$rested_xp_052 == 1} {
        ::ClearQFlag $player rested_xp_052
        ::SetQFlag $player rested_xp_051
      }
      if {$rested_xp_051 == 1} {
        ::ClearQFlag $player rested_xp_051
        ::SetQFlag $player rested_xp_050
      }
      if {$rested_xp_050 == 1} {
        ::ClearQFlag $player rested_xp_050
        ::SetQFlag $player rested_xp_049
      }
      if {$rested_xp_049 == 1} {
        ::ClearQFlag $player rested_xp_049
        ::SetQFlag $player rested_xp_048
      }
      if {$rested_xp_048 == 1} {
        ::ClearQFlag $player rested_xp_048
        ::SetQFlag $player rested_xp_047
      }
      if {$rested_xp_047 == 1} {
        ::ClearQFlag $player rested_xp_047
        ::SetQFlag $player rested_xp_046
      }
      if {$rested_xp_046 == 1} {
        ::ClearQFlag $player rested_xp_046
        ::SetQFlag $player rested_xp_045
      }
      if {$rested_xp_045 == 1} {
        ::ClearQFlag $player rested_xp_045
        ::SetQFlag $player rested_xp_044
      }
      if {$rested_xp_044 == 1} {
        ::ClearQFlag $player rested_xp_044
        ::SetQFlag $player rested_xp_043
      }
      if {$rested_xp_043 == 1} {
        ::ClearQFlag $player rested_xp_043
        ::SetQFlag $player rested_xp_042
      }
      if {$rested_xp_042 == 1} {
        ::ClearQFlag $player rested_xp_042
        ::SetQFlag $player rested_xp_041
      }
      if {$rested_xp_041 == 1} {
        ::ClearQFlag $player rested_xp_041
        ::SetQFlag $player rested_xp_040
      }
      if {$rested_xp_040 == 1} {
        ::ClearQFlag $player rested_xp_040
        ::SetQFlag $player rested_xp_039
      }
      if {$rested_xp_039 == 1} {
        ::ClearQFlag $player rested_xp_039
        ::SetQFlag $player rested_xp_038
      }
      if {$rested_xp_038 == 1} {
        ::ClearQFlag $player rested_xp_038
        ::SetQFlag $player rested_xp_037
      }
      if {$rested_xp_037 == 1} {
        ::ClearQFlag $player rested_xp_037
        ::SetQFlag $player rested_xp_036
      }
      if {$rested_xp_036 == 1} {
        ::ClearQFlag $player rested_xp_036
        ::SetQFlag $player rested_xp_035
      }
      if {$rested_xp_035 == 1} {
        ::ClearQFlag $player rested_xp_035
        ::SetQFlag $player rested_xp_034
      }
      if {$rested_xp_034 == 1} {
        ::ClearQFlag $player rested_xp_034
        ::SetQFlag $player rested_xp_033
      }
      if {$rested_xp_033 == 1} {
        ::ClearQFlag $player rested_xp_033
        ::SetQFlag $player rested_xp_032
      }
      if {$rested_xp_032 == 1} {
        ::ClearQFlag $player rested_xp_032
        ::SetQFlag $player rested_xp_031
      }
      if {$rested_xp_031 == 1} {
        ::ClearQFlag $player rested_xp_031
        ::SetQFlag $player rested_xp_030
      }
      if {$rested_xp_030 == 1} {
        ::ClearQFlag $player rested_xp_030
        ::SetQFlag $player rested_xp_029
      }
      if {$rested_xp_029 == 1} {
        ::ClearQFlag $player rested_xp_029
        ::SetQFlag $player rested_xp_028
      }
      if {$rested_xp_028 == 1} {
        ::ClearQFlag $player rested_xp_028
        ::SetQFlag $player rested_xp_027
      }
      if {$rested_xp_027 == 1} {
        ::ClearQFlag $player rested_xp_027
        ::SetQFlag $player rested_xp_026
      }
      if {$rested_xp_027 == 1} {
        ::ClearQFlag $player rested_xp_027
        ::SetQFlag $player rested_xp_026
      }
      if {$rested_xp_026 == 1} {
        ::ClearQFlag $player rested_xp_026
        ::SetQFlag $player rested_xp_025
      }
      if {$rested_xp_025 == 1} {
        ::ClearQFlag $player rested_xp_025
        ::SetQFlag $player rested_xp_024
      }
      if {$rested_xp_024 == 1} {
        ::ClearQFlag $player rested_xp_024
        ::SetQFlag $player rested_xp_023
      }
      if {$rested_xp_023 == 1} {
        ::ClearQFlag $player rested_xp_023
        ::SetQFlag $player rested_xp_022
      }
      if {$rested_xp_022 == 1} {
        ::ClearQFlag $player rested_xp_022
        ::SetQFlag $player rested_xp_021
      }
      if {$rested_xp_021 == 1} {
        ::ClearQFlag $player rested_xp_021
        ::SetQFlag $player rested_xp_020
      }
      if {$rested_xp_020 == 1} {
        ::ClearQFlag $player rested_xp_020
        ::SetQFlag $player rested_xp_019
      }
      if {$rested_xp_019 == 1} {
        ::ClearQFlag $player rested_xp_019
        ::SetQFlag $player rested_xp_018
      }
      if {$rested_xp_018 == 1} {
        ::ClearQFlag $player rested_xp_018
        ::SetQFlag $player rested_xp_017
      }
      if {$rested_xp_017 == 1} {
        ::ClearQFlag $player rested_xp_017
        ::SetQFlag $player rested_xp_016
      }
      if {$rested_xp_016 == 1} {
        ::ClearQFlag $player rested_xp_016
        ::SetQFlag $player rested_xp_015
      }
      if {$rested_xp_015 == 1} {
        ::ClearQFlag $player rested_xp_015
        ::SetQFlag $player rested_xp_014
      }
      if {$rested_xp_014 == 1} {
        ::ClearQFlag $player rested_xp_014
        ::SetQFlag $player rested_xp_013
      }
      if {$rested_xp_013 == 1} {
        ::ClearQFlag $player rested_xp_013
        ::SetQFlag $player rested_xp_012
      }
      if {$rested_xp_012 == 1} {
        ::ClearQFlag $player rested_xp_012
        ::SetQFlag $player rested_xp_011
      }
      if {$rested_xp_011 == 1} {
        ::ClearQFlag $player rested_xp_011
        ::SetQFlag $player rested_xp_010
      }
      if {$rested_xp_010 == 1} {
        ::ClearQFlag $player rested_xp_010
        ::SetQFlag $player rested_xp_009
      }
      if {$rested_xp_009 == 1} {
        ::ClearQFlag $player rested_xp_009
        ::SetQFlag $player rested_xp_008
      }
      if {$rested_xp_008 == 1} {
        ::ClearQFlag $player rested_xp_008
        ::SetQFlag $player rested_xp_007
      }
      if {$rested_xp_007 == 1} {
        ::ClearQFlag $player rested_xp_007
        ::SetQFlag $player rested_xp_006
      }
      if {$rested_xp_006 == 1} {
        ::ClearQFlag $player rested_xp_006
        ::SetQFlag $player rested_xp_005
      }
      if {$rested_xp_005 == 1} {
        ::ClearQFlag $player rested_xp_005
        ::SetQFlag $player rested_xp_004
      }
      if {$rested_xp_004 == 1} {
        ::ClearQFlag $player rested_xp_004
        ::SetQFlag $player rested_xp_003
      }
      if {$rested_xp_003 == 1} {
        ::ClearQFlag $player rested_xp_003
        ::SetQFlag $player rested_xp_002
      }
      if {$rested_xp_002 == 1} {
        ::ClearQFlag $player rested_xp_002
        ::SetQFlag $player rested_xp_001
      }
      if {$rested_xp_001 == 1} {
        ::ClearQFlag $player rested_xp_001
        ::ClearQFlag $player rested
        Say $player 0 "|cFFFFFF00EXHAUSTION_NORMAL|r"
      }
    }
    if {[::GetQFlag $player rested]} {return 1}
    return 0
  }
proc Init {} {
	package require sqlite3
	sqlite3 reststate "saves/reststate.db"
	if { ![file size "saves/reststate.db"] } {
		reststate eval {CREATE TABLE IF NOT EXISTS `reststate` (`name` TEXT, `level` TEXT, `time` TEXT, `x` TEXT, `y` TEXT, `z` TEXT)}
		set info "SQLite3 RestState database created."
		puts "[clock format [clock seconds] -format %k:%M:%S]:M:$info"
	}
	::Custom::AddCommand {
		"create_reststatedb" RestState::create_reststatedb 4
		"reststatestatus" RestState::reststatestatus 0
		"restingcheck" RestState::restingcheck 0
		"reststatusreset" RestState::reststatusreset 0
	}
	variable resttimefull 3600
	variable restdistoff 60
	variable restlvlreset 1
	variable restsidecheck 1
	set loadinfo "RestState v0.4.3 by MaxvellNoS loaded - SQLite3"
	puts "[clock format [clock seconds] -format %k:%M:%S]:M:$loadinfo"
	
}
}
::RestState::Init