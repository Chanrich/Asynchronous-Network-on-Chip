library verilog;
use verilog.vl_types.all;
entity two_input_xor is
    generic(
        FL              : integer := 1;
        BL              : integer := 1;
        ADDR            : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of FL : constant is 1;
    attribute mti_svvh_generic_type of BL : constant is 1;
    attribute mti_svvh_generic_type of ADDR : constant is 1;
end two_input_xor;
