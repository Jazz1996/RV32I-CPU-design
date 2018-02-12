`timescale 1ns / 1ps
`include "DEFINES.v"

module RV32I_MEM_WB (
    input                    rst,
	input                    clk,
	input                    mem_we,
	input      [`RegAddrBus] mem_waddr,
	input      [`DataBus]    mem_wdata,
	output reg               reg_we,
	output reg [`RegAddrBus] reg_waddr,
	output reg [`DataBus]    reg_wdata
	);
	
	always @ ( posedge clk ) begin
	    if ( rst == `ResetEnable ) begin
		    reg_we    <= `WriteDisable;
			reg_waddr <= `regAddr0;
			reg_wdata <= `ZeroWord;
		end
		
		else begin
		    reg_we    <= mem_we;
			reg_waddr <= mem_waddr;
			reg_wdata <= mem_wdata;
		end
	end
endmodule
