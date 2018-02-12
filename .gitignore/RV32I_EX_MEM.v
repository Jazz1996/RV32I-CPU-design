`timescale 1ns / 1ps
`include "DEFINES.v"

module RV32I_EX_MEM (
    input                    rst,
	input                    clk,
	input                    ex_we,
	input      [`RegAddrBus] ex_waddr,
	input      [`DataBus]    ex_wdata,
	input      [2:0]         ex_mode,
	input                    ex_memce,
	input                    ex_memwe,
	input      [`DataBus]    ex_memdata,
	input      [`RamAddrBus] ex_memaddr,
	output reg               mem_we,
	output reg [`RegAddrBus] mem_waddr,
	output reg [`DataBus]    mem_wdata,
	output reg [2:0]         mem_mode,
	output reg               mem_memce,
	output reg               mem_memwe,
	output reg [`DataBus]    mem_memdata,
	output reg [`RamAddrBus] mem_memaddr
	);
	
	always @ ( posedge clk ) begin
	    if ( rst == `ResetEnable ) begin
		    mem_we      <= `WriteDisable;
			mem_waddr   <= `regAddr0;
			mem_wdata   <= `ZeroWord;
			mem_mode    <= 3'b000;
			mem_memce   <= `ReadDisable;
			mem_memwe   <= `WriteDisable;
			mem_memdata <= `ZeroWord;
			mem_memaddr <= `ZeroWord;
		end
		
		else begin
		    mem_we      <= ex_we;
			mem_waddr   <= ex_waddr;
			mem_wdata   <= ex_wdata;
			mem_mode    <= ex_mode;
			mem_memce   <= ex_memce;
			mem_memwe   <= ex_memwe;
			mem_memdata <= ex_memdata;
			mem_memaddr <= ex_memaddr;
		end
	end
	
endmodule
