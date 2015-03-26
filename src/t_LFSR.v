`timescale 1ns/1ps
`define DEBUG

module t_LFSR () ;
  
    reg clk; 
    //initialization
    
    
    
    

    //populate UP bit LFSR, which makes up the upper layer of the PRNG
    wire [15 : 0]     O_LFSR_UP ;
    reg [15 : 0]      SEED_UP ;
    LFSR_16BITS LFSR_UP (
        .clk(clk),
        .SEED(SEED_UP),
        .PRNG(O_LFSR_UP)
    );

    //populate DOWN bit LFSR, which makes up the lower layer of the PRNG
    wire [7 : 0]     O_LFSR_DOWN ;
    reg [7 : 0]      SEED_DOWN ;
    LFSR_8BITS LFSR_DOWN (
        .clk(clk),
        .SEED(SEED_DOWN),
        .PRNG(O_LFSR_DOWN)
    );

    wire [7 : 0]     O_LFSR ;

    //combine the two LFSR to generate a longer period
    assign O_LFSR = O_LFSR_UP[7 : 0] ^ O_LFSR_DOWN ;

    initial begin
        clk         <= 0 ;
        SEED_UP     <= 16'h5;
        SEED_DOWN   <= 8'he;
        #100 $finish;
    end

    always begin
        `ifdef DEBUG
            $display ( " UP LFSR %h \n " , O_LFSR_UP ) ;
            $display ( " DOWN LFSR %h \n " , O_LFSR_DOWN ) ;
        `endif
        #5 clk <= ~clk ;
    end

endmodule
    
    //generate LFSR_DOWNbit block
    
    
    module LFSR_16BITS ( PRNG, SEED, clk);
    
    //LFSR bits are assigned during the erb compiling process
    parameter   REG_BITS    = 16 ;
    parameter   INIT        = 16'h00FF ; 
    
    //read interface for the verilog
    input wire [REG_BITS-1:0]   SEED ;
    input wire                  clk ;
    output reg [REG_BITS-1:0]   PRNG ;

    initial begin
        //initialization
        PRNG = INIT ;
        `ifdef DEBUG
            $display("INIT values : %b \n " , INIT ) ;
            $display("PRNG values : %b \n " , PRNG ) ;
        `endif
    end

    always @(posedge clk) begin
        //linear shifting part
        
            PRNG[1] <= PRNG[0] ;
        
            PRNG[2] <= PRNG[1] ;
        
            PRNG[3] <= PRNG[2] ;
        
            PRNG[4] <= PRNG[3] ;
        
            PRNG[5] <= PRNG[4] ;
        
            PRNG[6] <= PRNG[5] ;
        
            PRNG[7] <= PRNG[6] ;
        
            PRNG[8] <= PRNG[7] ;
        
            PRNG[9] <= PRNG[8] ;
        
            PRNG[10] <= PRNG[9] ;
        
            PRNG[11] <= PRNG[10] ;
        
            PRNG[12] <= PRNG[11] ;
        
            PRNG[13] <= PRNG[12] ;
        
            PRNG[14] <= PRNG[13] ;
        
            PRNG[15] <= PRNG[14] ;
        
        //including the seed to the feedback loop
        PRNG[0] <= 
         
            PRNG[0] ^
         
            PRNG[1] ^
         
            PRNG[2] ^
         
            PRNG[3] ^
         
            PRNG[4] ^
         
            PRNG[5] ^
         
            PRNG[6] ^
         
            PRNG[7] ^
         
            PRNG[8] ^
         
            PRNG[9] ^
         
            PRNG[10] ^
         
            PRNG[11] ^
         
            PRNG[12] ^
         
            PRNG[13] ^
         
            PRNG[14] ^
         
            PRNG[15] ^
        
         
            SEED[0] ^
         
            SEED[1] ^
         
            SEED[2] ^
         
            SEED[3] ^
         
            SEED[4] ^
         
            SEED[5] ^
         
            SEED[6] ^
         
            SEED[7] ^
         
            SEED[8] ^
         
            SEED[9] ^
         
            SEED[10] ^
         
            SEED[11] ^
         
            SEED[12] ^
         
            SEED[13] ^
         
            SEED[14] ^
        
            SEED[15]
        ;
    end
endmodule





    //generate LFSR_DOWNbit block
    
    
    module LFSR_8BITS ( PRNG, SEED, clk);
    
    //LFSR bits are assigned during the erb compiling process
    parameter   REG_BITS    = 8 ;
    parameter   INIT        = 8'h0F ; 
    
    //read interface for the verilog
    input wire [REG_BITS-1:0]   SEED ;
    input wire                  clk ;
    output reg [REG_BITS-1:0]   PRNG ;

    initial begin
        //initialization
        PRNG = INIT ;
        `ifdef DEBUG
            $display("INIT values : %b \n " , INIT ) ;
            $display("PRNG values : %b \n " , PRNG ) ;
        `endif
    end

    always @(posedge clk) begin
        //linear shifting part
        
            PRNG[1] <= PRNG[0] ;
        
            PRNG[2] <= PRNG[1] ;
        
            PRNG[3] <= PRNG[2] ;
        
            PRNG[4] <= PRNG[3] ;
        
            PRNG[5] <= PRNG[4] ;
        
            PRNG[6] <= PRNG[5] ;
        
            PRNG[7] <= PRNG[6] ;
        
        //including the seed to the feedback loop
        PRNG[0] <= 
         
            PRNG[0] ^
         
            PRNG[1] ^
         
            PRNG[2] ^
         
            PRNG[3] ^
         
            PRNG[4] ^
         
            PRNG[5] ^
         
            PRNG[6] ^
         
            PRNG[7] ^
        
         
            SEED[0] ^
         
            SEED[1] ^
         
            SEED[2] ^
         
            SEED[3] ^
         
            SEED[4] ^
         
            SEED[5] ^
         
            SEED[6] ^
        
            SEED[7]
        ;
    end
endmodule







