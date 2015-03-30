`timescale 1ns/1ps
`define DEBUG

module t_conf () ;

    //ruby initialization
    
     
     
     

    //inputs, feedback signal from the system
    reg                                 O_INVU ;
    reg                                 O_INVD ;
    reg                                 CLK ;

    //outputs for the configuration module
    wire    [15:0]     INVU_NCONF ;
    wire    [15:0]     INVU_PCONF ;
    wire    [15:0]     INVD_NCONF ;
    wire    [15:0]     INVD_PCONF ;

    initial begin
            CLK <= 0 ;
            {O_INVU,O_INVD} <= 2'b10;
        #1000
            {O_INVU,O_INVD} <= 2'b01;
    end

    always begin
        #5 CLK <= ~CLK ;
        $display ( "UN %h, DN %h, UP %h, DP %h \n",
                INVU_NCONF, INVD_NCONF, 
                INVU_PCONF, INVD_PCONF ) ;
    end

    CONF_16BITS CONF (
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
    
module CONF_16BITS ( INVU_NCONF, INVU_PCONF, INVD_NCONF, INVD_PCONF, O_INVU, O_INVD, CLK) ;
    //The start of this code needs four variables
    //CONF_BITS INIT_BITS_F INIT_BITS_O INIT_BITS_X
    input wire                               O_INVU ;
    input wire                               O_INVD ;
    input wire                               CLK ;

    output reg [15:0]      INVU_NCONF ;
    output reg [15:0]      INVU_PCONF ;
    output reg [15:0]      INVD_NCONF ;
    output reg [15:0]      INVD_PCONF ;

    initial begin
        //suppose the init bits can only be all fs or all 0s
        //INIT_BITS_X represents all xs
        INVU_NCONF <= 16'hFFFF ;
        INVU_PCONF <= 16'hFFFF ;
        INVD_NCONF <= 16'h0000 ;
        INVD_PCONF <= 16'h0000 ;
    end

    always @(posedge CLK) begin
        case ({O_INVU,O_INVD,INVU_PCONF,INVU_NCONF,INVD_PCONF,INVD_NCONF})
            {2'b01,16'hFFFF,16'hFFFF,16'h0000,16'h0000}:begin
                    //do nothing;
                    INVU_PCONF <= INVU_PCONF ;
                    INVU_NCONF <= INVU_NCONF ;
                    INVD_PCONF <= INVD_PCONF ;
                    INVD_NCONF <= INVD_NCONF ;
                end
            {2'b10,16'h0000,16'h0000,16'hFFFF,16'hFFFF}:begin
                    //do nothing;
                    INVU_PCONF <= INVU_PCONF ;
                    INVU_NCONF <= INVU_NCONF ;
                    INVD_PCONF <= INVD_PCONF ;
                    INVD_NCONF <= INVD_NCONF ;
                end
            {2'b10,16'h0000,16'hXXXX,16'hFFFF,16'hXXXX}:begin
                    //config PMOS 
                    INVU_PCONF <= INVU_PCONF - 1 ;
                    INVD_PCONF <= INVU_PCONF + 1 ;
                end
            {2'b01,16'hXXXX,16'hFFFF,16'hXXXX,16'h0000}:begin
                    //config PMOS 
                    INVU_PCONF <= INVU_PCONF + 1 ;
                    INVD_PCONF <= INVU_PCONF - 1 ;
                end
            {2'b10,16'hXXXX,16'hXXXX,16'hXXXX,16'hXXXX}:begin
                    //config NMOS
                    INVU_NCONF <= INVU_NCONF - 1 ;
                    INVD_NCONF <= INVU_NCONF + 1 ;
                end
            {2'b01,16'hXXXX,16'hXXXX,16'hXXXX,16'hXXXX}:begin
                    //config NMOS 
                    INVU_NCONF <= INVU_NCONF + 1 ;
                    INVD_NCONF <= INVU_NCONF - 1 ;
                end
        endcase
    end

endmodule



