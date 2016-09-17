library verilog;
use verilog.vl_types.all;
entity data_generator is
    generic(
        WIDTH           : integer := 8;
        FL              : integer := 0
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of FL : constant is 1;
end data_generator;
