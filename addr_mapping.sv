`define ADDR_WIDTH 64
`define NUM_HASH_FUNC 2

typedef logic [`ADDR_WIDTH-1:0] addr_bits;

module addr_maping();
   parameter NUM_BUCKETS = 2 ** 27 - 1;

   logic [`ADDR_WIDTH-1:0] keys[`NUM_HASH_FUNC][NUM_BUCKETS];
   logic [`ADDR_WIDTH-1:0] values[`NUM_HASH_FUNC][NUM_BUCKETS];
   int size = 0;

   default_hash dh[`NUM_HASH_FUNC-1:0]();

   genvar i;
   generate
      for (i = 0; i < `NUM_HASH_FUNC; i = i + 1) begin: init_default_hash
         initial begin
            dh[i].update(NUM_BUCKETS);
         end
      end
   endgenerate


   /* Adds a new sva/spa pair to the hash map. If the key already existed,
    * its old value is displaced and the new value is written in its stead.
    */
   function addr_bits put(input addr_bits sva, spa);
      addr_bits orig_spa;
      bit success;

      /* Check whether this value already exists. If so, just displace its
       * old value and hand it back.
       */
      for (int i = 0; i < `NUM_HASH_FUNC; i = i + 1) begin
         automatic int hash;
         automatic bit func_index = i % 2;
         
         if (func_index == 0)
            hash = dh[0].hash(sva);
         else
            hash = dh[1].hash(sva);
            
         if (keys[func_index][hash] == sva) begin
            orig_spa = values[func_index][hash];
            values[func_index][hash] = spa;
            return orig_spa;
         end
      end

      success = try_insert(sva, spa);
      if (success == 1'b1)
         begin
            size = size + 1;
            return orig_spa;   // orig_spa should be in unknown state
         end
      else
         begin
            // FIXME: hash table is not big enough. Data is lost.
            orig_spa = 1'bz;
            return orig_spa;
         end
   endfunction


   /* Given an sva/spa pair, tries to insert that pair into the hash table, taking
    * several iterations if necessary. Output whether successful(1) or not(0) in bit.
    */
   function bit try_insert(input addr_bits sva, spa);
      /* Starting at the initial position, bounce back and forth between the
       * hash tables trying to insert the value.  During this process, keep
       * a counter that keeps growing until it reaches the a value above the
       * size.  If this is ever hit, we give up and return failure bit.
       *
       * We also use num_tries as an odd/even counter so we know which hash
       * table we're inserting into.
       */
      for (int num_tries = 0; num_tries < size + 2; num_tries = num_tries + 1) begin
         /* Compute the hash code and see what's at that position. */
         automatic int hash;
         automatic addr_bits key, value;
         automatic bit func_index = num_tries % 2;

         if (func_index == 0)
            hash = dh[0].hash(sva);
         else
            hash = dh[1].hash(sva);

         value = values[func_index][hash];
         key = keys[func_index][hash];
         
         /* No matter what case the sva/spa pair has to be written to the slot. */
         keys[func_index][hash] = sva;
         values[func_index][hash] = spa;

         /* If the orginal value is unknown, the slot is open and we are done. */
         if ($isunknown(value))
            return 1'b1;

         /* Otherwise try inserting the bumped element into the other array. */
         sva = key;
         spa = value;
      end

      return 1'b0;
   endfunction


   /* Returns the spa associated with the given sva.  If the sva is not a
    * key in the map, the output spa should remain in unknown state as a sentinel.
    */
   function addr_bits get(input addr_bits sva);
      automatic addr_bits spa;

      for (int i = 0; i < `NUM_HASH_FUNC; i = i + 1) begin
         automatic int hash;
         automatic bit func_index = i % 2;
         
         if (func_index == 0)
            hash = dh[0].hash(sva);
         else
            hash = dh[1].hash(sva);
            
         if (sva == keys[func_index][hash]) begin
            spa = values[func_index][hash];
            return spa;
         end
      end
      return spa;   // spa should be in unknown state
   endfunction


   /* Deletes the specified sva/spa pair from the map, if it exists. */
   function bit remove(input addr_bits sva);
      for (int i = 0; i < `NUM_HASH_FUNC; i = i + 1) begin
         automatic int hash;
         automatic bit func_index = i % 2;

         if (func_index == 0)
            hash = dh[0].hash(sva);
         else
            hash = dh[1].hash(sva);

         if (sva == keys[func_index][hash]) begin
            keys[func_index][hash] = 1'bx;
            values[func_index][hash] = 1'bx;

            size = size - 1;
            return 1'b1;
         end
      end

      return 1'b0;
   endfunction

endmodule


module default_hash ();
   int lg_num_buckets;
   bit [`ADDR_WIDTH/2-1:0] coe_a, coe_b;

   function int hash(input addr_bits sva);
      addr_bits upper, lower, mask;
   
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

      coe_a = $urandom;
      coe_b = $urandom;
   endtask
endmodule