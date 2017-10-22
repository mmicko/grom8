#include <iostream>
#include <memory>
#include "Vgrom_cpu.h"
#include "verilated.h"

#define CATCH_CONFIG_RUNNER
#include "catch.hpp"

int main( int argc, char* argv[] )
{
  Verilated::commandArgs(argc, argv);
  int result = Catch::Session().run( argc, argv );
  return ( result < 0xff ? result : 0xff );  
}

TEST_CASE("Reset CPU", "CPU") 
{
	std::unique_ptr<Vgrom_cpu> top = std::make_unique<Vgrom_cpu>();

	top->clk = 0;
	top->reset = 1;
	
	top->clk ^= 1; top->eval();  // mid clock
	REQUIRE(top->hlt == 0);
	REQUIRE(top->grom_cpu__DOT__state == top->grom_cpu__DOT__STATE_RESET);
	top->clk ^= 1; top->eval();
	
	top->reset = 0;
	
	top->clk ^= 1; top->eval(); top->clk ^= 1; top->eval(); // one Clock
	
	REQUIRE(top->grom_cpu__DOT__CS == 0);
	REQUIRE(top->grom_cpu__DOT__DS == 0);
	REQUIRE(top->grom_cpu__DOT__R[0] == 0);
	REQUIRE(top->grom_cpu__DOT__R[1] == 0);
	REQUIRE(top->grom_cpu__DOT__R[2] == 0);
	REQUIRE(top->grom_cpu__DOT__R[3] == 0);
	REQUIRE(top->grom_cpu__DOT__SP == 0xfff);	
}

TEST_CASE("Fetch instruction", "CPU") 
{
	std::unique_ptr<Vgrom_cpu> top = std::make_unique<Vgrom_cpu>();

	top->clk = 0;
	
	top->data_in = 0x7f;
	
	top->clk ^= 1; top->eval(); top->clk ^= 1; top->eval(); // STATE_FETCH_PREP
	REQUIRE(top->grom_cpu__DOT__state == top->grom_cpu__DOT__STATE_FETCH_PREP);
	top->clk ^= 1; top->eval(); top->clk ^= 1; top->eval(); // STATE_FETCH_WAIT
	REQUIRE(top->grom_cpu__DOT__state == top->grom_cpu__DOT__STATE_FETCH_WAIT);
	top->clk ^= 1; top->eval(); top->clk ^= 1; top->eval(); // STATE_FETCH
	REQUIRE(top->grom_cpu__DOT__state == top->grom_cpu__DOT__STATE_FETCH);
	top->clk ^= 1; top->eval(); top->clk ^= 1; top->eval(); // STATE_EXECUTE
	REQUIRE(top->grom_cpu__DOT__state == top->grom_cpu__DOT__STATE_EXECUTE);
	
	REQUIRE(top->grom_cpu__DOT__IR == 0x7f);
}


void executeSimpleInstruction(Vgrom_cpu *top)
{
	top->clk ^= 1; top->eval(); top->clk ^= 1; top->eval(); // STATE_FETCH_PREP
	REQUIRE(top->grom_cpu__DOT__state == top->grom_cpu__DOT__STATE_FETCH_PREP);
	top->clk ^= 1; top->eval(); top->clk ^= 1; top->eval(); // STATE_FETCH_WAIT
	REQUIRE(top->grom_cpu__DOT__state == top->grom_cpu__DOT__STATE_FETCH_WAIT);
	top->clk ^= 1; top->eval(); top->clk ^= 1; top->eval(); // STATE_FETCH
	REQUIRE(top->grom_cpu__DOT__state == top->grom_cpu__DOT__STATE_FETCH);
	top->clk ^= 1; top->eval(); top->clk ^= 1; top->eval(); // STATE_EXECUTE
	REQUIRE(top->grom_cpu__DOT__state == top->grom_cpu__DOT__STATE_EXECUTE);
	top->clk ^= 1; top->eval(); top->clk ^= 1; top->eval(); // STATE_FETCH_PREP
	REQUIRE(top->grom_cpu__DOT__state == top->grom_cpu__DOT__STATE_FETCH_PREP);
}

TEST_CASE("HLT instruction", "CPU") 
{
	std::unique_ptr<Vgrom_cpu> top = std::make_unique<Vgrom_cpu>();

	top->clk = 0;
	
	top->data_in = 0x7f; // HLT
	executeSimpleInstruction(top.get());
	
	REQUIRE(top->hlt == 1);
}

TEST_CASE("After HLT cpu should remain in loop", "CPU") 
{
	std::unique_ptr<Vgrom_cpu> top = std::make_unique<Vgrom_cpu>();

	top->clk = 0;
	
	top->data_in = 0x7f; // HLT
	executeSimpleInstruction(top.get());

	REQUIRE(top->hlt == 1);
	
	REQUIRE(top->grom_cpu__DOT__state == top->grom_cpu__DOT__STATE_FETCH_PREP);
	top->clk ^= 1; top->eval(); top->clk ^= 1; top->eval(); // STATE_FETCH_WAIT
	REQUIRE(top->grom_cpu__DOT__state == top->grom_cpu__DOT__STATE_FETCH_WAIT);
	top->clk ^= 1; top->eval(); top->clk ^= 1; top->eval(); // STATE_FETCH
	
	REQUIRE(top->hlt == 1);
}
