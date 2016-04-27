library verilog;
use verilog.vl_types.all;
entity split is
    generic(
        FL              : integer := 0;
        BL              : integer := 0;
        WIDTH           : integer := 8
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of FL : constant is 1;
    attribute mti_svvh_generic_type of BL : constant is 1;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
end split;
