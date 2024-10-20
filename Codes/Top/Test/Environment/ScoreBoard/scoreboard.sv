package fifo_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_sequence_item_pkg::*;
import shared_pkg::*;

	class fifo_scoreboard extends uvm_scoreboard;

		`uvm_component_utils(fifo_scoreboard)
		uvm_analysis_export #(fifo_sequence_item) sb_export;
		uvm_tlm_analysis_fifo #(fifo_sequence_item) sb_fifo;
		fifo_sequence_item seq_item_sb;

		logic [FIFO_WIDTH-1:0] data_out_ref;
		bit wr_ack_ref, overflow_ref;
		bit full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
		int error_count=0, correct_count=0;

		logic [FIFO_WIDTH-1:0] queue[$];

		function new(string name = "FIFO_scoreboard", uvm_component parent = null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			sb_export=new("sb_export",this);
			sb_fifo=new("sb_fifo",this);
		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			sb_export.connect(sb_fifo.analysis_export);
		endfunction

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				sb_fifo.get(seq_item_sb);
				check_data(seq_item_sb);
			end
		endtask


		function void report_phase(uvm_phase phase);
			super.report_phase(phase);
			`uvm_info("report_phase", $sformatf("At time %0t: Simulation Ends and Error Count= %0d, Correct Count= %0d", $time, error_count, correct_count), UVM_MEDIUM);
		endfunction


		function void check_data(fifo_sequence_item F_cd);
			reference_model(F_cd);
			outputs_check_assert: 
			assert(
				data_out_ref    === F_cd.data_out    &&
				wr_ack_ref      === F_cd.wr_ack      &&
				overflow_ref    === F_cd.overflow    &&
				full_ref        === F_cd.full        &&
		     	empty_ref       === F_cd.empty       &&
				almostfull_ref  === F_cd.almostfull  && 
			   	almostempty_ref === F_cd.almostempty &&
				underflow_ref   === F_cd.underflow
			) begin

				correct_count++; 
			end
			else begin
				error_count++;
				`uvm_error("run_phase", "Comparison Error");
			end

			outputs_check_cover: cover(
				data_out_ref    === F_cd.data_out    &&
				wr_ack_ref      === F_cd.wr_ack      &&
				overflow_ref    === F_cd.overflow    &&
				full_ref        === F_cd.full        &&
		     	empty_ref       === F_cd.empty       &&
				almostfull_ref  === F_cd.almostfull  && 
			   	almostempty_ref === F_cd.almostempty &&
				underflow_ref   === F_cd.underflow
			);
		endfunction


		function void reference_model(fifo_sequence_item F_rm);

			if (!F_rm.rst_n) begin
				queue.delete();
				underflow_ref=0;  overflow_ref=0; 
				wr_ack_ref=0;
			end 
			else begin
				if ( {F_rm.wr_en,F_rm.rd_en} == 2'b01 && queue.size() != 0 ) begin
					data_out_ref=queue.pop_front();
					wr_ack_ref=0;
				end 
				else if ( {F_rm.wr_en,F_rm.rd_en} == 2'b10 && queue.size() != FIFO_DEPTH ) begin
					queue.push_back(F_rm.data_in);
					wr_ack_ref=1;
				end
				else if ( {F_rm.wr_en,F_rm.rd_en} == 2'b11 ) begin
					if (queue.size() == FIFO_DEPTH) begin
						data_out_ref=queue.pop_front();
						wr_ack_ref=0;
					end else if (queue.size() == 0) begin
						queue.push_back(F_rm.data_in);
						wr_ack_ref=1;
					end else begin
						queue.push_back(F_rm.data_in);
						wr_ack_ref=1;
						data_out_ref=queue.pop_front();
					end
				end 
				else begin
					 wr_ack_ref=0;
				end
			end

			underflow_ref   = (!F_rm.rst_n)? 0:(empty_ref && F_rm.rd_en)? 1 : 0;
			overflow_ref    = (!F_rm.rst_n)? 0:(full_ref  && F_rm.wr_en)? 1 : 0;
			full_ref        = (queue.size() == FIFO_DEPTH)? 1 : 0;
			empty_ref       = (queue.size() == 0)? 1 : 0;
			almostfull_ref  = (queue.size() == FIFO_DEPTH-1)? 1 : 0; 
			almostempty_ref = (queue.size() == 1)? 1 : 0;

		endfunction

	endclass
	
endpackage