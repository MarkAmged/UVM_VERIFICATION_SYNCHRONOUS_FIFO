import shared_pkg::*;
interface  FIFO_interface(clk);
    input clk;
    logic [FIFO_WIDTH - 1:0] data_in;
    logic rst_n, wr_en, rd_en;
    logic [FIFO_WIDTH - 1:0] data_out;
    logic wr_ack, overflow, full, empty, almostfull, almostempty, underflow;
endinterface 