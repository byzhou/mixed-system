`timescale 1ns/1ps

module t_LFSR () ;
   
    parameter upBits    = 15 ;
    parameter downBits  = 8 ;

endmodule
    
    //generate LFSR_8bit block
    <% LFSR_BITS = 8 %>
    <%= ERB.new(File.read("src/LFSR.erb.v"),nil,nil,eoutvar='_sub01').result(binding) %>

    //generate LFSR_16bit block
    <% LFSR_BITS = 16 %>
    <%= ERB.new(File.read("src/LFSR.erb.v"),nil,nil,eoutvar='_sub01').result(binding) %>
