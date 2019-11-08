onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_tb/clk
add wave -noupdate /cpu_tb/reset
add wave -noupdate -radix unsigned -label PC /cpu_tb/dut/instFetch/PC/out
add wave -noupdate /cpu_tb/dut/signal/Instruction
add wave -noupdate {Flags {/cpu_tb/dut/signal/NegativeFlag /cpu_tb/dut/signal/CoutFlag /cpu_tb/dut/signal/OverflowFlag /cpu_tb/dut/signal/ZeroFlag}}
add wave -noupdate -radix decimal /cpu_tb/dut/data/TheRegisterFile/registerData
add wave -noupdate -radix decimal /cpu_tb/dut/data/DataMemory/mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 300
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {80000000 ps}