registers:
	make components
	ghdl -a -PCombinationalTools -PSequentialTools --std=08 registers.vhd
	ghdl -a --std=08 --ieee=synopsys testbench_reg.vhd
	ghdl -e --std=08 --ieee=synopsys test
	ghdl -r test --vcd=test.vcd
	
alu:
	make components
	ghdl -a -PCombinationalTools -PSequentialTools --std=08 alu.vhd
	ghdl -a -PCombinationalTools --std=08 --ieee=synopsys testbench_alu.vhd
	ghdl -e --std=08 --ieee=synopsys test
	ghdl -r test --vcd=test.vcd
	
instDecoder:
	make components
	ghdl -a -PCombinationalTools -PSequentialTools --std=08 instDecoder.vhd
	ghdl -a --std=08 --ieee=synopsys testbench_instDecoder.vhd
	ghdl -e --std=08 --ieee=synopsys test
	ghdl -r test --vcd=test.vcd
	
ualControler:
	make components
	ghdl -a -PCombinationalTools -PSequentialTools --std=08 ualControler.vhd
	ghdl -a --std=08 --ieee=synopsys testbench_ualControler.vhd
	ghdl -e --std=08 --ieee=synopsys test
	ghdl -r test --vcd=test.vcd
	
cpMux:
	make components
	ghdl -a -PCombinationalTools -PSequentialTools --std=08 CPMux.vhd
	ghdl -a --std=08 --ieee=synopsys testbench_CPMux.vhd
	ghdl -e --std=08 --ieee=synopsys test
	ghdl -r test --vcd=test.vcd
	
extension:
	make components
	ghdl -a -PCombinationalTools -PSequentialTools --std=08 extension.vhd
	ghdl -a --std=08 --ieee=synopsys testbench_extension.vhd
	ghdl -e --std=08 --ieee=synopsys test
	ghdl -r test --vcd=test.vcd
	
adder:
	make components
	ghdl -a -PCombinationalTools -PSequentialTools --std=08 adder.vhd
	ghdl -a --std=08 --ieee=synopsys testbench_adder.vhd
	ghdl -e --std=08 --ieee=synopsys test
	ghdl -r test --vcd=test.vcd
	
sram:
	make components
	ghdl -a  --std=08 --work=SequentialTools SequentialTools/sram.vhd
	ghdl -a -PSequentialTools --std=08 --ieee=synopsys testbench_sram.vhd
	ghdl -e --std=08 --ieee=synopsys test
	ghdl -r test --vcd=test.vcd
	
r3000:
	rm -f *.o *.vcd *.cf
	ghdl -a --std=08 --work=CombinationalTools CombinationalTools/decode.vhd
	ghdl -a --std=08 --work=CombinationalTools CombinationalTools/mux.vhd
	ghdl -a --std=08 --work=SequentialTools SequentialTools/reg_para.vhd
	ghdl -a --std=08 --work=CombinationalTools CombinationalTools/b_shifter.vhd
	ghdl -a  --std=08 --work=SequentialTools SequentialTools/sram.vhd
	ghdl -a -PCombinationalTools -PSequentialTools --std=08 registers.vhd
	ghdl -a -PCombinationalTools -PSequentialTools --std=08 alu.vhd
	ghdl -a -PCombinationalTools -PSequentialTools --std=08 instDecoder.vhd
	ghdl -a -PCombinationalTools -PSequentialTools --std=08 ualControler.vhd
	ghdl -a -PCombinationalTools -PSequentialTools --std=08 CPMux.vhd
	ghdl -a -PCombinationalTools -PSequentialTools --std=08 extension.vhd
	ghdl -a -PCombinationalTools -PSequentialTools --std=08 adder.vhd
	ghdl -a -PCombinationalTools -PSequentialTools --std=08 --ieee=synopsys R3000.vhd
	ghdl -a -PCombinationalTools -PSequentialTools --std=08 --ieee=synopsys testbench_r3000.vhd
	ghdl -e --std=08 --ieee=synopsys test
	ghdl -r test --vcd=test.vcd
	
components:
	rm -f *.o *.vcd *.cf
	ghdl -a --std=08 --work=CombinationalTools CombinationalTools/decode.vhd
	ghdl -a --std=08 --work=CombinationalTools CombinationalTools/mux.vhd
	ghdl -a --std=08 --work=SequentialTools SequentialTools/reg_para.vhd
	ghdl -a --std=08 --work=CombinationalTools CombinationalTools/b_shifter.vhd
	
clean:
	rm -f *.o *.vcd *.cf
