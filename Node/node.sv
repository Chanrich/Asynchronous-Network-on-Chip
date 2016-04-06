`timescale 1ns/100ps
import SystemVerilogCSP::*;

module node(interface in1, interface in2, interface in3, interface in4, 
	 interface out1, interface out2, interface out3, interface out4,
	 interface db, interface dg);

	// Set IP for current node.
	parameter MyIP = 0;

	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(11)) data_to_merge_intf[2:0] (); 
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(2)) merge_control[1:0] (); 
	Channel #(.WIDTH(7), .hsProtocol(P4PhaseBD)) data_intf1  [1:0] (); 
    Channel #(.WIDTH(4), .hsProtocol(P4PhaseBD)) addr_intf1  [1:0] (); 
    Channel #(.WIDTH(11), .hsProtocol(P4PhaseBD)) data_11b (); 


	input_arbiter_block input_arbiter_block1(.in1(in1), .in2(in2), .in3(in3), .in4(in4),
							.data1_to_merge(data_to_merge_intf[0]), .data2_to_merge(data_to_merge_intf[1]),
							.core_control(merge_control[0]), .merge_control_out(merge_control[1]));

	core core1 (.dg_8b(dg), .db_8b(db), .data_out_11b(data_to_merge_intf[2]), .data_control_out(merge_control[0]), .data_in_11b(data_11b));

	input_process_block input_process_block(.input1_to_merge(data_to_merge_intf[0]), .input2_to_merge(data_to_merge_intf[1]),
							.core_data(data_to_merge_intf[2]), .merge_control(merge_control[1]),
							.addr_out(addr_intf1[0]), .hamming_out(data_intf1[0]));

	edu edu1(.datain(data_intf1[0]), .dataout(data_intf1[1]));

	path_computation_module #(.ADDR(MyIP)) pc (.d_in(data_intf1[1]), .addr_in(addr_intf1[0]), .d_out2core(data_11b),
						 .d_out2router1(out1), .d_out2router2(out2), .d_out2router3(out3), .d_out2router4(out4));

endmodule // node




module node_tb;
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(11)) data_inputs[3:0] (); 
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(11)) data_outputs[3:0] (); 
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(8)) data_generator_intf (); 
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(8)) data_bucket_intf (); 

	// data_generator #(.WIDTH(8), .FL(0), .DELAY(5)) dg1(.r(intf[0]));

	data_bucket #(.WIDTH(8), .BL(0)) db1(.l(data_bucket_intf));

	// Set node to IP 2
	node #(.MyIP(4'b0010)) node1 (.in1(data_inputs[0]), .in2(data_inputs[1]), .in3(data_inputs[2]), .in4(data_inputs[3]), 
	 .out1(data_outputs[0]), .out2(data_outputs[1]), .out3(data_outputs[2]), .out4(data_outputs[3]),
	 .db(data_bucket_intf), .dg(data_generator_intf));

	initial 
	begin
		data_generator_intf.Send(8'b11110010);

	end
endmodule