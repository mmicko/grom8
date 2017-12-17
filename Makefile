ifeq ($(OS),Windows_NT)
SILENT_OUT := >nul
EXE	:= .exe
else
SILENT_OUT := >/dev/null
EXE	:=
endif
.PHONY: all sim clean prog test test_alu test_cpu test_comp
all: grom.bin

sim: grom.out
	vvp grom.out

grom.bin: grom_top.v hex_to_7seg.v grom_computer.v ram_memory.v grom_cpu.v alu.v Go_Board_Constraints.pcf 
	yosys -q -p "synth_ice40 -abc2 -top grom_top -blif grom.blif" hex_to_7seg.v grom_computer.v ram_memory.v alu.v grom_cpu.v grom_top.v
	arachne-pnr -d 1k -P vq100 -p Go_Board_Constraints.pcf grom.blif -o grom.txt
	icepack grom.txt grom.bin
	icetime -d hx1k -P vq100 grom.txt

grom.out: grom_computer_tb.v ram_memory.v alu.v grom_cpu.v grom_computer.v 
	iverilog -D DISASSEMBLY -o grom.out grom_computer_tb.v ram_memory.v alu.v grom_cpu.v grom_computer.v

prog: grom.bin
	iceprog grom.bin

clean:
	$(RM) -f grom.blif grom.txt grom.bin grom.out rotor.out abc.history grom.vcd
	$(RM) -f -r obj_dir

test: test_alu test_cpu test_comp

test_comp: obj_dir/computer/Vgrom_computer$(EXE)
	@obj_dir/computer/Vgrom_computer$(EXE)

test_alu: obj_dir/alu/Valu$(EXE)
	@obj_dir/alu/Valu$(EXE)

test_cpu: obj_dir/cpu/Vgrom_cpu$(EXE)
	@obj_dir/cpu/Vgrom_cpu$(EXE)

obj_dir:
	@mkdir obj_dir

obj_dir/computer/Vgrom_computer$(EXE): obj_dir grom8.vlt grom_computer.v ram_memory.v grom_cpu.v alu.v test_comp.cpp
	@verilator_bin -Wall --Mdir obj_dir/computer --top-module grom_computer --cc grom8.vlt grom_computer.v ram_memory.v grom_cpu.v alu.v --exe test_comp.cpp
	@make -C obj_dir/computer -j -f Vgrom_computer.mk Vgrom_computer CC=gcc CXXFLAGS=-Wno-attributes VM_USER_DIR=../.. $(SILENT_OUT)

obj_dir/alu/Valu$(EXE): obj_dir grom8.vlt alu.v test_alu.cpp
	@verilator_bin -Wall --Mdir obj_dir/alu --top-module alu --cc grom8.vlt alu.v --exe test_alu.cpp
	@make -C obj_dir/alu -j -f Valu.mk Valu CC=gcc CXXFLAGS=-Wno-attributes VM_USER_DIR=../.. $(SILENT_OUT)

obj_dir/cpu/Vgrom_cpu$(EXE): obj_dir grom8.vlt grom_cpu.v alu.v test_cpu.cpp
	@verilator_bin -Wall --Mdir obj_dir/cpu --top-module grom_cpu --cc grom8.vlt grom_cpu.v alu.v --exe test_cpu.cpp
	@make -C obj_dir/cpu -j -f Vgrom_cpu.mk Vgrom_cpu CXXFLAGS=-Wno-attributes VM_USER_DIR=../.. $(SILENT_OUT)

