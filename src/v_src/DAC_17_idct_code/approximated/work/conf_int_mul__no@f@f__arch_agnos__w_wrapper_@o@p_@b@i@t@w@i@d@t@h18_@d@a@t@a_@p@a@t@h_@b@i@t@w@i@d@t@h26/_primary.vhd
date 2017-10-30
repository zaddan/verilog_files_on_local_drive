library verilog;
use verilog.vl_types.all;
entity \conf_int_mul__noFF__arch_agnos__w_wrapper_OP_BITWIDTH18_DATA_PATH_BITWIDTH26\ is
    port(
        A_in_to_wrapper : in     vl_logic_vector(25 downto 0);
        B_in_to_wrapper : in     vl_logic_vector(14 downto 0);
        state_in_to_wrapper: in     vl_logic_vector(2 downto 0);
        rstP            : in     vl_logic;
        clk             : in     vl_logic;
        racc            : in     vl_logic;
        rapx            : in     vl_logic;
        P               : out    vl_logic_vector(31 downto 0);
        count0          : in     vl_logic_vector(8 downto 0);
        state_out_of_wrapper: out    vl_logic_vector(2 downto 0)
    );
end \conf_int_mul__noFF__arch_agnos__w_wrapper_OP_BITWIDTH18_DATA_PATH_BITWIDTH26\;
