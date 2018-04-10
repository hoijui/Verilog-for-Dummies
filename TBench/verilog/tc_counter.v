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

`define                 TIMELIMIT       10_000

//  ----------------    global signal   -------------------------------

`define                 CLK_PERIOD      10
`define                 RST_PERIOD      200
`define                 STROBE          (0.8 * `CLK_PERIOD)

module tc_counter (
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

    localparam          c_width =5;

    reg                 r_enable = 0;
    wire [c_width-1:0]  w_result;

//  ------------    device-under-test (DUT) ---------------------------

VfD_counter dut (
    .i_enable           (r_enable),
    .o_result           (w_result),

    .clk                (clk_tb),
    .rst                (rst_tb)
);

//  ------------    functional model    -------------------------------

    reg [c_width-1:0]   r_expectation = 0;

always @ (posedge clk_tb)
begin
    if (r_enable)
        r_expectation = r_expectation +1;
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
        #(`STROBE);
        failed = (r_expectation == w_result)? failed: failed+1;
    end
end
endtask

task t_enable;
begin
    r_enable <= ~0;
    @ (posedge clk_tb);
    #(`STROBE);
end
endtask

task t_disable;
begin
    r_enable <= 0;
    @ (posedge clk_tb);
    #(`STROBE);
end
endtask

initial
begin
    t_initialize;

    // 1st, enable and run
    t_enable;
    t_run(15);

    // 2nd, stop
    t_disable;

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
