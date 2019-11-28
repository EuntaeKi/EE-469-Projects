onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group Default /cpu_tb/dut/theFetchStage/clk
add wave -noupdate -group Default /cpu_tb/dut/theFetchStage/reset
add wave -noupdate -group Default -radix decimal /cpu_tb/dut/theFetchStage/currentPC
add wave -noupdate -group Default /cpu_tb/dut/theFetchStage/Instruction
add wave -noupdate -group Default -radix unsigned /cpu_tb/dut/theDecStage/DecAa
add wave -noupdate -group Default -radix unsigned /cpu_tb/dut/theDecStage/DecAb
add wave -noupdate -group Default -radix unsigned /cpu_tb/dut/theDecStage/DecAw
add wave -noupdate -group Default -radix decimal /cpu_tb/dut/theDecStage/WbMemDataToReg
add wave -noupdate -group Default /cpu_tb/dut/theFwdUnit/ForwardDa
add wave -noupdate -group Default /cpu_tb/dut/theFwdUnit/ForwardDb
add wave -noupdate -group Default -radix decimal /cpu_tb/dut/theDecStage/DecDa
add wave -noupdate -group Default -radix decimal /cpu_tb/dut/theDecStage/DecDb
add wave -noupdate -group Default -radix decimal /cpu_tb/dut/theDecStage/DecImm12Ext
add wave -noupdate -group Reg -radix decimal {/cpu_tb/dut/theDecStage/RegisterFile/registerData[0]}
add wave -noupdate -group Reg -radix decimal {/cpu_tb/dut/theDecStage/RegisterFile/registerData[1]}
add wave -noupdate -group Reg -radix decimal {/cpu_tb/dut/theDecStage/RegisterFile/registerData[2]}
add wave -noupdate -group Reg -radix decimal {/cpu_tb/dut/theDecStage/RegisterFile/registerData[3]}
add wave -noupdate -group Reg -radix decimal {/cpu_tb/dut/theDecStage/RegisterFile/registerData[4]}
add wave -noupdate -group Reg -radix decimal {/cpu_tb/dut/theDecStage/RegisterFile/registerData[5]}
add wave -noupdate -group Reg -radix decimal {/cpu_tb/dut/theDecStage/RegisterFile/registerData[6]}
add wave -noupdate -group Reg -radix decimal {/cpu_tb/dut/theDecStage/RegisterFile/registerData[7]}
add wave -noupdate -group Fetch -radix decimal /cpu_tb/dut/theFetchStage/branchAddress
add wave -noupdate -group Fetch -radix decimal /cpu_tb/dut/theFetchStage/Db
add wave -noupdate -group Fetch -radix decimal /cpu_tb/dut/theFetchStage/brTaken
add wave -noupdate -group Fetch /cpu_tb/dut/theFetchStage/clk
add wave -noupdate -group Fetch /cpu_tb/dut/theFetchStage/reset
add wave -noupdate -group Fetch -radix decimal /cpu_tb/dut/theFetchStage/currentPC
add wave -noupdate -group Fetch /cpu_tb/dut/theFetchStage/Instruction
add wave -noupdate -group Fetch -radix decimal /cpu_tb/dut/theFetchStage/addedPC
add wave -noupdate -group Fetch -radix decimal /cpu_tb/dut/theFetchStage/nextPC
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/ExPC
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/ExDa
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/ExDb
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/ExImm12Ext
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/ExImm9Ext
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/WbMemDataToReg
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/MemALUOut
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/ExALUOp
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/ExALUSrc
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/ForwardDa
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/ForwardDb
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/ExFlagWrite
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/clk
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/reset
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/ExALUOut
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/ExFwdDb
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/ExOverflow
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/ExNegative
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/ExZero
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/ExCarryout
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/Overflow
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/Negative
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/Zero
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/Carryout
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/FwdDa
add wave -noupdate -group Execute /cpu_tb/dut/theExStage/ALUSrcOut
add wave -noupdate -group {Branch Adder} -radix decimal /cpu_tb/dut/theDecStage/TheBranchAdder/A
add wave -noupdate -group {Branch Adder} -radix decimal /cpu_tb/dut/theDecStage/TheBranchAdder/B
add wave -noupdate -group {Branch Adder} -radix decimal /cpu_tb/dut/theDecStage/TheBranchAdder/cin
add wave -noupdate -group {Branch Adder} -radix decimal /cpu_tb/dut/theDecStage/TheBranchAdder/cout
add wave -noupdate -group {Branch Adder} -radix decimal /cpu_tb/dut/theDecStage/TheBranchAdder/result
add wave -noupdate -group {Branch Adder} -radix decimal /cpu_tb/dut/theDecStage/TheBranchAdder/carries
add wave -noupdate -group Decode /cpu_tb/dut/theDecStage/clk
add wave -noupdate -group Decode /cpu_tb/dut/theDecStage/reset
add wave -noupdate -group Decode /cpu_tb/dut/theDecStage/DecReg2Loc
add wave -noupdate -group Decode /cpu_tb/dut/theDecStage/DecUncondBr
add wave -noupdate -group Decode /cpu_tb/dut/theDecStage/WbRegWrite
add wave -noupdate -group Decode /cpu_tb/dut/theDecStage/DecReg2Write
add wave -noupdate -group Decode /cpu_tb/dut/theDecStage/DecPC
add wave -noupdate -group Decode /cpu_tb/dut/theDecStage/WbMemDataToReg
add wave -noupdate -group Decode /cpu_tb/dut/theDecStage/DecInst
add wave -noupdate -group Decode /cpu_tb/dut/theDecStage/WbRd
add wave -noupdate -group Decode /cpu_tb/dut/theDecStage/DecDa
add wave -noupdate -group Decode /cpu_tb/dut/theDecStage/DecDb
add wave -noupdate -group Decode /cpu_tb/dut/theDecStage/DecAa
add wave -noupdate -group Decode /cpu_tb/dut/theDecStage/DecAb
add wave -noupdate -group Decode /cpu_tb/dut/theDecStage/DecAw
add wave -noupdate -group Decode -radix decimal /cpu_tb/dut/theDecStage/DecImm9Ext
add wave -noupdate -group Decode -radix decimal /cpu_tb/dut/theDecStage/DecImm12Ext
add wave -noupdate -group Decode -radix decimal /cpu_tb/dut/theDecStage/DecBranchPC
add wave -noupdate -group Decode -radix decimal /cpu_tb/dut/theDecStage/brAddrExt
add wave -noupdate -group Decode -radix decimal /cpu_tb/dut/theDecStage/condAddrExt
add wave -noupdate -group Decode -radix decimal /cpu_tb/dut/theDecStage/DecImmBranch
add wave -noupdate -group Decode -radix decimal /cpu_tb/dut/theDecStage/shiftedAddr
add wave -noupdate -group Control /cpu_tb/dut/theControlSignals/Instruction
add wave -noupdate -group Control /cpu_tb/dut/theControlSignals/NegativeFlag
add wave -noupdate -group Control /cpu_tb/dut/theControlSignals/OverflowFlag
add wave -noupdate -group Control /cpu_tb/dut/theControlSignals/ZeroFlag
add wave -noupdate -group Control /cpu_tb/dut/theControlSignals/BLTBrTaken
add wave -noupdate -group Control /cpu_tb/dut/theControlSignals/ALUOp
add wave -noupdate -group Control /cpu_tb/dut/theControlSignals/BrTaken
add wave -noupdate -group Control /cpu_tb/dut/theControlSignals/ALUSrc
add wave -noupdate -group Control /cpu_tb/dut/theControlSignals/Mem2Reg
add wave -noupdate -group Control /cpu_tb/dut/theControlSignals/Reg2Loc
add wave -noupdate -group Control /cpu_tb/dut/theControlSignals/Reg2Write
add wave -noupdate -group Control /cpu_tb/dut/theControlSignals/RegWrite
add wave -noupdate -group Control /cpu_tb/dut/theControlSignals/MemWrite
add wave -noupdate -group Control /cpu_tb/dut/theControlSignals/MemRead
add wave -noupdate -group Control /cpu_tb/dut/theControlSignals/UncondBr
add wave -noupdate -group Control /cpu_tb/dut/theControlSignals/FlagWrite
add wave -noupdate -group Control /cpu_tb/dut/theControlSignals/OpCodes
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
