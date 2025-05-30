onerror {resume}
add list -width 14 /top_tb/LEDs
add list /top_tb/KEY3
add list /top_tb/KEY2
add list /top_tb/KEY1
add list /top_tb/KEY0
add list -hex /top_tb/uut/DecoderModuleOutHex5/data
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
