// package addr_mapping;

`define ADDR_WIDTH 64
`define LG_NUM_BUCKETS 2

class CuckooHashMap;
   
   class DefaultHashFunction;
      local bit [`ADDR_WIDTH-1:0] coe_a, coe_b;

      function new(int coe_a, coe_b);
         this.coe_a = coe_a;
         this.coe_b = coe_b;
      endfunction
      
      function bit [`ADDR_WIDTH-1:0] hash(int sva);
         bit [`ADDR_WIDTH/2-1:0] upper = sva >> (`ADDR_WIDTH / 2);
         bit [`ADDR_WIDTH/2-1:0] mask  = (1 << `ADDR_WIDTH / 2) - 1;
         bit [`ADDR_WIDTH/2-1:0] lower = sva & mask;

         return (upper * coe_a + lower * coe_b) >> (`ADDR_WIDTH - `LG_NUM_BUCKETS);
      endfunction
      
      function bit [`ADDR_WIDTH-1:0] get_coe_a();
         return coe_a;
      endfunction

      function bit [`ADDR_WIDTH-1:0] get_coe_b();
         return coe_b;
      endfunction

   endclass


   class DefaultUniversalHashFunction;
      local bit [`ADDR_WIDTH-1:0] coe_a, coe_b;

      function DefaultHashFunction randomHashFunction();
         DefaultHashFunction dhf;
         
         void'(randomize(coe_a));
         void'(randomize(coe_b));
         
         dhf = new(coe_a, coe_b);
         return dhf;
      endfunction

   endclass
endclass

module test_bench();
   CuckooHashMap::DefaultHashFunction defaultHashFunction;
   
   initial
   begin
      defaultHashFunction = new(16'hfbcd, 16'hfbcd);
      $display("result hash is: %d", defaultHashFunction.hash(32'haaaabbbb));
   end
   
   CuckooHashMap::DefaultUniversalHashFunction defaultUniversalHashFunction;
   
   
   initial
   begin
      defaultUniversalHashFunction = new();

      defaultHashFunction = defaultUniversalHashFunction.randomHashFunction();
      $display("coe_a is %h", (defaultHashFunction.get_coe_a()));
      $display("coe_b is %h", (defaultHashFunction.get_coe_b()));
      
      defaultHashFunction = defaultUniversalHashFunction.randomHashFunction();
      $display("coe_a is %h", (defaultHashFunction.get_coe_a()));
      $display("coe_b is %h", (defaultHashFunction.get_coe_b()));
      
      defaultHashFunction = defaultUniversalHashFunction.randomHashFunction();
      $display("coe_a is %h", (defaultHashFunction.get_coe_a()));
      $display("coe_b is %h", (defaultHashFunction.get_coe_b()));
   end
endmodule