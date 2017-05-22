module corlice(led, sw);
output [0:0] led;
input [2:0] sw;

endmodule



module mux;
function [31:0] factorial;
    input  [3:0] operand;
    reg [3:0] index;
    begin
        factorial = operand ? 1 : 0;
        for (index = 2; index <= operand; index = index + 1)
            factorial = index * factorial;
    end
endfunction

reg [5:0] result;

initial
begin
result = factorial(3);
end
endmodule