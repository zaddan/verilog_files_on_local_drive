library verilog;
use verilog.vl_types.all;
entity HA_X1_func is
    port(
        A               : in     vl_logic;
        B               : in     vl_logic;
        CO              : out    vl_logic;
        S               : out    vl_logic
    );
end HA_X1_func;
