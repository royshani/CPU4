onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/SW_i
add wave -noupdate /top_tb/Pwm_out
add wave -noupdate /top_tb/LEDs
add wave -noupdate /top_tb/KEY3
add wave -noupdate /top_tb/KEY2
add wave -noupdate /top_tb/KEY1
add wave -noupdate /top_tb/KEY0
add wave -noupdate /top_tb/HEX5
add wave -noupdate /top_tb/HEX4
add wave -noupdate /top_tb/HEX3
add wave -noupdate /top_tb/HEX2
add wave -noupdate /top_tb/HEX1
add wave -noupdate /top_tb/HEX0
add wave -noupdate /top_tb/clk
add wave -noupdate /top_tb/uut/X
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {24525 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {293696 ps}
