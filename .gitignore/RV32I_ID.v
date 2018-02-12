`timescale 1ns / 1ps
`include "DEFINES.v"

module RV32I_ID (
    input                     rst,
	input      [`InstBus]     id_inst_i,
	input      [`InstAddrBus] id_pc_i,
	
	// ----- Reading from REGFILES module
	input      [`DataBus]     reg_rdata1_i,
	input      [`DataBus]     reg_rdata2_i,
	
	// ----- Ctrl Signal to REGFILES module
	output reg                reg_re1_o,
	output reg [`RegAddrBus]  reg_raddr1_o,
	output reg                reg_re2_o,
	output reg [`RegAddrBus]  reg_raddr2_o,
	
	output reg                csr_reg_flag,
	output reg [`RegAddrBus]  csr_reg_addr,
	
	// ----- Ctrl Signal to CSR module
	output reg                csr_re_o,
	output reg [`CSRAddrBus]  csr_raddr_o,
	output reg [`DataBus]     zimm,
	
	output reg                csr_we_o,
	
	// ----- Transfer to Next module
	output reg                id_we_o,
	output reg [`RegAddrBus]  id_waddr_o,
	output reg [`AluOpBus]    id_aluop_o,
	output reg [`AluFun3Bus]  id_alufun3_o,
	output reg                id_alufun7_o,
	output reg [`DataBus]     id_alu1_o,
	output reg [`DataBus]     id_alu2_o,
	output reg                id_memce_o,
	output reg                id_memwe_o,
	output reg [`DataBus]     id_memdata_o,
	
	output reg                id_ctrl_flag,
	output reg [`InstAddrBus] id_offset_o
	);
	
	reg [`DataBus] imm;
	
	wire [6:0] opcode;
	wire [3:0] funct3;
	wire [6:0] funct7;
	assign opcode = id_inst_i[6 :0 ];
	assign funct3 = id_inst_i[14:12];
	assign funct7 = id_inst_i[31:25];
	
	always @ ( * ) begin
	    if ( rst == `ResetEnable ) begin
		    id_aluop_o   <= `EXE_OP_I;
			id_alufun3_o <= `EXE_RES_ADDI;
			id_alufun7_o <= 1'b0;
			id_we_o      <= `WriteDisable;
			id_waddr_o   <= `regAddr0;
			reg_re1_o    <= `ReadDisable;
			reg_re2_o    <= `ReadDisable;
			reg_raddr1_o <= `regAddr0;
			reg_raddr2_o <= `regAddr0;
			id_memce_o   <= `ReadDisable;
			id_memwe_o   <= `WriteDisable;
			id_ctrl_flag <= 1'b0;
			imm          <= `ZeroWord;
			csr_reg_flag <= `WriteDisable;
			csr_re_o     <= `ReadDisable;
			csr_we_o     <= `WriteDisable;
			csr_raddr_o  <= 12'h0;
			zimm         <= `ZeroWord;
		end
		
		else begin
		    case ( opcode )
			    `EXE_OP_LUI: begin
				    id_aluop_o   <= `EXE_OP_LUI;
					id_alufun3_o <= funct3;
					id_alufun7_o <= 1'd0;
					id_we_o      <= `WriteEnable;
					id_waddr_o   <= id_inst_i[11:7 ];
					reg_re1_o    <= `ReadDisable;
					reg_re2_o    <= `ReadDisable;
					reg_raddr1_o <= `regAddr0;
					reg_raddr1_o <= `regAddr0;
					id_memce_o   <= `ReadDisable;
					id_memwe_o   <= `WriteDisable;
					id_ctrl_flag <= 1'd0;
					imm          <= {{id_inst_i[31:12]}, 12'h000};
					csr_reg_flag <= `WriteDisable;
					csr_re_o     <= `ReadDisable;
					csr_we_o     <= `WriteDisable;
					csr_raddr_o  <= 12'h0;
					zimm         <= `ZeroWord;
				end
				
				`EXE_OP_AUIPC: begin
				    id_aluop_o   <= `EXE_OP_AUIPC;
					id_alufun3_o <= funct3;
					id_alufun7_o <= 1'd0;
					id_we_o      <= `WriteEnable;
					id_waddr_o   <= id_inst_i[11:7 ];
					reg_re1_o    <= `ReadDisable;
					reg_re2_o    <= `ReadDisable;
					reg_raddr1_o <= `regAddr0;
					reg_raddr2_o <= `regAddr0;
					id_memce_o   <= `ReadDisable;
					id_memwe_o   <= `WriteDisable;
					id_ctrl_flag <= 1'd0;
					imm          <= {{id_inst_i[31:12]}, 12'h000};
					csr_reg_flag <= `WriteDisable;
					csr_re_o     <= `ReadDisable;
					csr_we_o     <= `WriteDisable;
					csr_raddr_o  <= 12'h0;
					zimm         <= `ZeroWord;
				end
				
				`EXE_OP_JAL: begin
				    id_aluop_o   <= `EXE_OP_JAL;
					id_alufun3_o <= funct3;
					id_alufun7_o <= 1'd0;
					id_we_o      <= `WriteEnable;
					id_waddr_o   <= id_inst_i[11:7 ];
					reg_re1_o    <= `ReadDisable;
					reg_re2_o    <= `ReadDisable;
					reg_raddr1_o <= `regAddr0;
					reg_raddr2_o <= `regAddr0;
					id_memce_o   <= `ReadDisable;
					id_memwe_o   <= `WriteDisable;
					id_ctrl_flag <= 1'b1;
					imm          <= {{12{id_inst_i[31]}}, {id_inst_i[19:12]}, {id_inst_i[20]}, {id_inst_i[30:21]}, 1'b0};
					csr_reg_flag <= `WriteDisable;
					csr_re_o     <= `ReadDisable;
					csr_we_o     <= `WriteDisable;
					csr_raddr_o  <= 12'h0;
					zimm         <= `ZeroWord;
				end
				
				`EXE_OP_RJUMP: begin
				    id_aluop_o   <= `EXE_OP_RJUMP;
					id_alufun3_o <= funct3;
					id_alufun7_o <= 1'd0;
					id_we_o      <= `WriteEnable;
					id_waddr_o   <= id_inst_i[11:7 ];
					reg_re1_o    <= `ReadEnable;
					reg_re2_o    <= `ReadDisable;
					reg_raddr1_o <= id_inst_i[19:15];
					reg_raddr2_o <= `regAddr0;
					id_memce_o   <= `ReadDisable;
					id_memwe_o   <= `WriteDisable;
					id_ctrl_flag <= 1'b1;
					imm          <= {{20{id_inst_i[31]}}, {id_inst_i[31:20]}};
					csr_reg_flag <= `WriteDisable;
					csr_re_o     <= `ReadDisable;
					csr_we_o     <= `WriteDisable;
					csr_raddr_o  <= 12'h0;
					zimm         <= `ZeroWord;
				end
				
				`EXE_OP_BRANCH: begin
				    id_aluop_o   <= `EXE_OP_BRANCH;
					id_alufun3_o <= funct3;
					id_alufun7_o <= 1'd0;
					id_we_o      <= `WriteDisable;
					id_waddr_o   <= `regAddr0;
					reg_re1_o    <= `ReadEnable;
					reg_re2_o    <= `ReadEnable;
					reg_raddr1_o <= id_inst_i[19:15];
					reg_raddr2_o <= id_inst_i[24:20];
					id_memce_o   <= `ReadDisable;
					id_memwe_o   <= `WriteDisable;
					id_ctrl_flag <= 1'b1;
					imm          <= {{20{id_inst_i[31]}}, {id_inst_i[7]}, {id_inst_i[30:25]}, {id_inst_i[11:8]}, 1'b0};
					csr_reg_flag <= `WriteDisable;
					csr_re_o     <= `ReadDisable;
					csr_we_o     <= `WriteDisable;
					csr_raddr_o  <= 12'h0;
					zimm         <= `ZeroWord;
				end
				
			    `EXE_OP_LOAD: begin
				    id_aluop_o   <= `EXE_OP_LOAD;
					id_alufun3_o <= funct3;
					id_alufun7_o <= 1'd0;
					id_we_o      <= `WriteEnable;
					id_waddr_o   <= id_inst_i[11:7 ];
					reg_re1_o    <= `ReadEnable;
					reg_re2_o    <= `ReadDisable;
					reg_raddr1_o <= id_inst_i[19:15];
					reg_raddr2_o <= `regAddr0;
					id_memce_o   <= `ReadEnable;
					id_memwe_o   <= `WriteDisable;
					id_ctrl_flag <= 1'b0;
					imm          <= {{20{id_inst_i[31]}}, {id_inst_i[31:20]}};
					csr_reg_flag <= `WriteDisable;
					csr_re_o     <= `ReadDisable;
					csr_we_o     <= `WriteDisable;
					csr_raddr_o  <= 12'h0;
					zimm         <= `ZeroWord;
				end
				
				`EXE_OP_STORE: begin
				    id_aluop_o   <= `EXE_OP_STORE;
					id_alufun3_o <= funct3;
					id_alufun7_o <= 1'd0;
					id_we_o      <= `WriteDisable;
					id_waddr_o   <= `regAddr0;
					reg_re1_o    <= `ReadEnable;
					reg_re2_o    <= `ReadEnable;
					reg_raddr1_o <= id_inst_i[19:15];
					reg_raddr2_o <= id_inst_i[24:20];
					id_memce_o   <= `ReadDisable;
					id_memwe_o   <= `WriteEnable;
					id_ctrl_flag <= 1'b0;
					imm          <= {{20{id_inst_i[31]}}, {id_inst_i[31:25]}, {id_inst_i[11:7]}};
					csr_reg_flag <= `WriteDisable;
					csr_re_o     <= `ReadDisable;
					csr_we_o     <= `WriteDisable;
					csr_raddr_o  <= 12'h0;
					zimm         <= `ZeroWord;
				end
				
			    `EXE_OP_I: begin
				    id_aluop_o   <= `EXE_OP_I;
					id_alufun3_o <= funct3;
					id_alufun7_o <= funct7[5];
					id_we_o      <= `WriteEnable;
					id_waddr_o   <= id_inst_i[11:7 ];
					reg_re1_o    <= `ReadEnable;
					reg_re2_o    <= `ReadDisable;
					reg_raddr1_o <= id_inst_i[19:15];
					reg_raddr2_o <= `regAddr0;
					id_memce_o   <= `ReadDisable;
					id_memwe_o   <= `WriteDisable;
					id_ctrl_flag <= 1'b0;
					imm          <= {{20{id_inst_i[31]}}, {id_inst_i[31:20]}};
					csr_reg_flag <= `WriteDisable;
					csr_re_o     <= `ReadDisable;
					csr_we_o     <= `WriteDisable;
					csr_raddr_o  <= 12'h0;
					zimm         <= `ZeroWord;
				end
				
				`EXE_OP_R: begin
				    id_aluop_o   <= `EXE_OP_R;
					id_alufun3_o <= funct3;
					id_alufun7_o <= funct7[5];
					id_we_o      <= `WriteEnable;
					id_waddr_o   <= id_inst_i[11:7 ];
					reg_re1_o    <= `ReadEnable;
					reg_re2_o    <= `ReadEnable;
					reg_raddr1_o <= id_inst_i[19:15];
					reg_raddr2_o <= id_inst_i[24:20];
					id_memce_o   <= `ReadDisable;
					id_memwe_o   <= `WriteDisable;
					id_ctrl_flag <= 1'b0;
					imm          <= `ZeroWord;
					csr_reg_flag <= `WriteDisable;
					csr_re_o     <= `ReadDisable;
					csr_we_o     <= `WriteDisable;
					csr_raddr_o  <= 12'h0;
					zimm         <= `ZeroWord;
				end
				
				`EXE_OP_SYSTEM: begin
				    id_aluop_o   <= `EXE_OP_SYSTEM;
					id_alufun3_o <= funct3;
					id_alufun7_o <= 1'd0;
					id_we_o      <= `WriteDisable;
					id_waddr_o   <= `regAddr0;
					reg_re1_o    <= `ReadEnable;
					reg_re2_o    <= `ReadDisable;
					reg_raddr1_o <= id_inst_i[19:15];
					reg_raddr2_o <= `regAddr0;
					id_memce_o   <= `ReadDisable;
					id_memwe_o   <= `WriteDisable;
					id_ctrl_flag <= 1'b0;
					imm          <= `ZeroWord;
					csr_reg_flag <= `WriteDisable;
					csr_re_o     <= `ReadEnable;
					csr_we_o     <= `WriteEnable;
					csr_raddr_o  <= id_inst_i[31:20];
					zimm         <= {27'h0, {id_inst_i[19:15]}};
				end
				
				default: begin end
			endcase
		end
	end
	
	always @ ( * ) begin
	    if ( rst == `ResetEnable ) begin
		    csr_reg_addr <= `regAddr0;
		end
		
		else begin
		    csr_reg_addr <= id_inst_i[11:7 ];
		end
	end
	
	// ----- Alu Operands Decoding
	always @ ( * ) begin
	    if ( rst == `ResetEnable ) begin
		    id_alu1_o <= `ZeroWord;
		end
		
		else if ( id_aluop_o == `EXE_OP_AUIPC || id_aluop_o == `EXE_OP_JAL ) begin
		    id_alu1_o <= id_pc_i;
		end
		
		else if ( reg_re1_o == `ReadEnable ) begin
		    id_alu1_o <= reg_rdata1_i;
		end
		
		else begin
		    id_alu1_o <= `ZeroWord;
		end
	end
	
	always @ ( * ) begin
	    if ( rst == `ResetEnable ) begin
		    id_alu2_o <= `ZeroWord;
		end
		
		else if ( reg_re2_o == `ReadDisable || id_aluop_o == `EXE_OP_STORE ) begin
		    id_alu2_o <= imm;
		end
		
		else if ( reg_re2_o == `ReadEnable ) begin
		    id_alu2_o <= reg_rdata2_i;
		end
		
		else begin
		    id_alu2_o <= `ZeroWord;
		end
	end
	
	// ----- Data Write to MEMORY
	always @ ( * ) begin
	    if ( rst == `ResetEnable ) begin
		    id_memdata_o <= `ZeroWord;
		end
		
		else if ( id_aluop_o == `EXE_OP_STORE ) begin
		    id_memdata_o <= reg_rdata2_i;
		end
		
		else begin
		    id_memdata_o <= `ZeroWord;
		end
	end
	
	// ----- BRANCH Offset
	always @ ( * ) begin
	    if ( rst == `ReadEnable ) begin
		    id_offset_o <= 32'h0;
		end
		
		else if ( id_aluop_o == `EXE_OP_BRANCH ) begin
		    id_offset_o <= imm;
		end
		
		else begin
		    id_offset_o <= 32'h0;
		end
	end
	
endmodule
