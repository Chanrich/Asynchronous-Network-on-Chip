library verilog;
use verilog.vl_types.all;
entity node is
    generic(
        MyIP            : integer := 0
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of MyIP : constant is 1;
end node;
