//  -------------------------------------------------------------------
//                          DESCRIPTION
//  -------------------------------------------------------------------

//  Event principles:
//
//       one clock cycle
//      |---------------|
//       _______         _______         _______
//      ||      |       ||      |       ||      |
//      ||      |       ||      |       ||      |       clk_tb
//  ____||      |_______||      |_______||      |_____
//
//                   ^ STROBE        ^ STROBE
//
//                   ^ write here    ^ write here
//                                   ^ read here
//                   |---------------|
//                    one task cycle

`include "timescale.v"

//  -------------------------------------------------------------------
//                          CONFIGURATION
//  -------------------------------------------------------------------

`define                 TIMELIMIT       800_000

//  ----------------    global signal   -------------------------------

`define                 CLK_PERIOD      10
`define                 RST_PERIOD      200
`define                 STROBE          (0.8 * `CLK_PERIOD)

module tc_prescaler (
//  Sorry, testbenches do not have ports
);

//  ------------    global signals      -------------------------------

    reg                 clk_tb = ~0;        // start with falling edge

always @ (clk_tb)
begin
    clk_tb <= #(`CLK_PERIOD/2) ~clk_tb;
end

    reg                 rst_tb = 0;         // start inactive

initial
begin
    #1;
    // activate reset
    rst_tb <= ~0;
    rst_tb <= #(`RST_PERIOD) 0;
end

//  ------------    testbench top level signals -----------------------

    localparam          f_clkin = 12_000;
    localparam          f_clkout = 2;

    wire                w_clkout;

//  ------------    device-under-test (DUT) ---------------------------

    defparam dut.f_clkin = f_clkin;
    defparam dut.f_clkout = f_clkout;

VfD_prescaler dut (
    .o_clk              (w_clkout),

    .clk                (clk_tb)
);

//  ------------    functional model    -------------------------------

    time                last_edge = 0;

always @ (posedge w_clkout)
begin
    if (w_clkout)
        $display("\tclock period is %t", $time - last_edge);
    last_edge <= $time;
end

//  ------------    test functionality  -------------------------------

    integer             failed = 0;         // failed test item counter

task t_initialize;
begin
    #1;
    @ (negedge rst_tb);
    @ (posedge clk_tb);
    #(`STROBE);
end
endtask

task t_run;
    input integer reps;
begin
    repeat(reps) begin
        @ (posedge clk_tb);
    end
end
endtask

initial
begin
    t_initialize;

    t_run(500_000);

    #1;
    if (failed)
        $display("\t%m: *failed* %0d times", failed);
    else
        $display("\t%m: *well done*");
    $finish;
end

//  ------------    testbench flow control  ---------------------------

initial
begin
    $dumpfile(`DUMPFILE);
    $dumpvars;

    #(`TIMELIMIT);
    $display("\t%m: *time limit (%t) reached*", $time);
    $finish;
end

endmodule
