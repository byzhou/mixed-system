`timescale 1ns/1ps
`define DEBUG

module t_LFSR () ;
  
    reg clk; 
    //initialization
    <% LFSR_BITS_UP = 16 %>
    <% LFSR_INIT_UP = "16'h00FF" %>
    <% LFSR_BITS_DOWN = 8 %>
    <% LFSR_INIT_DOWN = "8'h0F" %>

    //populate UP bit LFSR, which makes up the upper layer of the PRNG
    wire [<%= LFSR_BITS_UP - 1 %> : 0]     O_LFSR_UP ;
    reg [<%= LFSR_BITS_UP - 1 %> : 0]      SEED_UP ;
    LFSR_<%= LFSR_BITS_UP %>BITS LFSR_UP (
        .clk(clk),
        .SEED(SEED_UP),
        .PRNG(O_LFSR_UP)
    );

    //populate DOWN bit LFSR, which makes up the lower layer of the PRNG
    wire [<%= LFSR_BITS_DOWN - 1 %> : 0]     O_LFSR_DOWN ;
    reg [<%= LFSR_BITS_DOWN - 1 %> : 0]      SEED_DOWN ;
    LFSR_<%= LFSR_BITS_DOWN %>BITS LFSR_DOWN (
        .clk(clk),
        .SEED(SEED_DOWN),
        .PRNG(O_LFSR_DOWN)
    );

    wire [<%= LFSR_BITS_DOWN - 1 %> : 0]     O_LFSR ;

    //combine the two LFSR to generate a longer period
    assign O_LFSR = O_LFSR_UP[<%= LFSR_BITS_DOWN - 1 %> : 0] ^ O_LFSR_DOWN ;

    initial begin
        clk         <= 0 ;
        SEED_UP     <= <%= LFSR_BITS_UP %>'h5;
        SEED_DOWN   <= <%= LFSR_BITS_DOWN %>'he;
        #10000 $finish;
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
    <% LFSR_BITS = LFSR_BITS_UP %>
    <% LFSR_INIT = LFSR_INIT_UP %>
    <%= ERB.new(File.read("src/LFSR.erb.v"),nil,nil,eoutvar='_sub01').result(binding) %>

    //generate LFSR_DOWNbit block
    <% LFSR_BITS = LFSR_BITS_DOWN %>
    <% LFSR_INIT = LFSR_INIT_DOWN %>
    <%= ERB.new(File.read("src/LFSR.erb.v"),nil,nil,eoutvar='_sub01').result(binding) %>



