library verilog;
use verilog.vl_types.all;
entity DFFRS_X1 is
    port(
        CK              : in     vl_logic;
        D               : in     vl_logic;
        RN              : in     vl_logic;
        SN              : in     vl_logic;
        Q               : out    vl_logic;
        QN              : out    vl_logic
    );
end DFFRS_X1;
