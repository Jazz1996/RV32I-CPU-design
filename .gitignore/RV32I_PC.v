`timescale 1ns / 1ps
`include "DEFINES.v"

module RV32I_PC (
    input                     rst,
	input                     clk,
	input                     id_ctrl_flag,
	input                     ex_ctrl_flag,
	input                     ex_jump_flag,
	input      [`InstAddrBus] ex_offset,
	input      [`InstAddrBus] ex_jump_pc,
	output reg [`InstAddrBus] pc
	);
	
	always @ ( posedge clk ) begin
	    if ( rst == `ResetEnable ) begin
		    pc <= `InitInstAddr0;
		end
		
		else if ( id_ctrl_flag == 1'b1 ) begin
		    pc <= pc;
		end
		
		else if ( ex_ctrl_flag == 1'b1 ) begin
		    pc <= pc + ex_offset;
		end
		
		else if ( ex_jump_flag == 1'b1 ) begin
		    pc <= ex_jump_pc;
		end
		
		else begin
		    pc <= pc + 4'h4;
		end
	end
	
endmodule
