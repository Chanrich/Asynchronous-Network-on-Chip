library verilog;
use verilog.vl_types.all;
entity split_2 is
    generic(
        FL              : integer := 1;
        BL              : integer := 1;
        WIDTH           : integer := 11
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of FL : constant is 1;
    attribute mti_svvh_generic_type of BL : constant is 1;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
end split_2;
