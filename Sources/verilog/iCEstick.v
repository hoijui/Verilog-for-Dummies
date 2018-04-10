module iCEstick (

    //  --------    LEDs    --------

    output          LED_D1,                 // PIO1_14
    output          LED_D2,                 // PIO1_13
    output          LED_D3,                 // PIO1_12
    output          LED_D4,                 // PIO1_11
    output          LED_D5,                 // PIO1_10

    //  --------    Infrared    --------

    input           IrDA_RXD,               // PIO1_19
    output          IrDA_TXD,               // PIO1_18
    output          IrDA_SD,                // PIO1_20

    //  --------    globals --------

    input           ICE_CLK                 // PIO3_00
);

//  ------------    core instatiation   ------------

    wire            clk_intern;

//    defparam    u_presaler.f_clkin = 12_000_000;
//    defparam    u_presaler.f_clkout = 2;

VfD_prescaler # (
    .f_clkin        (12_000_000),
    .f_clkout       (2)
) u_prescaler (
    .o_clk          (clk_intern),
    .clk            (ICE_CLK)
);

VfD_counter u_counter (
    .i_enable       (1'b1),
    .o_result       ({LED_D5, LED_D4, LED_D3, LED_D2, LED_D1}),

    .clk            (clk_intern),
    .rst            (1'b0));

endmodule
