module VfD_heartbeat (

    output          o_led,

    input           clk,
    input           rst);

    // annotate frequencies for clocks
    parameter       f_clkin = 12_000_000;   // [Hz]

//  ------------    beat pattern    --------

    localparam      c_length = 5;
    localparam      c_pattern = 'b10100;

    wire            w_zero;
    reg [c_length-1:0] r_rotatereg;

always @ (posedge rst or posedge clk)
begin
    if (rst) // reset
        r_rotatereg <= c_pattern;
    else // operational
        // reload pattern or rotate register right
        r_rotatereg <= (w_zero)? {r_rotatereg[0], r_rotatereg[c_length-1:1]}: r_rotatereg;
end

// output matching
assign o_led = r_rotatereg[0];

//  ------------    down scaler ------------

    integer         r_divider = 0;

    assign w_zero = (r_divider)? 0: 1;

always @ (posedge clk)
begin
    if (w_zero)
        // set divider while zero
        r_divider <= (f_clkin / c_length);    // always pattern once per second
    else
        // count count
        r_divider <= r_divider - 1;
end

endmodule
