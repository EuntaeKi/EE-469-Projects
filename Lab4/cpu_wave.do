onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_tb/dut/theFetchStage/clk
add wave -noupdate /cpu_tb/dut/theFetchStage/reset
add wave -noupdate -group InstructionFetch -radix decimal /cpu_tb/dut/theFetchStage/currentPC
add wave -noupdate -group InstructionFetch /cpu_tb/dut/theFetchStage/Instruction
add wave -noupdate -label Flags /cpu_tb/dut/theExStage/TheFlagRegister/storeFlag
add wave -noupdate -label Register -radix decimal /cpu_tb/dut/theDecStage/RegisterFile/registerData
add wave -noupdate -label Memory -radix decimal /cpu_tb/dut/theMemStage/DataMemory/mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {60841837 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 167
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
WaveRestoreZoom {0 ps} {137181122 ps}
