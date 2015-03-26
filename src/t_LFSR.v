`timescale 1ns/1ps

module t_LFSR () ;
   
    parameter upBits    = 15 ;
    parameter downBits  = 8 ;

endmodule
    
    //generate LFSR_8bit block
    
    
model LFSR_8BITS ( PRNG, INIT, SEED, clk);

    parameter   REG_BITS    = 8 ;
    parameter   INIT        = 8'b0 ; 

    input wire [REG_BITS-1:0]   SEED ;
    input wire [REG_BITS-1:0]   INIT ;
    input wire                  clk ;
    output reg [REG_BITS-1:0]   PRNG ;

    initial begin
        PRNG <= INIT ;
    end

    always @(posedge clk) begin
        
            PRNG[1] <= PRNG[0] ;
        
            PRNG[2] <= PRNG[1] ;
        
            PRNG[3] <= PRNG[2] ;
        
            PRNG[4] <= PRNG[3] ;
        
            PRNG[5] <= PRNG[4] ;
        
            PRNG[6] <= PRNG[5] ;
        
            PRNG[7] <= PRNG[6] ;
        
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
         
            SEED[7] ^
        
        ;
    end
endmodule





    //generate LFSR_16bit block
    
    
model LFSR_16BITS ( PRNG, INIT, SEED, clk);

    parameter   REG_BITS    = 16 ;
    parameter   INIT        = 16'b0 ; 

    input wire [REG_BITS-1:0]   SEED ;
    input wire [REG_BITS-1:0]   INIT ;
    input wire                  clk ;
    output reg [REG_BITS-1:0]   PRNG ;

    initial begin
        PRNG <= INIT ;
    end

    always @(posedge clk) begin
        
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
         
            SEED[15] ^
        
        ;
    end
endmodule




