library verilog;
use verilog.vl_types.all;
entity bitSlicer is
    generic(
        FL              : integer := 0;
        BL              : integer := 0
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of FL : constant is 1;
    attribute mti_svvh_generic_type of BL : constant is 1;
end bitSlicer;
