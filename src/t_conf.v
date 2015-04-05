`timescale 1ns/1ps
`define DEBUG

module t_conf () ;

    //ruby initialization
    
     
     
     

    //inputs, feedback signal from the system
    reg                                 O_INVU ;
    reg                                 O_INVD ;
    reg                                 CLK ;

    //outputs for the configuration module
    wire    [3:0]     INVU_NCONF ;
    wire    [3:0]     INVU_PCONF ;
    wire    [3:0]     INVD_NCONF ;
    wire    [3:0]     INVD_PCONF ;

    initial begin
            CLK <= 0 ;
            {O_INVU,O_INVD} <= 2'b01;
        #10000
            {O_INVU,O_INVD} <= 2'b10;
    end

    always begin
        #5 CLK <= ~CLK ;
        $display ( "UP %h, UN %h, DP %h, DN %h \n",
                INVU_PCONF, INVU_NCONF, 
                INVD_PCONF, INVD_NCONF 
                ) ;
    end

    CONF_4BITS CONF (
        .INVU_NCONF(INVU_NCONF),
        .INVU_PCONF(INVU_PCONF),
        .INVD_NCONF(INVD_NCONF),
        .INVD_PCONF(INVD_PCONF),
        .O_INVU(O_INVU),
        .O_INVD(O_INVD),
        .CLK(CLK)
        );
    
endmodule
    
    //generate LFSR_DOWNbit block
    
module CONF_4BITS ( INVU_NCONF, INVU_PCONF, INVD_NCONF, INVD_PCONF, O_INVU, O_INVD, CLK) ;
    //The start of this code needs four variables
    //CONF_BITS INIT_BITS_F INIT_BITS_O INIT_BITS_X
    input wire                              O_INVU ;
    input wire                              O_INVD ;
    input wire                              CLK ;

    output [3:0]         INVU_NCONF ;
    output [3:0]         INVU_PCONF ;
    output [3:0]         INVD_NCONF ;
    output [3:0]         INVD_PCONF ;

    reg [3:0]        REG_INVU_NCONF ;
    reg [3:0]        REG_INVU_PCONF ;
    reg [3:0]        REG_INVD_NCONF ;
    reg [3:0]        REG_INVD_PCONF ;

    initial begin
        //suppose the init bits can only be all fs or all 0s
        //INIT_BITS_X represents all xs
        REG_INVU_NCONF <= 4'h0 ;
        REG_INVU_PCONF <= 4'h0 ;
        REG_INVD_NCONF <= 4'hF ;
        REG_INVD_PCONF <= 4'hF ;
    end

    assign INVU_NCONF   = REG_INVU_NCONF ;
    assign INVU_NCONF   = REG_INVU_NCONF ;
    assign INVU_NCONF   = REG_INVU_NCONF ;
    assign INVU_NCONF   = REG_INVU_NCONF ;

    always @(posedge CLK) begin
        casez ({O_INVU,O_INVD,INVU_PCONF,INVU_NCONF,INVD_PCONF,INVD_NCONF})
            {2'b10,4'h0,4'h0,4'hF,4'hF}:begin
                `ifdef DEBUG
                    $display ( "case 1\n" ) ;
                `endif
                    //do nothing;
                    REG_INVU_PCONF <= REG_INVU_PCONF ;
                    REG_INVU_NCONF <= REG_INVU_NCONF ;
                    REG_INVD_PCONF <= REG_INVD_PCONF ;
                    REG_INVD_NCONF <= REG_INVD_NCONF ;
                end
            {2'b01,4'hF,4'hF,4'h0,4'h0}:begin
                `ifdef DEBUG
                    $display ( "case 2\n" ) ;
                `endif
                    //do nothing;
                    REG_INVU_PCONF <= REG_INVU_PCONF ;
                    REG_INVU_NCONF <= REG_INVU_NCONF ;
                    REG_INVD_PCONF <= REG_INVD_PCONF ;
                    REG_INVD_NCONF <= REG_INVD_NCONF ;
                end
            {2'b10,4'h?,4'h0,4'h?,4'hF}:begin
                `ifdef DEBUG
                    $display ( "case 3\n" ) ;
                `endif
                    //config PMOS 
                    REG_INVU_PCONF <= REG_INVU_PCONF - 1 ;
                    REG_INVD_PCONF <= REG_INVD_PCONF + 1 ;
                end
            {2'b01,4'h?,4'hF,4'h?,4'h0}:begin
                `ifdef DEBUG
                    $display ( "case 4\n" ) ;
                `endif
                    //config PMOS 
                    REG_INVU_PCONF <= REG_INVU_PCONF + 1 ;
                    REG_INVD_PCONF <= REG_INVD_PCONF - 1 ;
                end
            {2'b10,4'h?,4'h?,4'h?,4'h?}:begin
                `ifdef DEBUG
                    $display ( "case 5\n" ) ;
                `endif
                    //config NMOS
                    REG_INVU_NCONF <= REG_INVU_NCONF - 1 ;
                    REG_INVD_NCONF <= REG_INVD_NCONF + 1 ;
                end
            {2'b01,4'h?,4'h?,4'h?,4'h?}:begin
                `ifdef DEBUG
                    $display ( "case 6\n" ) ;
                `endif
                    //config NMOS 
                    REG_INVU_NCONF <= REG_INVU_NCONF + 1 ;
                    REG_INVD_NCONF <= REG_INVD_NCONF - 1 ;
                end
            default: begin
                `ifdef DEBUG
                    $display ( "error, %b, %h \n" , {O_INVU, O_INVD}, 
                            {INVU_PCONF,INVU_NCONF,INVD_PCONF,INVD_NCONF} ) ;
                `endif
                end
        endcase
    end

endmodule



