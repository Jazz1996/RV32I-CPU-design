`timescale 1ns / 1ps
`include "DEFINES.v"

module RV32I_EX (
    input                      rst,
	input                      ex_we_i,
	input        [`RegAddrBus] ex_waddr_i,
	input        [`AluOpBus]   ex_aluop_i,
	input        [`AluFun3Bus] ex_alufun3_i,
	input                      ex_alufun7_i,
	input        [`DataBus]    ex_alu1_i,
	input        [`DataBus]    ex_alu2_i,
	input signed [`DataBus]    ex_alus1_i,
	input signed [`DataBus]    ex_alus2_i,
	input                      ex_memce_i,
	input                      ex_memwe_i,
	input        [`DataBus]    ex_memdata_i,
	input        [`InstAddrBus]ex_offset_i,
	output   reg               ex_we_o,
	output   reg [`RegAddrBus] ex_waddr_o,
	output   reg [`DataBus]    ex_wdata_o,
	output   reg [2:0]         ex_mode_o,
	output   reg               ex_memce_o,
	output   reg               ex_memwe_o,
	output   reg [`DataBus]    ex_memdata_o,
	output   reg [`RamAddrBus] ex_memaddr_o,
	output   reg [`InstAddrBus]ex_offset_o,
	output   reg [`InstAddrBus]ex_jump_pc,
	
	output   reg               ex_ctrl_flag,
	output   reg               ex_jump_flag
	);
	
	reg [`DataBus] ex_result;
	reg [2:0]      ex_mode;
	
	always @ ( * ) begin
	    if ( rst == `ResetEnable ) begin
		    ex_result <= `ZeroWord;
		    ex_ctrl_flag <= 1'b0;
			ex_jump_flag <= 1'b0;
		end
		
		else begin
		    case ( ex_aluop_i )
			    `EXE_OP_LUI: begin
				    ex_result    <= ex_alu1_i + ex_alu2_i;
					ex_ctrl_flag <= 1'b0;
					ex_jump_flag <= 1'b0;
				end
				
				`EXE_OP_AUIPC: begin
				    ex_result    <= ex_alu1_i + ex_alu2_i;
					ex_ctrl_flag <= 1'b0;
					ex_jump_flag <= 1'b0;
				end
				
				`EXE_OP_JAL: begin
				    ex_result    <= ex_alu1_i + ex_alu2_i;
					ex_jump_pc   <= ex_alu1_i + ex_alu2_i;
					ex_ctrl_flag <= 1'b0;
					ex_jump_flag <= 1'b1;
				end
				
				`EXE_OP_RJUMP: begin
				    ex_ctrl_flag <= 1'b0;
					case ( ex_alufun3_i )
					    `EXE_RES_JALR: begin
						    ex_result    <= ex_alu1_i + ex_alu2_i;
							ex_jump_pc   <= ex_alu1_i + ex_alu2_i;
							ex_jump_flag <= 1'b1;
						end
						
						default: begin ex_jump_flag <= 1'b0; end
					endcase
				end
				
				`EXE_OP_BRANCH: begin
				    ex_jump_flag <= 1'b0;
					case ( ex_alufun3_i )
					    `EXE_RES_BEQ : begin ex_ctrl_flag <= ((ex_alu1_i == ex_alu2_i) ? 1'b1 : 1'b0); end
						`EXE_RES_BNE : begin ex_ctrl_flag <= ((ex_alu1_i != ex_alu2_i) ? 1'b1 : 1'b0); end
						`EXE_RES_BLT : begin ex_ctrl_flag <= ((ex_alus1_i < ex_alus2_i) ? 1'b1 : 1'b0); end
						`EXE_RES_BLTU: begin ex_ctrl_flag <= ((ex_alu1_i  < ex_alu2_i ) ? 1'b1 : 1'b0); end
						`EXE_RES_BGE : begin ex_ctrl_flag <= ((ex_alus1_i >= ex_alus2_i) ? 1'b1 : 1'b0); end
						`EXE_RES_BGEU: begin ex_ctrl_flag <= ((ex_alu1_i  >= ex_alu2_i ) ? 1'b1 : 1'b0); end
						default      : begin ex_ctrl_flag <= 1'b0; end
					endcase
				end
				
			    `EXE_OP_LOAD: begin
				    ex_result    <= ex_alus1_i + ex_alus2_i;
					ex_mode      <= ex_alufun3_i;
					ex_ctrl_flag <= 1'b0;
					ex_jump_flag <= 1'b0;
				end
				
				`EXE_OP_STORE: begin
				    ex_result    <= ex_alus1_i + ex_alus2_i;
					ex_mode      <= ex_alufun3_i;
					ex_ctrl_flag <= 1'b0;
					ex_jump_flag <= 1'b0;
				end
						
			    `EXE_OP_I: begin
				    ex_ctrl_flag <= 1'b0;
					ex_jump_flag <= 1'b0;
				    case ( ex_alufun3_i )
					    `EXE_RES_ADDI: begin ex_result <= ex_alu1_i + ex_alu2_i; end
						`EXE_RES_XORI: begin ex_result <= ex_alu1_i ^ ex_alu2_i; end
						`EXE_RES_ANDI: begin ex_result <= ex_alu1_i & ex_alu2_i; end
						`EXE_RES_ORI : begin ex_result <= ex_alu1_i | ex_alu2_i; end
						`EXE_RES_SLLI: begin ex_result <= ex_alu1_i << ex_alu2_i[4:0]; end
						`EXE_RES_SRI : begin
						    if ( ex_alufun7_i == 1'b0 ) begin
							    ex_result <= ex_alu1_i >> ex_alu2_i[4:0];
							end
							else begin
							    ex_result <= ({32{ex_alu1_i[31]}} << (6'd32 - {1'b0, ex_alu2_i[4:0]})) |
								             (ex_alu1_i >> ex_alu2_i[4:0]);
							end
						end
						`EXE_RES_SLTI: begin ex_result <= ((ex_alus1_i < ex_alus2_i) ? 1'b1 : 1'b0); end
						`EXE_RES_SLTIU:begin ex_result <= ((ex_alu1_i < ex_alu2_i) ? 1'b1 : 1'b0); end
						default: begin end
					endcase
				end
				
				`EXE_OP_R: begin
				    ex_ctrl_flag <= 1'b0;
					ex_jump_flag <= 1'b0;
				    case ( ex_alufun3_i )
					    `EXE_RES_ADD_SUB: begin
						    if ( ex_alufun7_i == 1'b0 ) begin
							    ex_result <= ex_alu1_i + ex_alu2_i;
							end
							else begin
							    ex_result <= ex_alu1_i - ex_alu2_i;
							end
						end
						`EXE_RES_XOR: begin ex_result <= ex_alu1_i ^ ex_alu2_i; end
						`EXE_RES_AND: begin ex_result <= ex_alu1_i & ex_alu2_i; end
						`EXE_RES_OR : begin ex_result <= ex_alu1_i | ex_alu2_i; end
						`EXE_RES_SLL: begin ex_result <= ex_alu1_i << ex_alu2_i[4:0]; end
						`EXE_RES_SR : begin
						    if ( ex_alufun7_i == 1'b0 ) begin
							    ex_result <= ex_alu1_i >> ex_alu2_i[4:0];
							end
							else begin
							    ex_result <= ({32{ex_alu1_i[31]}} << (6'd32 - {1'b0, ex_alu2_i[4:0]})) |
								             (ex_alu1_i >> ex_alu2_i[4:0]);
							end
						end
						`EXE_RES_SLT: begin ex_result <= ((ex_alus1_i < ex_alus2_i) ? 1'b1 : 1'b0); end
						`EXE_RES_SLTU:begin ex_result <= ((ex_alu1_i < ex_alu2_i) ? 1'b1 : 1'b0); end
						default: begin end
					endcase
				end
				
				default: begin end
			endcase
		end
	end
	
	always @ ( * ) begin
	    if ( rst == `ResetEnable ) begin
		    ex_we_o      <= `WriteDisable;
			ex_waddr_o   <= `regAddr0;
			ex_wdata_o   <= `ZeroWord;
			ex_memce_o   <= `ReadDisable;
			ex_memwe_o   <= `WriteDisable;
			ex_mode_o    <= 3'b000;
			ex_memdata_o <= `ZeroWord;
			ex_memaddr_o <= `ZeroWord;
			ex_offset_o  <= 32'h0;
		end
		
		else begin
		    ex_we_o      <= ex_we_i;
			ex_waddr_o   <= ex_waddr_i;
			ex_wdata_o   <= ex_result;
			ex_memce_o   <= ex_memce_i;
			ex_memwe_o   <= ex_memwe_i;
			ex_mode_o    <= ex_mode;
			ex_memdata_o <= ex_memdata_i;
			ex_memaddr_o <= ex_result;
			ex_offset_o  <= ex_offset_i;
		end
	end
	
endmodule
