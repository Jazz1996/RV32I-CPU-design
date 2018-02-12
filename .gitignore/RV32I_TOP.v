`timescale 1ns / 1ps
`include "DEFINES.v"

module RV32I_TOP (
    input                  rst,
	input                  clk,
	output wire [`DataBus] reg_wdata
	);
	
	// ----- interface of PC module
	wire                id_ctrl_flag;
	wire                ex_ctrl_flag;
	wire                ex_jump_flag;
	wire [`InstAddrBus] if_pc;
	wire [`InstAddrBus] ex_jump_pc;
	
	// ----- interface of ROM module
	wire [`InstBus]     if_inst_o;
	
	// ----- interface of REGFILES module
	wire                reg_we; 
	wire [`RegAddrBus]  reg_waddr;
	wire                reg_re1;
	wire [`RegAddrBus]  reg_raddr1;
	wire [`DataBus]     reg_rdata1;
	wire                reg_re2; 
	wire [`RegAddrBus]  reg_raddr2;
	wire [`DataBus]     reg_rdata2;
	
	// ----- interface of CSR module
	wire [`DataBus]     csr_rdata;
	
	// ----- interface of ID module
	wire [`InstAddrBus] id_pc_i;
	wire [`InstBus]     id_inst_i;
	wire                id_we_o;
	wire [`RegAddrBus]  id_waddr_o;
	wire [`AluOpBus]    id_aluop_o;
	wire [`AluFun3Bus]  id_alufun3_o;
	wire                id_alufun7_o;
	wire [`DataBus]     id_alu1_o;
	wire [`DataBus]     id_alu2_o;
	wire                id_memce_o;
	wire                id_memwe_o;
	wire [`DataBus]     id_memdata_o;
	wire [`InstAddrBus] id_offset_o;
	
	wire                csr_reg_flag;
	wire [`RegAddrBus]  csr_reg_addr;
	
	wire                csr_re_o;
	wire [`CSRAddrBus]  csr_raddr_o;
	wire [`DataBus]     zimm;
	
	wire                csr_we_o;
	
	// ----- interface of EX_SYSTEM module
	wire                ex_system_csr_we;
	wire [`DataBus]     ex_system_zimm;
	wire [`DataBus]     ex_system_reg_rdata;
	wire [`DataBus]     ex_system_csr_rdata;
	wire [`CSRAddrBus]  ex_system_csr_raddr;
	wire [`AluFun3Bus]  ex_system_alufun3;
	
	wire                csr_we;
	wire [`DataBus]     csr_wdata;
	wire [`CSRAddrBus]  csr_waddr;
	
	// ----- interface of EX module
	wire                ex_we_i;
	wire [`RegAddrBus]  ex_waddr_i;
	wire [`AluOpBus]    ex_aluop_i;
	wire [`AluFun3Bus]  ex_alufun3_i;
	wire                ex_alufun7_i;
	wire [`DataBus]     ex_alu1_i;
	wire [`DataBus]     ex_alu2_i;
	wire [`DataBus]     ex_alus1_i;
	wire [`DataBus]     ex_alus2_i;
	wire                ex_memce_i;
	wire                ex_memwe_i;
	wire [`DataBus]     ex_memdata_i;
	wire [`InstAddrBus] ex_offset_i;
	wire                ex_we_o;
	wire [`RegAddrBus]  ex_waddr_o;
	wire [`DataBus]     ex_wdata_o;
	wire [2:0]          ex_mode_o;
	wire                ex_memce_o;
	wire                ex_memwe_o;
	wire [`DataBus]     ex_memdata_o;
	wire [`RamAddrBus]  ex_memaddr_o;
	wire [`InstAddrBus] ex_offset_o;
	
	// ----- interface of MEM module
	wire                mem_we_i;
	wire [`RegAddrBus]  mem_waddr_i;
	wire [`DataBus]     mem_wdata_i;
	wire [2:0]          mem_mode_i;
	wire                mem_memce_i;
	wire                mem_memwe_i;
	wire [`DataBus]     mem_memdata_i;
	wire [`RamAddrBus]  mem_memaddr_i;
	wire                mem_we_o;
	wire [`RegAddrBus]  mem_waddr_o;
	wire [`DataBus]     mem_wdata_o;
	
	// ----- interface of RAM
	wire                ram_ce;
	wire                ram_we;
	wire [3:0]          ram_mode;
	wire [`RamAddrBus]  ram_addr;
	wire [`DataBus]     ram_data_i;
	wire [`DataBus]     ram_data_o;
	
	// ----- Instantiate PC module
	RV32I_PC RV32I_PC0 (
	    .rst( rst ),
		.clk( clk ),
		.id_ctrl_flag( id_ctrl_flag ),
		.ex_ctrl_flag( ex_ctrl_flag ),
		.ex_jump_flag( ex_jump_flag ),
		.ex_offset( ex_offset_o ),
		.ex_jump_pc( ex_jump_pc ),
		.pc( if_pc )
		);
		
	RV32I_ROM RV32I_ROM0 (
	    .rst( rst ),
		.pc( if_pc ),
		.inst_o( if_inst_o )
		);
		
	RV32I_IF_ID RV32I_IF_ID0 (
	    .rst( rst ),
		.clk( clk ),
		.id_ctrl_flag( id_ctrl_flag ),
		.ex_ctrl_flag( ex_ctrl_flag ),
		.if_inst( if_inst_o ),
		.if_pc( if_pc ),
		.id_inst( id_inst_i ),
		.id_pc( id_pc_i )
		);
		
	RV32I_ID RV32I_ID0 (
	    .rst( rst ),
		.id_inst_i( id_inst_i ),
		.id_pc_i( id_pc_i ),
		.reg_rdata1_i( reg_rdata1 ),
		.reg_rdata2_i( reg_rdata2 ),
		.reg_re1_o( reg_re1 ),
		.reg_raddr1_o( reg_raddr1 ),
		.reg_re2_o( reg_re2 ),
		.reg_raddr2_o( reg_raddr2 ),
		.csr_reg_flag( csr_reg_flag ),
		.csr_reg_addr( csr_reg_addr ),
		.csr_re_o( csr_re_o ),
		.csr_raddr_o( csr_raddr_o ),
		.zimm( zimm ),
		.csr_we_o( csr_we_o ),
		.id_we_o( id_we_o ),
		.id_waddr_o( id_waddr_o ),
		.id_aluop_o( id_aluop_o ),
		.id_alufun3_o( id_alufun3_o ),
		.id_alufun7_o( id_alufun7_o ),
		.id_alu1_o( id_alu1_o ),
		.id_alu2_o( id_alu2_o ),
		.id_memce_o( id_memce_o ),
		.id_memwe_o( id_memwe_o ),
		.id_memdata_o( id_memdata_o ),
		.id_ctrl_flag( id_ctrl_flag ),
		.id_offset_o( id_offset_o )
		);
		
	RV32I_REGFILES RV32I_REGFILES0 (
	    .rst( rst ),
		.clk( clk ),
		.csr_reg_flag( csr_reg_flag ),
		.csr_reg_addr( csr_reg_addr ),
		.csr_rdata( csr_rdata ),
		.reg_we_i( reg_we ),
		.reg_waddr_i( reg_waddr ),
		.reg_wdata_i( reg_wdata ),
		.reg_re1_i( reg_re1 ),
		.reg_raddr1_i( reg_raddr1 ),
		.reg_rdata1_o( reg_rdata1 ),
		.reg_re2_i( reg_re2 ),
		.reg_raddr2_i( reg_raddr2 ),
		.reg_rdata2_o( reg_rdata2 )
		);
		
	RV32I_CSR RV32I_CSR0 (
	    .rst( rst ),
		.clk( clk ),
		.csr_we( csr_we ),
		.csr_re( csr_re_o ),
		.csr_waddr( csr_waddr ),
		.csr_raddr( csr_raddr_o ),
		.csr_wdata( csr_wdata ),
		.csr_rdata( csr_rdata )
		);
		
	RV32I_ID_EX_SYSTEM RV32I_ID_EX_SYSTEM0 (
	    .rst( rst ),
		.clk( clk ),
		.csr_we( csr_we_o ),
		.zimm( zimm ),
		.reg_rdata( reg_rdata1 ),
		.csr_rdata( csr_rdata ),
		.csr_raddr( csr_raddr_o ),
		.id_alufun3( id_alufun3_o ),
		.ex_system_csr_we( ex_system_csr_we ),
		.ex_system_zimm( ex_system_zimm ),
		.ex_system_reg_rdata( ex_system_reg_rdata ),
		.ex_system_csr_rdata( ex_system_csr_rdata ),
		.ex_system_csr_raddr( ex_system_csr_raddr ),
		.ex_system_alufun3( ex_system_alufun3 )
		);
		
	RV32I_EX_SYSTEM RV32I_EX_SYSTEM0 (
	    .rst( rst ),
		.ex_system_csr_we( ex_system_csr_we ),
		.ex_system_zimm( ex_system_zimm ),
		.ex_system_reg_rdata( ex_system_reg_rdata ),
		.ex_system_csr_rdata( ex_system_csr_rdata ),
		.ex_system_csr_raddr( ex_system_csr_raddr ),
		.ex_system_alufun3( ex_system_alufun3 ),
		.csr_we( csr_we ),
		.csr_wdata( csr_wdata ),
		.csr_waddr( csr_waddr )
		);
		
	RV32I_ID_EX RV32I_ID_EX0 (
	    .rst( rst ),
		.clk( clk ),
		.id_we( id_we_o ),
		.id_waddr( id_waddr_o ),
		.id_aluop( id_aluop_o ),
		.id_alufun3( id_alufun3_o ),
		.id_alufun7( id_alufun7_o ),
		.id_alu1( id_alu1_o ),
		.id_alu2( id_alu2_o ),
		.id_memce( id_memce_o ),
		.id_memwe( id_memwe_o ),
		.id_memdata( id_memdata_o ),
		.id_offset( id_offset_o ),
		.ex_we( ex_we_i ),
		.ex_waddr( ex_waddr_i ),
		.ex_aluop( ex_aluop_i ),
		.ex_alufun3( ex_alufun3_i ),
		.ex_alufun7( ex_alufun7_i ),
		.ex_alu1( ex_alu1_i ),
		.ex_alu2( ex_alu2_i ),
		.ex_memce( ex_memce_i ),
		.ex_memwe( ex_memwe_i ),
		.ex_memdata( ex_memdata_i ),
		.ex_offset( ex_offset_i )
		);
		
	RV32I_EX RV32I_EX0 (
	    .rst( rst ),
		.ex_we_i( ex_we_i ),
		.ex_waddr_i( ex_waddr_i ),
		.ex_aluop_i( ex_aluop_i ),
		.ex_alufun3_i( ex_alufun3_i ),
		.ex_alufun7_i( ex_alufun7_i ),
		.ex_alu1_i( ex_alu1_i ),
		.ex_alu2_i( ex_alu2_i ),
		.ex_alus1_i( ex_alu1_i ),
		.ex_alus2_i( ex_alu2_i ),
		.ex_memce_i( ex_memce_i ),
		.ex_memwe_i( ex_memwe_i ),
		.ex_memdata_i( ex_memdata_i ),
		.ex_offset_i( ex_offset_i ),
		.ex_we_o( ex_we_o ),
		.ex_waddr_o( ex_waddr_o ),
		.ex_wdata_o( ex_wdata_o ),
		.ex_mode_o( ex_mode_o ),
		.ex_memce_o( ex_memce_o ),
		.ex_memwe_o( ex_memwe_o ),
		.ex_memdata_o( ex_memdata_o ),
		.ex_memaddr_o( ex_memaddr_o ),
		.ex_offset_o( ex_offset_o ),
		.ex_jump_pc( ex_jump_pc ),
		.ex_ctrl_flag( ex_ctrl_flag ),
		.ex_jump_flag( ex_jump_flag )
		);
		
	RV32I_EX_MEM RV32I_EX_MEM0 (
	    .rst( rst ),
		.clk( clk ),
		.ex_we( ex_we_o ),
		.ex_waddr( ex_waddr_o ),
		.ex_wdata( ex_wdata_o ),
		.ex_mode( ex_mode_o ),
		.ex_memce( ex_memce_o ),
		.ex_memwe( ex_memwe_o ),
		.ex_memdata( ex_memdata_o ),
		.ex_memaddr( ex_memaddr_o ),
		.mem_we( mem_we_i ),
		.mem_waddr( mem_waddr_i ),
		.mem_wdata( mem_wdata_i ),
		.mem_mode( mem_mode_i ),
		.mem_memce( mem_memce_i ),
		.mem_memwe( mem_memwe_i ),
		.mem_memdata( mem_memdata_i ),
		.mem_memaddr( mem_memaddr_i )
		);
		
	RV32I_MEM RV32I_MEM0 (
	    .rst( rst ),
		.mem_we_i( mem_we_i ),
		.mem_waddr_i( mem_waddr_i ),
		.mem_wdata_i( mem_wdata_i ),
		.mem_mode_i( mem_mode_i ),
		.mem_memce_i( mem_memce_i ),
		.mem_memwe_i( mem_memwe_i ),
		.mem_memdata_i( mem_memdata_i ),
		.mem_memaddr_i( mem_memaddr_i ),
		.ram_data_i( ram_data_o ),
		.ram_ce_o( ram_ce ),
		.ram_we_o( ram_we ),
		.ram_addr_o( ram_addr ),
		.ram_data_o( ram_data_i ),
		.ram_mode_o( ram_mode ),
		.mem_we_o( mem_we_o ),
		.mem_waddr_o( mem_waddr_o ),
		.mem_wdata_o( mem_wdata_o )
		);
		
	RV32I_RAM RV32I_RAM0 (
	    .rst( rst ),
		.clk( clk ),
		.ram_ce_i( ram_ce ),
		.ram_we_i( ram_we ),
		.ram_mode_i( ram_mode ),
		.ram_addr_i( ram_addr ),
		.ram_data_i( ram_data_i ),
		.ram_data_o( ram_data_o )
		);
		
	RV32I_MEM_WB RV32I_MEM_WB0 (
	    .rst( rst ),
		.clk( clk ),
		.mem_we( mem_we_o ),
		.mem_waddr( mem_waddr_o ),
		.mem_wdata( mem_wdata_o ),
		.reg_we( reg_we ),
		.reg_waddr( reg_waddr ),
		.reg_wdata( reg_wdata )
		);
		
endmodule
