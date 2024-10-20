import shared_pkg::*;
module assertions(clk, rst_n, wr_en, rd_en, data_in, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow, wr_ptr, rd_ptr, count);

    input [FIFO_WIDTH-1:0] data_in;
    input clk, rst_n, wr_en, rd_en;
    input [FIFO_WIDTH-1:0] data_out;
    input wr_ack, overflow, full, empty, almostfull, almostempty, underflow;
    input [max_fifo_addr -1 :0] wr_ptr , rd_ptr;
    input [max_fifo_addr    :0] count;

//assertions and cover of sequential outputs
    overflow_assert_1    :assert property (@(posedge clk) disable iff(!rst_n) ((count == FIFO_DEPTH) && wr_en)   |=>(overflow)  );
    underflow_assert_1   :assert property (@(posedge clk) disable iff(!rst_n) ((count == 0)          && rd_en)   |=>(underflow) );
    wr_ack_assert_1      :assert property (@(posedge clk) disable iff(!rst_n) ((count != FIFO_DEPTH) && wr_en)   |=>(wr_ack)    ); 
    overflow_cover_1     :cover property  (@(posedge clk) disable iff(!rst_n) ((count == FIFO_DEPTH) && wr_en)   |=>(overflow)  );
    underflow_cover_1    :cover property  (@(posedge clk) disable iff(!rst_n) ((count == 0)          && rd_en)   |=>(underflow) );
    wr_ack_cover_1       :cover property  (@(posedge clk) disable iff(!rst_n) ((count != FIFO_DEPTH) && wr_en)   |=>(wr_ack)    );

    overflow_assert_2    :assert property (@(posedge clk) disable iff(!rst_n) ((count != FIFO_DEPTH) && wr_en)   |=>(overflow   == 0) );
    underflow_assert_2   :assert property (@(posedge clk) disable iff(!rst_n) ((count != 0)          && rd_en)   |=>(underflow) == 0  );
    wr_ack_assert_2      :assert property (@(posedge clk) disable iff(!rst_n) ((count == FIFO_DEPTH) && wr_en)   |=>(wr_ack)    == 0  );
    overflow_cover_2     :cover property  (@(posedge clk) disable iff(!rst_n) ((count != FIFO_DEPTH) && wr_en)   |=>(overflow)  == 0  );
    underflow_cover_2    :cover property  (@(posedge clk) disable iff(!rst_n) ((count != 0)          && rd_en)   |=>(underflow  == 0) );
    wr_ack_cover_2       :cover property  (@(posedge clk) disable iff(!rst_n) ((count == FIFO_DEPTH) && wr_en)   |=>(wr_ack)    == 0  );

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //assertions and cover of combinational outputs
    full_assert_1        :assert property (@(posedge clk)  (count==FIFO_DEPTH)   |-> full);
    empty_assert_1       :assert property (@(posedge clk)  (count==0)            |-> empty);
    almostfull_assert_1  :assert property (@(posedge clk)  (count==FIFO_DEPTH-1) |-> almostfull);
    almostempty_assert_1 :assert property (@(posedge clk)  (count==1)            |-> almostempty);
    full_cover_1         :cover  property (@(posedge clk)  (count==FIFO_DEPTH)   |-> full);
    empty_cover_1        :cover  property (@(posedge clk)  (count==0)            |-> empty);
    almostfull_cover_1   :cover  property (@(posedge clk)  (count==FIFO_DEPTH-1) |-> almostfull);
    almostempty_cover_1  :cover  property (@(posedge clk)  (count==1)            |-> almostempty);

    full_assert_2        :assert property (@(posedge clk)  (count!=FIFO_DEPTH)   |-> full        == 0);
    empty_assert_2       :assert property (@(posedge clk)  (count!=0)            |-> empty       == 0);
    almostfull_assert_2  :assert property (@(posedge clk)  (count!=FIFO_DEPTH-1) |-> almostfull  == 0);
    almostempty_assert_2 :assert property (@(posedge clk)  (count!=1)            |-> almostempty == 0);
    full_cover_2         :cover  property (@(posedge clk)  (count!=FIFO_DEPTH)   |-> full        == 0);
    empty_cover_2        :cover  property (@(posedge clk)  (count!=0)            |-> empty       == 0);
    almostfull_cover_2   :cover  property (@(posedge clk)  (count!=FIFO_DEPTH-1) |-> almostfull  == 0);
    almostempty_cover_2  :cover  property (@(posedge clk)  (count!=1)            |-> almostempty == 0);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    //assertions on counter
    rd_count_assert    :assert property (@(posedge clk) disable iff(!rst_n) (rd_en  && !wr_en && count !=0)                      |=>($past(count)-1'b1 == count));
    wr_count_assert    :assert property (@(posedge clk) disable iff(!rst_n) (!rd_en && wr_en  && count !=FIFO_DEPTH)             |=>($past(count)+1'b1 == count));
    rd_wr_count_assert :assert property (@(posedge clk) disable iff(!rst_n) (rd_en  && wr_en  && count !=0 && count!=FIFO_DEPTH) |=>($past(count)      == count));      
    rd_count_cover     :cover property  (@(posedge clk) disable iff(!rst_n) (rd_en  &&!wr_en  && count !=0)                      |=>($past(count)-1'b1 == count));
    wr_count_cover     :cover property  (@(posedge clk) disable iff(!rst_n) (!rd_en &&wr_en   && count !=FIFO_DEPTH)             |=>($past(count)+1'b1 == count));
    rd_wr_count_cover  :cover property  (@(posedge clk) disable iff(!rst_n) (rd_en  &&wr_en   &&count  !=0 && count!=FIFO_DEPTH) |=>($past(count)      == count));

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    //assertions on pointers
    rd_ptr_assert      :assert property (@(posedge clk) disable iff(!rst_n) (rd_en  && count!=0)           |=>($past(rd_ptr)+1'b1==rd_ptr));
    wr_ptr_assert      :assert property (@(posedge clk) disable iff(!rst_n) (wr_en  && count!=FIFO_DEPTH)  |=>($past(wr_ptr)+1'b1==wr_ptr));    
    rd_ptr_cover       :cover property  (@(posedge clk) disable iff(!rst_n) (rd_en  && count!=0)           |=>($past(rd_ptr)+1'b1==rd_ptr));
    wr_ptr_cover       :cover property  (@(posedge clk) disable iff(!rst_n) (wr_en  && count!=FIFO_DEPTH)  |=>($past(wr_ptr)+1'b1==wr_ptr));


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    //more assertions
    // if almostfull is HIGH and wr_en only is HIGH then the next cycle full will be HIGH
    almostfull_full_assert   :assert property (@(posedge clk) disable iff(!rst_n) (almostfull  && wr_en && !rd_en) |=> full);

    // if almostempty is HIGH and rd_en only is HIGH then the next cycle empty will be HIGH
    almostempty_empty_assert :assert property (@(posedge clk) disable iff(!rst_n) (almostempty && rd_en && !wr_en) |=> empty);

    almostfull_full_cover   :cover property (@(posedge clk) disable iff(!rst_n) (almostfull  && wr_en && !rd_en)   |=> full);
    almostempty_empty_cover :cover property (@(posedge clk) disable iff(!rst_n) (almostempty && rd_en && !wr_en)   |=> empty);


    always_comb begin  
        if(!rst_n)begin
            rst_count_assert       :assert final (count       == 0);
            rst_rd_ptr_assert      :assert final (rd_ptr      == 0);
            rst_wr_ptr_assert      :assert final (wr_ptr      == 0);
            rst_full_assert        :assert final (full        == 0);
            rst_empty_assert       :assert final (empty       == 1);
            rst_almostfull_assert  :assert final (almostfull  == 0);
            rst_almostempty_assert :assert final (almostempty == 0);
            //rst_data_out_assert    :assert final (data_out    == 0);
            rst_overflow_assert    :assert final (overflow    == 0);
            rst_underflow_assert   :assert final (underflow   == 0);
            rst_wr_ack_assert      :assert final (wr_ack      == 0);
            rst_count_cover        :cover final  (count       == 0);
            rst_rd_ptr_cover       :cover final  (rd_ptr      == 0);
            rst_wr_ptr_cover       :cover final  (wr_ptr      == 0);
            rst_full_cover         :cover final  (full        == 0);
            rst_empty_cover        :cover final  (empty       == 1);
            rst_almostfull_cover   :cover final  (almostfull  == 0);
            rst_almostempty_cover  :cover final  (almostempty == 0);
            //rst_data_out_cover     :cover final  (data_out    == 0);
            rst_overflow_cover     :cover final  (overflow    == 0);
            rst_underflow_cover    :cover final  (underflow   == 0);
            rst_wr_ack_cover       :cover final  (wr_ack      == 0);
        end
    end

endmodule