#include <iostream>
#include <memory>
#include "Vgrom_computer.h"
#include "verilated.h"

#define CATCH_CONFIG_RUNNER
#include "catch.hpp"

int main( int argc, char* argv[] )
{
  Verilated::commandArgs(argc, argv);
  int result = Catch::Session().run( argc, argv );
  return ( result < 0xff ? result : 0xff );  
}

TEST_CASE("Reset CPU", "Computer") 
{
	std::unique_ptr<Vgrom_computer> top = std::make_unique<Vgrom_computer>();

	top->clk = 0;
	top->reset = 1;
	
	top->clk ^= 1; top->eval();  // mid clock
	REQUIRE(top->hlt == 0);
	REQUIRE(top->grom_computer__DOT__cpu__DOT__state == top->grom_computer__DOT__cpu__DOT__STATE_RESET);
	top->clk ^= 1; top->eval();
	
	top->reset = 0;
	
	top->clk ^= 1; top->eval(); top->clk ^= 1; top->eval(); // one Clock
	
	REQUIRE(top->grom_computer__DOT__cpu__DOT__CS == 0);
	REQUIRE(top->grom_computer__DOT__cpu__DOT__DS == 0);
	REQUIRE(top->grom_computer__DOT__cpu__DOT__R[0] == 0);
	REQUIRE(top->grom_computer__DOT__cpu__DOT__R[1] == 0);
	REQUIRE(top->grom_computer__DOT__cpu__DOT__R[2] == 0);
	REQUIRE(top->grom_computer__DOT__cpu__DOT__R[3] == 0);
	REQUIRE(top->grom_computer__DOT__cpu__DOT__SP == 0xfff);	
}

TEST_CASE("Check memory", "Computer") 
{
	std::unique_ptr<Vgrom_computer> top = std::make_unique<Vgrom_computer>();
	top->clk ^= 1; top->eval(); top->clk ^= 1; top->eval(); // one Clock

	for(int i=0;i<0x1000;i++)
	{
		REQUIRE(top->grom_computer__DOT__memory__DOT__store[i] == 0);
	}	
}