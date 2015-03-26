`timescale 1ns/1ps

module t_LFSR () ;
  
    reg clk; 

    //populate 16 bit LFSR, which makes up the upper layer of the PRNG
    <% LFSR_BITS = 16 %>
    <% LFSR_INIT = "4'h1111" %>
    wire [<%= LFSR_BITS - 1 %> : 0]     O_LFSR_UP ;
    reg [<%= LFSR_BITS - 1 %> : 0]      SEED_UP ;
    LFSR_<%= LFSR_BITS %>BITS LFSR_UP (
        .clk(clk),
        .SEED(SEED_UP),
        .PRNG(O_LFSR_UP)
    );

    //populate 8 bit LFSR, which makes up the lower layer of the PRNG
    <% LFSR_BITS = 8 %>
    <% LFSR_INIT = "2'h11" %>
    wire [<%= LFSR_BITS - 1 %> : 0]     O_LFSR_DOWN ;
    reg [<%= LFSR_BITS - 1 %> : 0]      SEED_DOWN ;
    LFSR_<%= LFSR_BITS %>BITS LFSR_DOWN (
        .clk(clk),
        .SEED(SEED_DOWN),
        .PRNG(O_LFSR_DOWN)
    );

    wire [<%= LFSR_BITS - 1 %> : 0]     O_LFSR ;

    //combine the two LFSR to generate a longer period
    assign O_LFSR = O_LFSR_UP[<%= LFSR_BITS - 1 %> : 0] ^ O_LFSR_DOWN ;

    initial begin
        clk         <= 0 ;
        SEED_UP     <= 4'h0001 ;
        SEED_DOWN   <= 2'h01 ;
    end

    always begin
        #5 clk <= ~clk ;
        #100 $finish;
    end

endmodule
    
    //generate LFSR_8bit block
    <% LFSR_BITS = 16 %>
    <% LFSR_INIT = "4'h1111" %>
    <%= ERB.new(File.read("src/LFSR.erb.v"),nil,nil,eoutvar='_sub01').result(binding) %>

    //generate LFSR_8bit block
    <% LFSR_BITS = 8 %>
    <% LFSR_INIT = "2'h11" %>
    <%= ERB.new(File.read("src/LFSR.erb.v"),nil,nil,eoutvar='_sub01').result(binding) %>
