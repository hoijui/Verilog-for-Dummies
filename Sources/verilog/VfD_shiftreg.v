module VfD_shiftreg (

    input           i_enable,
    output [4:0]    o_result,

    input           clk,
    input           rst
);

//  ------------    behavioral  ------------

    reg [4:0]       r_shiftreg;

always @ (posedge rst or posedge clk)
begin
    if (rst)
        // reset
        r_shiftreg <= 0;
    else
        // clocked
        if (i_enable)
            r_shiftreg <= {i_enable, r_shiftreg[4:1]};
end

assign o_result = r_shiftreg;

endmodule
