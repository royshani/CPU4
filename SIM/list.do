onerror {resume}
add list -width 14 /top_tb/SW_i
add list /top_tb/Pwm_out
add list /top_tb/LEDs
add list /top_tb/KEY3
add list /top_tb/KEY2
add list /top_tb/KEY1
add list /top_tb/KEY0
add list /top_tb/HEX5
add list /top_tb/HEX4
add list /top_tb/HEX3
add list /top_tb/HEX2
add list /top_tb/HEX1
add list /top_tb/HEX0
add list /top_tb/clk
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta all
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
