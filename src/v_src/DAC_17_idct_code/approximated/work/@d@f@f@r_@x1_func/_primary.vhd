library verilog;
use verilog.vl_types.all;
entity DFFR_X1_func is
    port(
        CK              : in     vl_logic;
        D               : in     vl_logic;
        RN              : in     vl_logic;
        Q               : out    vl_logic;
        QN              : out    vl_logic
    );
end DFFR_X1_func;