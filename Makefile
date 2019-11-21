decoder:
	rm -f *.o *.vcd *.cf
	ghdl -a --std=08 --work=CombinationalTools CombinationalTools/decode.vhd
	ghdl -a -PCombinationalTools --std=08 --ieee=synopsys testbench_decoder.vhd
	ghdl -e --std=08 --ieee=synopsys test
	ghdl -r test --vcd=test.vcd
	
mux:
	rm -f *.o *.vcd *.cf
	ghdl -a --std=08 --work=CombinationalTools CombinationalTools/mux.vhd
	ghdl -a -PCombinationalTools --std=08 --ieee=synopsys testbench_mux.vhd
	ghdl -e --std=08 --ieee=synopsys test
	ghdl -r test --vcd=test.vcd
	
reg:
	rm -f *.o *.vcd *.cf
	ghdl -a --std=08 --work=SequentialTools SequentialTools/reg_para.vhd
	ghdl -a -PSequentialTools --std=08 --ieee=synopsys testbench_reg_para.vhd
	ghdl -e --std=08 --ieee=synopsys test
	ghdl -r test --vcd=test.vcd
	
registers:
	rm -f *.o *.vcd *.cf
	ghdl -a --std=08 --work=CombinationalTools CombinationalTools/decode.vhd
	ghdl -a --std=08 --work=CombinationalTools CombinationalTools/mux.vhd
	ghdl -a --std=08 --work=SequentialTools SequentialTools/reg_para.vhd
	ghdl -a -PCombinationalTools -PSequentialTools --std=08 registers.vhd
	ghdl -a --std=08 --ieee=synopsys testbench_reg.vhd
	ghdl -e --std=08 --ieee=synopsys test
	ghdl -r test --vcd=test.vcd
	
clean:
	rm -f *.o *.vcd *.cf
