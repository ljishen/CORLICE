`include "addr_mapping.sv"

module addr_mapping_tb();

   task print;
      begin
         automatic addr_bits val = dh.hash(`ADDR_WIDTH'h aaaaaaaabbbbbbbb);

         $display("sva is %h", dh.hash.sva);
         $display("upper is %h", dh.hash.upper);
         $display("lower is %h", dh.hash.lower);
         $display("lg_num_buckets is %d", dh.lg_num_buckets);
         $display("coe_a is %h", dh.coe_a);
         $display("coe_b is %h", dh.coe_b);
         $display("val is %d", val);
      end
   endtask

   default_hash dh();
   
   logic [10:0] keys[`NUM_HASH_FUNC][4];

   initial begin
      dh.update(2 ** 10 - 1);
      print();
      
      $display("check default value: %b", keys[0][0]);
      keys[0][0] = 1'bx;
      if ($isunknown(keys[0][0]))
         $display("yes");
      else
         $display("no");
   end

endmodule