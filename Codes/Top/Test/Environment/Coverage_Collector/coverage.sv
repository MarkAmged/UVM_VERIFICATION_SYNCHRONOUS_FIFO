package fifo_coverage_pkg;
import shared_pkg::*;
import fifo_sequence_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_coverage extends uvm_component;
    `uvm_component_utils(fifo_coverage)
    uvm_analysis_export #(fifo_sequence_item) cov_export; 
    uvm_tlm_analysis_fifo #(fifo_sequence_item) cov_fifo;
    fifo_sequence_item cov_seq_item;

    covergroup read_write_cg;
            wr_en_cp:          coverpoint cov_seq_item.wr_en       {option.weight         = 0;}
            rd_en_cp:          coverpoint cov_seq_item.rd_en       {option.weight         = 0;}
            full_cp:           coverpoint cov_seq_item.full        {bins full_HIGH        = {1}; option.weight = 0;}
            empty_cp:          coverpoint cov_seq_item.empty       {bins empty_HIGH       = {1}; option.weight = 0;}
            overflow_cp:       coverpoint cov_seq_item.overflow    {bins overflow_HIGH    = {1}; option.weight = 0;}
            underflow_cp:      coverpoint cov_seq_item.underflow   {bins underflow_HIGH   = {1}; option.weight = 0;}
            wr_ack_cp:         coverpoint cov_seq_item.wr_ack      {bins wr_ack_HIGH      = {1}; option.weight = 0;}
            almostfull_cp:     coverpoint cov_seq_item.almostfull  {bins almostfull_HIGH  = {1}; option.weight = 0;}
            almostempty_cp:    coverpoint cov_seq_item.almostempty {bins almostempty_HIGH = {1}; option.weight = 0;}   



            almostfull_cross:   cross wr_en_cp, rd_en_cp, almostfull_cp;
            almostempty_cross:  cross wr_en_cp, rd_en_cp, almostempty_cp;


            // empty shouldn't be HIGH if write enable is 1 whatever read
            empty_cross:cross wr_en_cp,rd_en_cp,empty_cp iff(cov_seq_item.rst_n)        {
                illegal_bins empty_and_wr     =  binsof(wr_en_cp)intersect {1} && (binsof(rd_en_cp) intersect{0}  || binsof(rd_en_cp)  intersect{1}) && binsof(empty_cp) intersect{1};
            }
            // full shouldn't be HIGH if read enable is 1 whatever write
            full_cross:cross wr_en_cp , rd_en_cp , full_cp       {
                illegal_bins full_wr_rd       = (binsof(wr_en_cp)intersect {0} || binsof(wr_en_cp) intersect {1}) && binsof(rd_en_cp)  intersect{1} &&  binsof (full_cp) intersect{1};
            }
            // overflow shouldn't be HIGH if write enable is 0 
            overflow_cross:cross wr_en_cp ,rd_en_cp, overflow_cp {
                illegal_bins wr_and_over      = binsof(wr_en_cp)intersect {0} && binsof(overflow_cp)  intersect{1};
            }
            // underflow shouldn't be HIGH if read enable is 0 
            underflow_cross:cross wr_en_cp,rd_en_cp,underflow_cp {
                illegal_bins underflow_and_rd = binsof(rd_en_cp)intersect {0} && binsof(underflow_cp) intersect{1};
            }
            // write ack shouldn't be HIGH if write enable is 0
             wr_ack_cross:cross wr_en_cp , rd_en_cp , wr_ack_cp  {
                illegal_bins wr_and_wr_ack    = binsof(wr_en_cp)intersect {0} && binsof(wr_ack_cp)    intersect{1};
            }
        endgroup

    function new(string name = "fifo_coverage", uvm_component parent = null);
        super.new(name, parent);
        read_write_cg = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cov_export = new("cov_export", this);
        cov_fifo = new("cov_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        cov_export.connect(cov_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            cov_fifo.get(cov_seq_item);
            read_write_cg.sample();
        end
    endtask
endclass
endpackage