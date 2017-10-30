library verilog;
use verilog.vl_types.all;
entity idct_BitWidth31_BitWidth130 is
    port(
        clk             : in     vl_logic;
        start           : in     vl_logic;
        racc            : in     vl_logic;
        rapx            : in     vl_logic;
        din             : in     vl_logic_vector(31 downto 0);
        done            : out    vl_logic;
        dout            : out    vl_logic_vector(31 downto 0);
        reading         : out    vl_logic;
        state_out       : out    vl_logic_vector(2 downto 0)
    );
end idct_BitWidth31_BitWidth130;
