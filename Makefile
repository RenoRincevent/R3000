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
	
components:
	rm -f *.o *.vcd *.cf
	ghdl -a --std=08 --work=CombinationalTools CombinationalTools/decode.vhd
	ghdl -a --std=08 --work=CombinationalTools CombinationalTools/mux.vhd
	ghdl -a --std=08 --work=SequentialTools SequentialTools/reg_para.vhd
	ghdl -a --std=08 --work=CombinationalTools CombinationalTools/b_shifter.vhd
	
clean:
	rm -f *.o *.vcd *.cf
