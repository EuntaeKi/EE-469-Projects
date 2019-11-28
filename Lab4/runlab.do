# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.

vlog "./CPU.sv"
vlog "./InstructionFetch.sv"
vlog "./InstructionRegister.sv"
vlog "./ControlSignal.sv"
vlog "./ForwardingUnit.sv"
vlog "./InstructionDecode.sv"
vlog "./DecodeRegister.sv"
vlog "./Execute.sv"
vlog "./ExecRegister.sv"
vlog "./Memory.sv"
vlog "./MemoryRegister.sv"
vlog "./WriteBack.sv"
vlog "./ProgramCounter.sv"
vlog "./SignExtend.sv"
vlog "./regfile.sv"
vlog "./instructmem.sv"
vlog "./datamem.sv"
vlog "./register64.sv"
vlog "./register32.sv"
vlog "./registerN.sv"
vlog "./nor_64.sv"
vlog "./alu.sv"
vlog "./alu_1bit.sv"
vlog "./muxes.sv"
vlog "./fullAdder.sv"
vlog "./decoder3_8.sv"
vlog "./decoder2_4.sv"
vlog "./decoder5_32.sv"
vlog "./D_FF.sv"
vlog "./math.sv"
vlog "./FlagReg.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work cpu_tb

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do cpu_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
