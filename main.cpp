#include <iostream>
#include <memory>
#include "Vgrom_computer.h"
#include "verilated.h"

int main(int argc, char **argv, char **env) 
{
	Verilated::commandArgs(argc, argv);
	std::unique_ptr<Vgrom_computer> top = std::make_unique<Vgrom_computer>();

	top->clk = 0;
	top->reset = 1;	
	top->clk ^= 1; top->eval();
	top->clk ^= 1; top->eval();
	top->reset = 0;
	top->clk ^= 1; top->eval();

	for (int i=0;i<200;i++)
	{
		top->clk ^= 1; top->eval();
		top->clk ^= 1; top->eval();
		//printf("%02x\n",top->display_out);
	}
}