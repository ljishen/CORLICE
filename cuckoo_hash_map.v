`define ADDR_WIDTH 64

module cuckoo_hash_map(in, out);

   input in;
   output out;
   
   

endmodule


module default_hash();
   parameter LG_NUM_BUCKETS = 2;   // 2^LG_NUM_BUCKETS is the number of buckets we're hashing into.
   
   parameter COE_A;
   parameter COE_B;

   function [`ADDR_WIDTH-1:0] hash;
      input [`ADDR_WIDTH-1:0] sva;
      reg [`ADDR_WIDTH/2-1:0] upper, lower, mask;
   
   begin
      upper = sva >> (`ADDR_WIDTH / 2);
      mask = (1 << (`ADDR_WIDTH / 2)) - 1;
      lower = sva & mask;

      hash = (upper * COE_A + lower * COE_B) >> (`ADDR_WIDTH - LG_NUM_BUCKETS);
   end
   endfunction
endmodule


module default_hash_tb();
   reg [`ADDR_WIDTH-1:0] res;
   
   default_hash #(.COE_A(32'h6f23ffab), .COE_B(32'h1f23ffab)) dh();
   
   initial
   begin
      res = dh.hash(`ADDR_WIDTH'h ffbbbbbbffbbbbbb);
      
      $display("sva is %h", dh.hash.sva);
      $display("upper is %h", dh.hash.upper);
      $display("lower is %h", dh.hash.lower);
      $display("res is %d", res);
   end
endmodule