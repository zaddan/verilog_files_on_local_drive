library verilog;
use verilog.vl_types.all;
entity dct is
    generic(
        BitWidth        : integer := 31;
        BitWidth1       : integer := 32
    );
    port(
        clk             : in     vl_logic;
        start           : in     vl_logic;
        reset           : in     vl_logic;
        din             : in     vl_logic_vector;
        done            : out    vl_logic;
        dout            : out    vl_logic_vector;
        reading         : out    vl_logic;
        state_out       : out    vl_logic_vector(2 downto 0)
    );
end dct;
