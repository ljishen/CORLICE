`define ADDR_WIDTH 64

typedef bit [`ADDR_WIDTH-1:0] addr_bits;

module addr_maping(in, out);

   input in;
   output out;

   default_hash dh[1:0]();

   int num_buckets;
   always @(num_buckets) begin
      dh[0].update(num_buckets);
      dh[1].update(num_buckets);
   end
   
   initial begin
      num_buckets = 4;
   end
   
   /* Adds a new sva/spa pair to the hash map. If the key already existed,
    * its old value is displaced and the new value is written in its stead.
    */
   function addr_bits put(input addr_bits spa, sva);
      /* Check whether this value already exists. If so, just displace its
       * old value and hand it back.
       */
      repeat(2)
         begin
            
         end
   endfunction

endmodule


module default_hash ();
   int lg_num_buckets;
   addr_bits coe_a, coe_b;

   function addr_bits hash(input addr_bits sva);
      bit [`ADDR_WIDTH/2-1:0] upper, lower, mask;
   
      upper = sva >> (`ADDR_WIDTH / 2);
      mask = (1 << (`ADDR_WIDTH / 2)) - 1;
      lower = sva & mask;

      hash = (upper * coe_a + lower * coe_b) >> (`ADDR_WIDTH - lg_num_buckets);
   endfunction

   task update(input int num_buckets);
      automatic int lg_val = -1;
      while (num_buckets > 0) begin
         num_buckets = num_buckets >> 1;
         lg_val = lg_val + 1;
      end
      lg_num_buckets = lg_val;

      coe_a = {$urandom, $urandom};
      coe_b = {$urandom, $urandom};
   endtask
endmodule