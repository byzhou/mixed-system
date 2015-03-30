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
            {O_INVU,O_INVD} <= 2'b10;
        #1000
            {O_INVU,O_INVD} <= 2'b01;
    end

    always begin
        #5 CLK <= ~CLK ;
        $display ( "UP %h, UN %h, DP %h, DP %h \n",
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
    input wire                               O_INVU ;
    input wire                               O_INVD ;
    input wire                               CLK ;

    output reg [3:0]      INVU_NCONF ;
    output reg [3:0]      INVU_PCONF ;
    output reg [3:0]      INVD_NCONF ;
    output reg [3:0]      INVD_PCONF ;

    initial begin
        //suppose the init bits can only be all fs or all 0s
        //INIT_BITS_X represents all xs
        INVU_NCONF <= 4'hF ;
        INVU_PCONF <= 4'hF ;
        INVD_NCONF <= 4'h0 ;
        INVD_PCONF <= 4'h0 ;
    end

    always @(posedge CLK) begin
        casez ({O_INVU,O_INVD,INVU_PCONF,INVU_NCONF,INVD_PCONF,INVD_NCONF})
            {2'b01,4'hF,4'hF,4'h0,4'h0}:begin
                `ifdef DEBUG
                    $display ( "case 1\n" ) ;
                `endif
                    //do nothing;
                    INVU_PCONF <= INVU_PCONF ;
                    INVU_NCONF <= INVU_NCONF ;
                    INVD_PCONF <= INVD_PCONF ;
                    INVD_NCONF <= INVD_NCONF ;
                end
            {2'b10,4'h0,4'h0,4'hF,4'hF}:begin
                `ifdef DEBUG
                    $display ( "case 2\n" ) ;
                `endif
                    //do nothing;
                    INVU_PCONF <= INVU_PCONF ;
                    INVU_NCONF <= INVU_NCONF ;
                    INVD_PCONF <= INVD_PCONF ;
                    INVD_NCONF <= INVD_NCONF ;
                end
            {2'b10,4'h0,4'h?,4'hF,4'h?}:begin
                `ifdef DEBUG
                    $display ( "case 3\n" ) ;
                `endif
                    //config PMOS 
                    INVU_PCONF <= INVU_PCONF - 1 ;
                    INVD_PCONF <= INVU_PCONF + 1 ;
                end
            {2'b01,4'h?,4'hF,4'h?,4'h0}:begin
                `ifdef DEBUG
                    $display ( "case 4\n" ) ;
                `endif
                    //config PMOS 
                    INVU_PCONF <= INVU_PCONF + 1 ;
                    INVD_PCONF <= INVU_PCONF - 1 ;
                end
            {2'b10,4'h?,4'h?,4'h?,4'h?}:begin
                `ifdef DEBUG
                    $display ( "case 5\n" ) ;
                `endif
                    //config NMOS
                    INVU_NCONF <= INVU_NCONF - 1 ;
                    INVD_NCONF <= INVU_NCONF + 1 ;
                end
            {2'b01,4'h?,4'h?,4'h?,4'h?}:begin
                `ifdef DEBUG
                    $display ( "case 6\n" ) ;
                `endif
                    //config NMOS 
                    INVU_NCONF <= INVU_NCONF + 1 ;
                    INVD_NCONF <= INVU_NCONF - 1 ;
                end
            default: $display ( "error, %b, %h \n" , {O_INVU, O_INVD}, 
                        {INVU_PCONF,INVU_NCONF,INVD_PCONF,INVD_NCONF} ) ;
        endcase
    end

endmodule



