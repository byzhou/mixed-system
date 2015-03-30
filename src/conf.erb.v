
module CONF_<%= CONF_BITS %>BITS ( INVU_NCONF, INVU_PCONF, INVD_NCONF, INVD_PCONF, O_INVU, O_INVD, CLK) ;
    //The start of this code needs four variables
    //CONF_BITS INIT_BITS_F INIT_BITS_O INIT_BITS_X
    input wire                               O_INVU ;
    input wire                               O_INVD ;
    input wire                               CLK ;

    output reg [<%= CONF_BITS - 1 %>:0]      INVU_NCONF ;
    output reg [<%= CONF_BITS - 1 %>:0]      INVU_PCONF ;
    output reg [<%= CONF_BITS - 1 %>:0]      INVD_NCONF ;
    output reg [<%= CONF_BITS - 1 %>:0]      INVD_PCONF ;

    initial begin
        //suppose the init bits can only be all fs or all 0s
        //INIT_BITS_X represents all xs
        INVU_NCONF <= <%= INIT_BITS_F %> ;
        INVU_PCONF <= <%= INIT_BITS_F %> ;
        INVD_NCONF <= <%= INIT_BITS_O %> ;
        INVD_PCONF <= <%= INIT_BITS_O %> ;
    end

    always @(posedge CLK) begin
        case ({O_INVU,O_INVD,INVU_PCONF,INVU_NCONF,INVD_PCONF,INVD_NCONF})
            {2'b01,<%= INIT_BITS_F %>,<%= INIT_BITS_F %>,<%= INIT_BITS_O %>,<%= INIT_BITS_O %>}:begin
                    //do nothing;
                    INVU_PCONF <= INVU_PCONF ;
                    INVU_NCONF <= INVU_NCONF ;
                    INVD_PCONF <= INVD_PCONF ;
                    INVD_NCONF <= INVD_NCONF ;
                end
            {2'b10,<%= INIT_BITS_O %>,<%= INIT_BITS_O %>,<%= INIT_BITS_F %>,<%= INIT_BITS_F %>}:begin
                    //do nothing;
                    INVU_PCONF <= INVU_PCONF ;
                    INVU_NCONF <= INVU_NCONF ;
                    INVD_PCONF <= INVD_PCONF ;
                    INVD_NCONF <= INVD_NCONF ;
                end
            {2'b10,<%= INIT_BITS_O %>,<%= INIT_BITS_X %>,<%= INIT_BITS_F %>,<%= INIT_BITS_X %>}:begin
                    //config PMOS 
                    INVU_PCONF <= INVU_PCONF - 1 ;
                    INVD_PCONF <= INVU_PCONF + 1 ;
                end
            {2'b01,<%= INIT_BITS_X %>,<%= INIT_BITS_F %>,<%= INIT_BITS_X %>,<%= INIT_BITS_O %>}:begin
                    //config PMOS 
                    INVU_PCONF <= INVU_PCONF + 1 ;
                    INVD_PCONF <= INVU_PCONF - 1 ;
                end
            {2'b10,<%= INIT_BITS_X %>,<%= INIT_BITS_X %>,<%= INIT_BITS_X %>,<%= INIT_BITS_X %>}:begin
                    //config NMOS
                    INVU_NCONF <= INVU_NCONF - 1 ;
                    INVD_NCONF <= INVU_NCONF + 1 ;
                end
            {2'b01,<%= INIT_BITS_X %>,<%= INIT_BITS_X %>,<%= INIT_BITS_X %>,<%= INIT_BITS_X %>}:begin
                    //config NMOS 
                    INVU_NCONF <= INVU_NCONF + 1 ;
                    INVD_NCONF <= INVU_NCONF - 1 ;
                end
        endcase
    end

endmodule

