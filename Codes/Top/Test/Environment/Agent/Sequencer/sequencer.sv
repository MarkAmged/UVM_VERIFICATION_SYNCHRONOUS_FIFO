package fifo_sequencer_pkg;
import fifo_sequence_item_pkg::*;
import uvm_pkg::*;	
`include "uvm_macros.svh"	
	class fifo_sequencer extends uvm_sequencer #(fifo_sequence_item);
		`uvm_component_utils(fifo_sequencer);

		function new(string name = "fifo_sequencer" , uvm_component parent = null);
			super.new(name , parent);
		endfunction
	endclass
endpackage