module VfD_counter (

    input           i_enable,
    output reg [4:0] o_result,

    input           clk,
    input           rst
);

//  ------------    behavioral  ------------

always @ (posedge rst or posedge clk)
begin
    if (rst)
        // reset
        o_result <= 0;
    else
        // clocked
        if (i_enable)
            o_result <= o_result + 1;
end

endmodule
