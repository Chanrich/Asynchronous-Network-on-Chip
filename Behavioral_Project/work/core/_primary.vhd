library verilog;
use verilog.vl_types.all;
entity core is
    generic(
        FL              : integer := 2;
        BL              : integer := 2
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of FL : constant is 1;
    attribute mti_svvh_generic_type of BL : constant is 1;
end core;
