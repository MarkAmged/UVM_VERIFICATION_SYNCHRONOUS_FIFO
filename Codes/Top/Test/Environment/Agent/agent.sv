package fifo_agent_pkg;
import fifo_sequencer_pkg::*;
import fifo_config_pkg::*;
import fifo_driver_pkg::*;
import fifo_monitor_pkg::*;
import fifo_sequence_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
	class fifo_agent extends uvm_agent;

		`uvm_component_utils(fifo_agent)

		fifo_sequencer sqr;
		fifo_driver drv;
		fifo_monitor mon;
		fifo_config fifo_cfg;
		uvm_analysis_port #(fifo_sequence_item) agt_port;

		function new(string name = "fifo_agent" , uvm_component parent = null);
			super.new(name , parent);
		endfunction

		// Inside the build_phase, build the driver
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			if(!uvm_config_db#(fifo_config)::get(this, "", "VIF", fifo_cfg)) 
				`uvm_fatal("build_phase","unable to get the configuration object");

			sqr = fifo_sequencer::type_id::create("sqr",this);
			drv = fifo_driver::type_id::create("drv",this);
			mon = fifo_monitor::type_id::create("mon",this);
			agt_port = new("agt_port", this);
		endfunction	

		function void connect_phase(uvm_phase phase);
			drv.fifo_vif = fifo_cfg.fifo_vif;
			mon.fifo_vif = fifo_cfg.fifo_vif;
			drv.seq_item_port.connect(sqr.seq_item_export);
			mon.mon_ap.connect(agt_port);
		endfunction

	endclass
endpackage