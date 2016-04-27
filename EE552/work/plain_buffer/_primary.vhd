library verilog;
use verilog.vl_types.all;
entity plain_buffer is
    generic(
        FL              : integer := 2;
        BL              : integer := 2;
        WIDTH           : integer := 11
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of FL : constant is 1;
    attribute mti_svvh_generic_type of BL : constant is 1;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
end plain_buffer;
