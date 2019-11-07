onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /CPUdatapath_testbench/Rd
add wave -noupdate -radix decimal /CPUdatapath_testbench/Rm
add wave -noupdate -radix decimal /CPUdatapath_testbench/Rn
add wave -noupdate /CPUdatapath_testbench/AddI12
add wave -noupdate /CPUdatapath_testbench/clk
add wave -noupdate /CPUdatapath_testbench/Reg2Loc
add wave -noupdate /CPUdatapath_testbench/RegWrite
add wave -noupdate /CPUdatapath_testbench/ALUSrc
add wave -noupdate /CPUdatapath_testbench/ALUOp
add wave -noupdate /CPUdatapath_testbench/MemWrite
add wave -noupdate /CPUdatapath_testbench/MemToReg
add wave -noupdate /CPUdatapath_testbench/Zero
add wave -noupdate -label Ab /CPUdatapath_testbench/dut/AbMUX/out
add wave -noupdate -label Dbb /CPUdatapath_testbench/dut/DbbMUX/out
add wave -noupdate -label DW /CPUdatapath_testbench/dut/DWMUX/out
add wave -noupdate -label Da /CPUdatapath_testbench/dut/register/ReadData1
add wave -noupdate -label Db /CPUdatapath_testbench/dut/register/ReadData2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {160169 ps} 0}
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
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {473757 ps}
