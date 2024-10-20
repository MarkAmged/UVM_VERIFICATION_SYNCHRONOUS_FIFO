package fifo_write_sequence_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_sequence_item_pkg::*;

	class fifo_write_sequence extends uvm_sequence #(fifo_sequence_item);
		`uvm_object_utils(fifo_write_sequence)

		fifo_sequence_item seq_item;

		function new(string name = "fifo_write_sequence");
			super.new(name);
		endfunction

		task body;
			repeat(10) begin
				seq_item=fifo_sequence_item::type_id::create("seq_item");
				start_item(seq_item);
				assert(seq_item.randomize() with {rst_n==1; wr_en==1; rd_en==0;});
				finish_item(seq_item);
			end
		endtask
		
	endclass

endpackage