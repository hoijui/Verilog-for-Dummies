module VfD_prescaler (

    output          o_clk,

    input           clk
);

    // annotate frequencies for clocks
    parameter       f_clkin = 12_000_000;   // [Hz]
    parameter       f_clkout = 2;           // [Hz]

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

    reg             r_toggle = ~0;  // start with non-active edge

always @ (posedge clk)
begin
        r_toggle <= (w_zero)? !r_toggle: r_toggle;
end

// output matching
assign o_clk = r_toggle;

endmodule
