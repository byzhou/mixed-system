
module LFSR_<%= LFSR_BITS %>BITS ( PRNG, SEED, clk);
    
    //LFSR bits are assigned during the erb compiling process
    parameter   REG_BITS    = <%= LFSR_BITS %> ;
    parameter   INIT        = <%= LFSR_INIT %> ; 
    
    //read interface for the verilog
    input wire [REG_BITS-1:0]   SEED ;
    input wire                  clk ;
    output reg [REG_BITS-1:0]   PRNG ;

    initial begin
        //initialization
        PRNG <= INIT ;
    end

    always @(posedge clk) begin
        //linear shifting part
        <% (1..LFSR_BITS - 1).each do |addr| %>
            PRNG[<%= addr %>] <= PRNG[<%= addr - 1 %>] ;
        <% end %>
        //including the seed to the feedback loop
        PRNG[0] <= 
        <% (0..LFSR_BITS - 1).each do |addr| %> 
            PRNG[<%= addr %>] ^
        <% end %>
        <% (0..LFSR_BITS - 2).each do |addr| %> 
            SEED[<%= addr %>] ^
        <% end %>
            SEED[<%= LFSR_BITS - 1 %>]
        ;
    end
endmodule



