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

   initial begin
      dh.update(2 ** 10 - 1);
      print();
   end

   localparam num_buckets = 2 ** 10 - 1;
   addr_maping #(.NUM_BUCKETS(num_buckets)) map();
   addr_bits test_key_1 = `ADDR_WIDTH'h aaaaaaaabbbbbbbb;
   addr_bits test_key_2 = `ADDR_WIDTH'h aaaaaaaabbbcbbbb;
   addr_bits test_key_3 = `ADDR_WIDTH'h a7f2aaaabd3c4657;
   addr_bits test_value_1 = `ADDR_WIDTH'h 1111111122222222;
   addr_bits test_value_2 = `ADDR_WIDTH'h 1111111133333333;
   addr_bits test_value_3 = `ADDR_WIDTH'h 1111111144444444;
   addr_bits test_value_4 = `ADDR_WIDTH'h 1111111155555555;

   initial begin
      // Basic check
      $display("============= ARGUMENTS ================");
      $display("Get non-exist key: %h", (map.get(test_key_1)));
      $display("Remove non-exist key: %b", (map.remove(test_key_1)));
      $display("lg_num_buckets is %d", map.dh[0].lg_num_buckets);
      $display("dh[0] coe_a is %d", map.dh[0].coe_a);
      $display("dh[0] coe_b is %d", map.dh[0].coe_b);
      $display("dh[1] coe_a is %d", map.dh[1].coe_a);
      $display("dh[1] coe_b is %d", map.dh[1].coe_b);

      $display("============== FIRST PUT ===============");
      $display("Put pair (%h : %h) returns %h", test_key_1, test_value_1, (map.put(test_key_1, test_value_1)));
      $display("Hash of the key is %d", map.dh[0].hash(test_key_1));
      $display("Now size is %d", (map.size));
      $display("Get key %h returns %h", test_key_1, (map.get(test_key_1)));

      // test value overwrite
      $display("============= VALUE OVERWRITE WITH SAME KEY ================");
      $display("Put pair (%h : %h) returns %h", test_key_1, test_value_2, (map.put(test_key_1, test_value_2)));
      $display("Get key %h returns %h", test_key_1, (map.get(test_key_1)));

      $display("============== BUMPED OUT ===============");
      $display("Put pair (%h : %h) returns %h", test_key_2, test_value_3, (map.put(test_key_2, test_value_3)));
      $display("Get key %h returns %h", test_key_1, (map.get(test_key_1)));
      $display("Get key %h returns %h", test_key_2, (map.get(test_key_2)));

      $display("============== RECURSIVE BUMPED OUT ===============");
      $display("Put pair (%h : %h) returns %h", test_key_3, test_value_4, (map.put(test_key_3, test_value_4)));
      $display("Get key %h returns %h", test_key_1, (map.get(test_key_1)));
      $display("Get key %h returns %h", test_key_2, (map.get(test_key_2)));
      $display("Get key %h returns %h", test_key_3, (map.get(test_key_3)));

      $display("=============== DEBUG =================");
      for (int i = 0; i < num_buckets; i = i + 1) begin
         if (!$isunknown(map.keys[0][i])) begin
            $display("table 0 - Position %d - [%h : %h]", i, (map.keys[0][i]), map.values[0][i]);
         end

         if (!$isunknown(map.keys[1][i])) begin
            $display("table 1 - Position %d - [%h : %h]", i, (map.keys[1][i]), map.values[1][i]);
         end
      end
   end

endmodule