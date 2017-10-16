.PHONY: all test clean prog

all: grom.bin

test: grom.out
	vvp grom.out

grom.bin: grom_top.v hex_to_7seg.v ram_memory.v grom_cpu.v alu.v Go_Board_Constraints.pcf 
	yosys -q -p "synth_ice40 -abc2 -nocarry -top grom_top -blif grom.blif" hex_to_7seg.v ram_memory.v alu.v grom_cpu.v grom_top.v
	arachne-pnr -d 1k -P vq100 -p Go_Board_Constraints.pcf grom.blif -o grom.txt
	icepack grom.txt grom.bin
	icetime -d hx1k -P vq100 grom.txt

grom.out: test.v ram_memory.v alu.v grom_cpu.v
	iverilog -o grom.out test.v ram_memory.v alu.v grom_cpu.v

prog: grom.bin
	iceprog grom.bin

clean:
	$(RM) -f grom.blif grom.txt grom.bin grom.out rotor.out abc.history grom.vcd
