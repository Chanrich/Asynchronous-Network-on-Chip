library verilog;
use verilog.vl_types.all;
entity merge is
    generic(
        WIDTH           : integer := 11;
        FL              : integer := 2;
        BL              : integer := 2
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of FL : constant is 1;
    attribute mti_svvh_generic_type of BL : constant is 1;
end merge;
