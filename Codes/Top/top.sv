import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_test_pkg::*;
import shared_pkg::*;
module top();
	bit clk;
	initial begin
		clk = 0;
		forever
			#1 clk =~clk;
	end

	FIFO_interface fifo_if(clk);

	FIFO DUT(
 		fifo_if.clk,
 		fifo_if.rst_n,
 		fifo_if.wr_en,
 		fifo_if.rd_en,
 		fifo_if.data_in,
 		fifo_if.data_out,
 		fifo_if.wr_ack,
 		fifo_if.overflow,
 		fifo_if.full,
 		fifo_if.empty,
 		fifo_if.almostfull,
 		fifo_if.almostempty,
 		fifo_if.underflow);

	bind FIFO assertions SVA(
    	fifo_if.clk,
 		fifo_if.rst_n,
 		fifo_if.wr_en,
 		fifo_if.rd_en,
 		fifo_if.data_in,
 		fifo_if.data_out,
 		fifo_if.wr_ack,
 		fifo_if.overflow,
 		fifo_if.full,
 		fifo_if.empty,
 		fifo_if.almostfull,
 		fifo_if.almostempty,
 		fifo_if.underflow,
 		DUT.wr_ptr,
 		DUT.rd_ptr,
 		DUT.count);

	initial begin
		uvm_config_db#(virtual FIFO_interface)::set(null, "uvm_test_top", "FIFO_IF", fifo_if);
		run_test("fifo_test");
	end

endmodule