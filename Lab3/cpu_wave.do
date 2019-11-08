onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_tb/clk
add wave -noupdate /cpu_tb/reset
add wave -noupdate /cpu_tb/dut/signal/Instruction
add wave -noupdate /cpu_tb/dut/signal/ALUOp
add wave -noupdate /cpu_tb/dut/signal/UpdateFlag
add wave -noupdate /cpu_tb/dut/signal/UncondBr
add wave -noupdate /cpu_tb/dut/signal/BrTaken
add wave -noupdate /cpu_tb/dut/signal/MemWrite
add wave -noupdate /cpu_tb/dut/signal/MemRead
add wave -noupdate /cpu_tb/dut/signal/RegWrite
add wave -noupdate /cpu_tb/dut/signal/MemToReg
add wave -noupdate /cpu_tb/dut/signal/ALUSrc
add wave -noupdate /cpu_tb/dut/signal/Reg2Loc
add wave -noupdate /cpu_tb/dut/signal/Reg2Write
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