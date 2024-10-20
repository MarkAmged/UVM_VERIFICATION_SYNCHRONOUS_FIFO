package fifo_test_pkg;
import fifo_env_pkg::*;
import fifo_config_pkg::*;
import fifo_reset_sequence_pkg::*;
import fifo_read_sequence_pkg::*;
import fifo_write_sequence_pkg::*;
import fifo_read_write_sequence_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
	class fifo_test extends uvm_test;
		`uvm_component_utils(fifo_test)
		fifo_env env;
		fifo_reset_sequence reset_sequence;
		fifo_write_sequence write_sequence;
		fifo_read_sequence read_sequence;
		fifo_read_write_sequence read_write_sequence;
		fifo_config fifo_cfg;
		function new(string name = "fifo_test", uvm_component parent = null);
			super.new(name,parent);
		endfunction
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			env                 =fifo_env::type_id::create("env",this);
			reset_sequence      =fifo_reset_sequence::type_id::create("reset_sequence");
			write_sequence      =fifo_write_sequence::type_id::create("write_sequence");
			read_sequence       =fifo_read_sequence::type_id::create("read_sequence");
			read_write_sequence =fifo_read_write_sequence::type_id::create("read_write_sequence");
			fifo_cfg            =fifo_config::type_id::create("fifo_cfg");
			if (!uvm_config_db#(virtual FIFO_interface)::get(this, "", "FIFO_IF", fifo_cfg.fifo_vif)) begin
				`uvm_fatal("build_phase", "TEST - unable to get the IF");
			end
			uvm_config_db#(fifo_config)::set(this, "*", "VIF", fifo_cfg);
		endfunction
		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			phase.raise_objection(this);
			// start the sequences
			`uvm_info("run_phase", "Reset Asserted", UVM_LOW);
			reset_sequence.start(env.agt.sqr);
			`uvm_info("run_phase", "Reset De-asserted", UVM_LOW);
			`uvm_info("run_phase", "write_sequence starts", UVM_LOW);
			write_sequence.start(env.agt.sqr);
			`uvm_info("run_phase", "write_sequence ends", UVM_LOW);
			`uvm_info("run_phase", "read_sequence starts", UVM_LOW);
			read_sequence.start(env.agt.sqr);
			`uvm_info("run_phase", "read_sequence ends", UVM_LOW);
			`uvm_info("run_phase", "read_write_sequence starts", UVM_LOW);
			read_write_sequence.start(env.agt.sqr);
			`uvm_info("run_phase", "read_write_sequence ends", UVM_LOW);
			`uvm_info("run_phase", "Reset Asserted", UVM_LOW);
			reset_sequence.start(env.agt.sqr);
			`uvm_info("run_phase", "Reset De-asserted", UVM_LOW);
			phase.drop_objection(this);
		endtask
	endclass
endpackage