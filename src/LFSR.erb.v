
model LFSR_<%= LFSR_BITS %>BITS ( PRNG, SEED, clk);

    parameter   REG_BITS    = <%= LFSR_BITS %> ;
    parameter   INIT        = <%= LFSR_INIT %> ; 

    input wire [REG_BITS-1:0]   SEED ;
    input wire                  clk ;
    output reg [REG_BITS-1:0]   PRNG ;

    initial begin
        PRNG <= INIT ;
    end

    always @(posedge clk) begin
        <% (1..LFSR_BITS - 1).each do |addr| %>
            PRNG[<%= addr %>] <= PRNG[<%= addr - 1 %>] ;
        <% end %>
        PRNG[0] <= 
        <% (0..LFSR_BITS - 1).each do |addr| %> 
            PRNG[<%= addr %>] ^
        <% end %>
        <% (0..LFSR_BITS - 1).each do |addr| %> 
            SEED[<%= addr %>] ^
        <% end %>
        ;
    end
endmodule



