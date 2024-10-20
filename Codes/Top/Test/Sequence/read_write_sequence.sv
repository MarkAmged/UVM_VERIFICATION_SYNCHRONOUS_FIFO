package fifo_read_write_sequence_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_sequence_item_pkg::*;

	class fifo_read_write_sequence extends uvm_sequence #(fifo_sequence_item);
		`uvm_object_utils(fifo_read_write_sequence)

		fifo_sequence_item seq_item;

		function new(string name = "fifo_read_write_sequence");
			super.new(name);
		endfunction

		task body;
			repeat(5000) begin
				seq_item=fifo_sequence_item::type_id::create("seq_item");
				start_item(seq_item);
				assert(seq_item.randomize());
				finish_item(seq_item);
			end
		endtask
		
	endclass

endpackage