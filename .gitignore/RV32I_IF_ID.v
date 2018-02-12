`timescale 1ns / 1ps
`include "DEFINES.v"

module RV32I_IF_ID (
    input                     rst,
	input                     clk,
	input                     id_ctrl_flag,
	input                     ex_ctrl_flag,
	input      [`InstBus]     if_inst,
	input      [`InstAddrBus] if_pc,
	output reg [`InstBus]     id_inst,
	output reg [`InstAddrBus] id_pc
	);
	
	always @ ( posedge clk ) begin
	    if ( rst == `ResetEnable ) begin
		    id_pc   <= `InitInstAddr0;
			id_inst <= `NOP;
		end
		
		else if ( id_ctrl_flag == 1'b1 ) begin
		    id_pc   <= if_pc;
			id_inst <= `NOP;
		end
		
		else if ( ex_ctrl_flag == 1'b1 ) begin
		    id_pc   <= if_pc;
			id_inst <= `NOP;
		end
		
		else begin
		    id_pc   <= if_pc;
			id_inst <= if_inst;
		end
	end
	
endmodule
