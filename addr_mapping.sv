`define ADDR_WIDTH 64

typedef bit [`ADDR_WIDTH-1:0] addr_bits;

module addr_maping(in, out);

   input in;
   output out;
   
   default_hash dh();
   
   task generate_hash_functions;
      
   endtask

endmodule


module default_hash ();
   const int LG_NUM_BUCKETS = 2;   // 2^LG_NUM_BUCKETS is the number of buckets we're hashing into.

   addr_bits coe_a = {$urandom, $urandom};
   addr_bits coe_b = {$urandom, $urandom};

   function addr_bits hash;
      input addr_bits sva;
      bit [`ADDR_WIDTH/2-1:0] upper, lower, mask;
   
      upper = sva >> (`ADDR_WIDTH / 2);
      mask = (1 << (`ADDR_WIDTH / 2)) - 1;
      lower = sva & mask;

      hash = (upper * coe_a + lower * coe_b) >> (`ADDR_WIDTH - LG_NUM_BUCKETS);
   endfunction
   
   task refresh;
      coe_a = {$urandom, $urandom};
      coe_b = {$urandom, $urandom};
   endtask
   
endmodule