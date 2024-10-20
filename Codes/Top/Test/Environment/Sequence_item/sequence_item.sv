package fifo_sequence_item_pkg;
import shared_pkg::*;	
import uvm_pkg::*;	
`include "uvm_macros.svh"
	class fifo_sequence_item extends uvm_sequence_item;
	  `uvm_object_utils(fifo_sequence_item);

	  parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    logic clk;
    rand logic [FIFO_WIDTH-1:0] data_in;
    rand logic rst_n;
    rand logic wr_en;
    rand logic rd_en;
    logic [FIFO_WIDTH-1:0] data_out , data_out_ref;
    logic wr_ack, overflow, full, empty, almostfull, almostempty, underflow;


    //Inside of this class add the FIFO inputs and outputs as class variables of the class as well as adding 2 integers (RD_EN_ON_DIST & WR_EN_ON_DIST) 
    int WR_EN_ON_DIST= 70;
    int RD_EN_ON_DIST= 30;

    function new( string name = "alsu_sequence_item");
      super.new(name);
    endfunction

    //////////////////////convert2string_functions///////////

    function string convert2string();
      return $sformatf("%s rst_n = 0b%0b , data_in = 0b%0b, wr_en = 0b%0b, rd_en = 0b%0b, data_out = 0b%0b, data_out_ref = 0b%0b,
       wr_ack = 0b%0b, overflow = 0b%0b, full = 0b%0b, empty = 0b%0b, almostfull = %0b ,almostempty = 0b%0b ,underflow = 0b%0b",
        super.convert2string() ,rst_n ,data_in , wr_en, rd_en, data_out, data_out_ref, wr_ack, overflow, full, empty , almostfull, almostempty ,underflow);
    endfunction

    function string convert2string_stimulus();
      return $sformatf("rst_n = 0b%0b , data_in = 0b%0b, wr_en = 0b%0b, rd_en = 0b%0b",rst_n, data_in, wr_en, rd_en);
    endfunction

    //Assert reset less often
    constraint reset_c {rst_n dist {1:/98 , 0:/2};}

    // Constraint the write enable to be high with distribution of the value WR_EN_ON_DIST & to be low with 100-WR_EN_ON_DIST
    constraint wr_en_c { wr_en dist {1 := WR_EN_ON_DIST, 0 := 100-WR_EN_ON_DIST}; }

    // Constraint the read enable the same as write enable but using RD_EN_ON_DIST
    constraint rd_en_c { rd_en dist {1 := RD_EN_ON_DIST, 0 := 100-RD_EN_ON_DIST}; }

    endclass
endpackage