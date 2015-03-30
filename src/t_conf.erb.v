`timescale 1ns/1ps
`define DEBUG

module t_conf () ;

    //ruby initialization
    <% CONF_BITS  = 16 %>
    <% INIT_BITS_F = "16'hFFFF" %> 
    <% INIT_BITS_O = "16'h0000" %> 
    <% INIT_BITS_X = "16'hXXXX" %> 

    //inputs, feedback signal from the system
    reg                                 O_INVU ;
    reg                                 O_INVD ;
    reg                                 CLK ;

    //outputs for the configuration module
    wire    [<%= CONF_BITS - 1 %>:0]     INVU_NCONF ;
    wire    [<%= CONF_BITS - 1 %>:0]     INVU_PCONF ;
    wire    [<%= CONF_BITS - 1 %>:0]     INVD_NCONF ;
    wire    [<%= CONF_BITS - 1 %>:0]     INVD_PCONF ;

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

    CONF_<%= CONF_BITS %>BITS CONF (
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
    <%= ERB.new(File.read("src/conf.erb.v"),nil,nil,eoutvar='_sub01').result(binding) %>

