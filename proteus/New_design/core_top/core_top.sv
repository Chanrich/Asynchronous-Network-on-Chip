`timescale 1ns/100ps
import SystemVerilogCSP::*;

module core_top (interface dg_8b, interface db_8b, interface data_out_11b, interface data_in_11b);
	core_db core_db (interface db_8b, interface data_in_11b);
	core_dg core_dg (interface dg_8b, interface data_out_11b);
endmodule

