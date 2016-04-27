library verilog;
use verilog.vl_types.all;
entity arbiter2 is
    generic(
        WIDTH           : integer := 11;
        FL              : integer := 2;
        BL              : integer := 2;
        ID              : integer := 0
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of FL : constant is 1;
    attribute mti_svvh_generic_type of BL : constant is 1;
    attribute mti_svvh_generic_type of ID : constant is 1;
end arbiter2;
