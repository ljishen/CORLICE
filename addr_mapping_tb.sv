`include "addr_mapping.sv"

module addr_mapping_tb();

   addr_bits coe_a, coe_b, val;

   task print;
      begin
         val = dh.hash(`ADDR_WIDTH'h aaaaaaaabbbbbbbb);
         
         $display("sva is %h", dh.hash.sva);
         $display("upper is %h", dh.hash.upper);
         $display("lower is %h", dh.hash.lower);
         $display("coe_a is %h", dh.coe_a);
         $display("coe_b is %h", dh.coe_b);
         $display("val is %d", val);
      end
   endtask

   default_hash dh();

   initial
   begin
      print();    #1
      
      dh.refresh();
      print();    #1
      
      dh.refresh();
      print();
   end

endmodule