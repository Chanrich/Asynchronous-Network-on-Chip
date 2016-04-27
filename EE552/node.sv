`timescale 1ns/100ps
import SystemVerilogCSP::*;

module node(interface in1, interface in2, interface in3, interface in4, 
	 interface out1, interface out2, interface out3, interface out4,
	 interface db, interface dg);

	// Set IP for current node.
	parameter MyIP = 0;

	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(11)) core_data_to_arbiter(); 
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(11)) arbiter_out (); 
	Channel #(.WIDTH(7), .hsProtocol(P4PhaseBD)) data_intf1  [1:0] (); 
    Channel #(.WIDTH(4), .hsProtocol(P4PhaseBD)) addr_intf1  [1:0] (); 
    Channel #(.WIDTH(11), .hsProtocol(P4PhaseBD)) data_11b (); 


	input_arbiter_block input_arbiter_block1(.in1(in1), .in2(in2), .in3(in3), .in4(in4),
							.core_data(core_data_to_arbiter), .data_out(arbiter_out));

	core core1 (.dg_8b(dg), .db_8b(db), .data_out_11b(core_data_to_arbiter), .data_in_11b(data_11b));

	path_computation_module #(.ADDR(MyIP)) pc (.in(arbiter_out), .d_out2core(data_11b),
						 .d_out2router1(out1), .d_out2router2(out2), .d_out2router3(out3), .d_out2router4(out4));

endmodule // node



