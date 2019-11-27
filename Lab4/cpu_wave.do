onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_tb/dut/theFetchStage/clk
add wave -noupdate /cpu_tb/dut/theFetchStage/reset
add wave -noupdate -radix decimal /cpu_tb/dut/theFetchStage/currentPC
add wave -noupdate /cpu_tb/dut/theFetchStage/Instruction
add wave -noupdate -group Reg -radix decimal {/cpu_tb/dut/theDecStage/RegisterFile/registerData[0]}
add wave -noupdate -group Reg -radix decimal {/cpu_tb/dut/theDecStage/RegisterFile/registerData[1]}
add wave -noupdate -group Reg -radix decimal {/cpu_tb/dut/theDecStage/RegisterFile/registerData[2]}
add wave -noupdate -group Reg -radix decimal {/cpu_tb/dut/theDecStage/RegisterFile/registerData[3]}
add wave -noupdate -group Reg -radix decimal {/cpu_tb/dut/theDecStage/RegisterFile/registerData[4]}
add wave -noupdate -group Reg -radix decimal {/cpu_tb/dut/theDecStage/RegisterFile/registerData[5]}
add wave -noupdate -group Reg -radix decimal {/cpu_tb/dut/theDecStage/RegisterFile/registerData[6]}
add wave -noupdate -group Reg -radix decimal {/cpu_tb/dut/theDecStage/RegisterFile/registerData[7]}
add wave -noupdate -radix unsigned /cpu_tb/dut/theDecStage/DecAa
add wave -noupdate -radix unsigned /cpu_tb/dut/theDecStage/DecAb
add wave -noupdate -radix unsigned /cpu_tb/dut/theDecStage/DecAw
add wave -noupdate -radix decimal /cpu_tb/dut/theDecStage/WbMemDataToReg
add wave -noupdate /cpu_tb/dut/theFwdUnit/ForwardDa
add wave -noupdate /cpu_tb/dut/theFwdUnit/ForwardDb
add wave -noupdate -radix decimal /cpu_tb/dut/theDecStage/DecDa
add wave -noupdate -radix decimal /cpu_tb/dut/theDecStage/DecDb
add wave -noupdate -radix decimal /cpu_tb/dut/theDecStage/DecImm12Ext
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {32040816 ps} 0}
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
WaveRestoreZoom {0 ps} {150 us}