module VfD_prescaler (

    output          o_clk,

    input           clk
);

    // annotate frequencies for clocks
    parameter       f_clkin = 12_000_000;   // [MHz]
    parameter       f_clkout = 2;           // [MHz]

//  ------------    divider     ------------

    integer         divider = 0;

    wire            w_zero;

    assign w_zero = (divider)? 0: 1;

always @ (posedge clk)
begin
    if (w_zero)
        begin
        // set divider while zero
        divider <= (f_clkin / f_clkout)/2;
        end
    else
        divider <= divider - 1;
end

//  ------------    toggle FF   ------------

    reg             r_toggle = ~0;

always @ (posedge clk)
begin
        r_toggle <= (w_zero)? !r_toggle: r_toggle;
end

// output matching
assign o_clk = r_toggle;

endmodule
