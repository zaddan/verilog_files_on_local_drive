library verilog;
use verilog.vl_types.all;
entity XNOR2_X1_func is
    port(
        A               : in     vl_logic;
        B               : in     vl_logic;
        ZN              : out    vl_logic
    );
end XNOR2_X1_func;
