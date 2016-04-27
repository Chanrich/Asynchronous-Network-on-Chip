library verilog;
use verilog.vl_types.all;
entity Channel is
    generic(
        \SHARED\        : integer := 0;
        WIDTH           : integer := 8;
        hsProtocol      : vl_notype;
        NUMBER_OF_RECEIVERS: integer := 1
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of \SHARED\ : constant is 1;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of hsProtocol : constant is 4;
    attribute mti_svvh_generic_type of NUMBER_OF_RECEIVERS : constant is 1;
end Channel;
