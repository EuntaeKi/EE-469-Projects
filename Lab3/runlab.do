# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.

vlog "./fullAdder.sv"
vlog "./MUX2_1.sv"
vlog "./MUX4_1.sv"
vlog "./MUX8_1.sv"
vlog "./nor16_1.sv"
vlog "./aluBit.sv"
vlog "./alu.sv"
vlog "./signExtend.sv"
vlog "./datamem.sv"
vlog "./instructmem.sv"
vlog "./regfile.sv"
vlog "./MUX32_1.sv"
vlog "./decoder3_8.sv"
vlog "./decoder2_4.sv"
vlog "./decoder5_32.sv"
vlog "./D_FF.sv"
vlog "./specialD_FF.sv"
vlog "./regDecoder.sv"
vlog "./MUX64_32_1.sv"
vlog "./CPUdatapath.sv"
vlog "./CPUcontrol.sv"
vlog "./math.sv"
vlog "./fullAdder_64.sv"
vlog "./programCounter.sv"
vlog "./CPUtop.sv"
vlog "./clockDivider.sv"
vlog "./MUX64_2_1.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work CPUtop_testbench

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do CPUtop_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
