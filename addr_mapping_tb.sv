`include "addr_mapping.sv"

module addr_mapping_tb();

   addr_bits val;

   task print;
      begin
         val = dh.hash(`ADDR_WIDTH'h aaaaaaaabbbbbbbb);

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
   
   int num_buckets;
   always @(num_buckets) begin
      dh.update(num_buckets);
   end

   initial
   begin
      num_buckets = 4; #1
      print();
      
      num_buckets = 8; #1
      print();    #1
      
      num_buckets = 16; #1
      print();
   end

endmodule