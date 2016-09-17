library verilog;
use verilog.vl_types.all;
entity path_computation_module is
    generic(
        ADDR            : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ADDR : constant is 1;
end path_computation_module;
