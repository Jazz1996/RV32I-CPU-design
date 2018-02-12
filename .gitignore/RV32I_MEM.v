`timescale 1ns / 1ps
`include "DEFINES.v"

module RV32I_MEM (
    input                    rst,
	input                    mem_we_i,
	input      [`RegAddrBus] mem_waddr_i,
	input      [`DataBus]    mem_wdata_i,
	input      [2:0]         mem_mode_i,
	input                    mem_memce_i,
	input                    mem_memwe_i,
	input      [`DataBus]    mem_memdata_i,
	input      [`RamAddrBus] mem_memaddr_i,
	
	// ****** Control Signals to Data Memory
	input      [`DataBus]    ram_data_i,
	output reg               ram_ce_o,
	output reg               ram_we_o,
	output reg [`RamAddrBus] ram_addr_o,
	output reg [`DataBus]    ram_data_o,
	output reg [3:0]         ram_mode_o,
	
	// ***** to Next Module
	output reg               mem_we_o,
	output reg [`RegAddrBus] mem_waddr_o,
	output reg [`DataBus]    mem_wdata_o
	);
	
	always @ ( * ) begin
	    if ( rst == `ResetEnable ) begin
		    ram_ce_o   <= `ReadDisable;
			ram_we_o   <= `WriteDisable;
			ram_addr_o <= `InitAddr0;
			ram_data_o <= `ZeroWord;
			ram_mode_o <= 4'b0000;
		end
		
		else if ( mem_memwe_i == `WriteEnable ) begin
		    ram_ce_o   <= `ReadDisable;
			ram_we_o   <= mem_memwe_i;
			ram_addr_o <= mem_memaddr_i - mem_memaddr_i[1:0];
			case ( mem_mode_i )
			    `EXE_RES_SB : begin
				    ram_data_o <= {{mem_memdata_i[7:0]}, {mem_memdata_i[7:0]}, {mem_memdata_i[7:0]}, {mem_memdata_i[7:0]}};
				    case ( mem_memaddr_i[1:0] )
					    2'b00: begin ram_mode_o <= 4'b0001; end
						2'b01: begin ram_mode_o <= 4'b0010; end
						2'b10: begin ram_mode_o <= 4'b0100; end
						2'b11: begin ram_mode_o <= 4'b1000; end
						default: begin ram_mode_o <= 4'b0000; end
					endcase
				end
				
				`EXE_RES_SH : begin
				    ram_data_o <= {{mem_memdata_i[15:0]}, {mem_memdata_i[15:0]}};
					case ( mem_memaddr_i[1:0] )
					    2'b00: begin ram_mode_o <= 4'b0011; end
						2'b10: begin ram_mode_o <= 4'b1100; end
						default: begin ram_mode_o <= 4'b0000; end
					endcase
				end
				
				`EXE_RES_SW : begin
				    ram_data_o <= mem_memdata_i;
					ram_mode_o <= 4'b1111;
				end
				
				default: begin
				    ram_data_o <= `ZeroWord;
					ram_mode_o <= `InitAddr0;
				end
			endcase
		end
		
		else if ( mem_memce_i == `ReadEnable ) begin
		    ram_ce_o   <= mem_memce_i;
			ram_we_o   <= `WriteDisable;
			ram_addr_o <= mem_memaddr_i - mem_memaddr_i[1:0];
			ram_data_o <= `ZeroWord;
			ram_mode_o <= 4'b0000;
		end
		
		else begin
		    ram_ce_o   <= `ReadDisable;
			ram_we_o   <= `WriteDisable;
			ram_addr_o <= `InitAddr0;
			ram_data_o <= `ZeroWord;
			ram_mode_o <= 4'b0000;
		end
	end
	
	always @ ( * ) begin
	    if ( rst == `ResetEnable ) begin
		    mem_we_o    <= `WriteDisable;
			mem_waddr_o <= `regAddr0;
			mem_wdata_o <= `ZeroWord;
		end
		
		else if ( mem_memce_i == `ReadEnable ) begin
		    mem_we_o    <= mem_we_i;
			mem_waddr_o <= mem_waddr_i;
			case ( mem_mode_i )
			    `EXE_RES_LB : begin
				    case ( mem_memaddr_i[1:0] )
					    2'b00: begin mem_wdata_o <= {{24{ram_data_i[ 7]}}, {ram_data_i[ 7: 0]}}; end
						2'b01: begin mem_wdata_o <= {{24{ram_data_i[15]}}, {ram_data_i[15: 8]}}; end
						2'b10: begin mem_wdata_o <= {{24{ram_data_i[23]}}, {ram_data_i[23:16]}}; end
						2'b11: begin mem_wdata_o <= {{24{ram_data_i[31]}}, {ram_data_i[31:24]}}; end
						default: begin mem_wdata_o <= `ZeroWord; end
					endcase
				end
				
				`EXE_RES_LH : begin
				    case ( mem_memaddr_i[1:0] )
					    2'b00: begin mem_wdata_o <= {{16{ram_data_i[15]}}, {ram_data_i[15: 0]}}; end
						2'b10: begin mem_wdata_o <= {{16{ram_data_i[31]}}, {ram_data_i[31:16]}}; end
						default: begin mem_wdata_o <= `ZeroWord; end
					endcase
				end
				
				`EXE_RES_LW : begin
				    mem_wdata_o <= ram_data_i;
				end
				
				`EXE_RES_LBU: begin
				    case ( mem_memaddr_i[1:0] )
					    2'b00: begin mem_wdata_o <= {{24'h0}, {ram_data_i[ 7: 0]}}; end
						2'b01: begin mem_wdata_o <= {{24'h0}, {ram_data_i[15: 7]}}; end
						2'b10: begin mem_wdata_o <= {{24'h0}, {ram_data_i[23:16]}}; end
						2'b11: begin mem_wdata_o <= {{24'h0}, {ram_data_i[31:24]}}; end
						default: begin mem_wdata_o <= `ZeroWord; end
					endcase
				end
					
				`EXE_RES_LHU: begin
				    case ( mem_memaddr_i[1:0] )
					    2'b00: begin mem_wdata_o <= {{16'h0}, {ram_data_i[15: 0]}}; end
						2'b10: begin mem_wdata_o <= {{16'h0}, {ram_data_i[31:16]}}; end
						default: begin mem_wdata_o <= `ZeroWord; end
					endcase
				end
				
				default: begin mem_wdata_o <= `ZeroWord; end
			endcase
		end
		
		else begin
		    mem_we_o    <= mem_we_i;
			mem_waddr_o <= mem_waddr_i;
			mem_wdata_o <= mem_wdata_i;
		end
	end
	
endmodule
