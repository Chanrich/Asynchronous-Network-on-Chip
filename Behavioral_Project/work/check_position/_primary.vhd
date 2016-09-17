library verilog;
use verilog.vl_types.all;
entity check_position is
    generic(
        FL              : integer := 1;
        BL              : integer := 1;
        WIDTH           : integer := 4;
        ADDR            : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of FL : constant is 1;
    attribute mti_svvh_generic_type of BL : constant is 1;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ADDR : constant is 1;
end check_position;
