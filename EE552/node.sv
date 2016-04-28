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
    Channel #(.WIDTH(11), .hsProtocol(P4PhaseBD)) data_11b [4:0] (); 
    Channel #(.WIDTH(3), .hsProtocol(P4PhaseBD)) core_control_intf[4:0] (); 
    Channel #(.WIDTH(3), .hsProtocol(P4PhaseBD)) router_control_intf[3:0] (); 
    Channel #(.WIDTH(3), .hsProtocol(P4PhaseBD)) data_control_intf0[4:0] (); 
    Channel #(.WIDTH(3), .hsProtocol(P4PhaseBD)) data_control_intf1[4:0] (); 
    Channel #(.WIDTH(3), .hsProtocol(P4PhaseBD)) data_control_intf2[4:0] (); 
    Channel #(.WIDTH(3), .hsProtocol(P4PhaseBD)) data_control_intf3[4:0] (); 
    Channel #(.WIDTH(3), .hsProtocol(P4PhaseBD)) data_control_intf4[4:0] (); 

	Channel #(.WIDTH(11), .hsProtocol(P4PhaseBD)) data_to_merge0 [4:0] (); 
	Channel #(.WIDTH(11), .hsProtocol(P4PhaseBD)) data_to_merge1 [4:0] (); 
	Channel #(.WIDTH(11), .hsProtocol(P4PhaseBD)) data_to_merge2 [4:0] (); 
	Channel #(.WIDTH(11), .hsProtocol(P4PhaseBD)) data_to_merge3 [4:0] (); 
	Channel #(.WIDTH(11), .hsProtocol(P4PhaseBD)) data_to_merge4 [4:0] (); 



	core core1 (.dg_8b(dg), .db_8b(db), .data_out_11b(core_data_to_arbiter), .data_in_11b(data_11b[4]));

	path_computation_module #(.ADDR(MyIP), .ID(3'b000)) pc0 (.in(in1), .d_out2core(data_11b[0]),
						 .d_out2router1(data_to_merge0[0]), .d_out2router2(data_to_merge1[0]), .d_out2router3(data_to_merge2[0]), .d_out2router4(data_to_merge3[0]),
						 .core_control_out(core_control_intf[0]),
						 .control_out1(data_control_intf0[0]), .control_out2(data_control_intf0[1]), .control_out3(data_control_intf0[2]), .control_out4(data_control_intf0[3]));

	path_computation_module #(.ADDR(MyIP), .ID(3'b001)) pc1 (.in(in2), .d_out2core(data_11b[1]),
						 .d_out2router1(data_to_merge0[1]), .d_out2router2(data_to_merge1[1]), .d_out2router3(data_to_merge2[1]), .d_out2router4(data_to_merge3[1]),
						 .core_control_out(core_control_intf[1]),
						 .control_out1(data_control_intf1[0]), .control_out2(data_control_intf1[1]), .control_out3(data_control_intf1[2]), .control_out4(data_control_intf1[3]));

	path_computation_module #(.ADDR(MyIP), .ID(3'b010)) pc2 (.in(in3), .d_out2core(data_11b[2]),
						 .d_out2router1(data_to_merge0[2]), .d_out2router2(data_to_merge1[2]), .d_out2router3(data_to_merge2[2]), .d_out2router4(data_to_merge3[2]),
						 .core_control_out(core_control_intf[2]),
						 .control_out1(data_control_intf2[0]), .control_out2(data_control_intf2[1]), .control_out3(data_control_intf2[2]), .control_out4(data_control_intf2[3]));

	path_computation_module #(.ADDR(MyIP), .ID(3'b011)) pc3 (.in(in4), .d_out2core(data_11b[3]),
						 .d_out2router1(data_to_merge0[3]), .d_out2router2(data_to_merge1[3]), .d_out2router3(data_to_merge2[3]), .d_out2router4(data_to_merge3[3]),
						 .core_control_out(core_control_intf[3]),
						 .control_out1(data_control_intf3[0]), .control_out2(data_control_intf3[1]), .control_out3(data_control_intf3[2]), .control_out4(data_control_intf3[3]));

	path_computation_module_4out #(.ADDR(MyIP), .ID(3'b100)) pc4 (.in(core_data_to_arbiter),
            			 .d_out2router1(data_to_merge0[4]), .d_out2router2(data_to_merge1[4]), .d_out2router3(data_to_merge2[4]), .d_out2router4(data_to_merge3[4]),
            			  .control_out1(data_control_intf4[0]), .control_out2(data_control_intf4[1]), .control_out3(data_control_intf4[2]), .control_out4(data_control_intf4[3]));

	input_arbiter_4_2bit arbiter_4 (.in1(core_control_intf[0]), .in2(core_control_intf[1]),
									 .in3(core_control_intf[2]), .in4(core_control_intf[3]),
									 .data_out(core_control_intf[4]));
	node_merge node_merge1 (.in1(data_11b[0]), .in2(data_11b[1]), .in3(data_11b[2]), .in4(data_11b[3]),
					 .control_in(core_control_intf[4]), .out(data_11b[4]));
	/// DATA 
	router_merge router_merge0 (.in1(data_to_merge0[0]), .in2(data_to_merge0[1]), .in3(data_to_merge0[2]), .in4(data_to_merge0[3]), .in5(data_to_merge0[4]),
	 			.control_in(router_control_intf[0]), .out(out1));

		input_arbiter_5_3bit arbiter_51(.in1(data_control_intf0[0]), .in2(data_control_intf1[0]), .in3(data_control_intf2[0]), .in4(data_control_intf3[0]),
							.in5(data_control_intf4[0]), .data_out(router_control_intf[0]));

	router_merge router_merge1 (.in1(data_to_merge1[0]), .in2(data_to_merge1[1]), .in3(data_to_merge1[2]), .in4(data_to_merge1[3]), .in5(data_to_merge1[4]),
				 .control_in(router_control_intf[1]), .out(out2));

		input_arbiter_5_3bit arbiter_52(.in1(data_control_intf0[1]), .in2(data_control_intf1[1]), .in3(data_control_intf2[1]), .in4(data_control_intf3[1]),
							.in5(data_control_intf4[1]), .data_out(router_control_intf[1]));

	router_merge router_merge2 (.in1(data_to_merge2[0]), .in2(data_to_merge2[1]), .in3(data_to_merge2[2]), .in4(data_to_merge2[3]), .in5(data_to_merge2[4]),
				 .control_in(router_control_intf[2]), .out(out3));

		input_arbiter_5_3bit arbiter_53(.in1(data_control_intf0[2]), .in2(data_control_intf1[2]), .in3(data_control_intf2[2]), .in4(data_control_intf3[2]),
							.in5(data_control_intf4[2]), .data_out(router_control_intf[2]));

	router_merge router_merge3 (.in1(data_to_merge3[0]), .in2(data_to_merge3[1]), .in3(data_to_merge3[2]), .in4(data_to_merge3[3]), .in5(data_to_merge3[4]),
				 .control_in(router_control_intf[3]), .out(out4));

		input_arbiter_5_3bit arbiter_54(.in1(data_control_intf0[3]), .in2(data_control_intf1[3]), .in3(data_control_intf2[3]), .in4(data_control_intf3[3]),
							.in5(data_control_intf4[3]), .data_out(router_control_intf[3]));
endmodule // node

module node_merge (interface in1, interface in2, interface in3, interface in4, interface control_in, interface out);
	parameter FL = 2;
	parameter BL = 2;
	logic [10:0] data;
	logic [2:0] control_in_bit;
	always begin
		control_in.Receive(control_in_bit);
		if (control_in_bit == 0) 
			begin
				in1.Receive(data);
			end
		else if (control_in_bit == 1)
			begin
				in2.Receive(data);
			end
		else if (control_in_bit == 2)
			begin
				in3.Receive(data);
			end
		else if (control_in_bit == 3)
			begin
				in4.Receive(data);
			end

		#FL;
		out.Send(data);
		#BL;
	end
endmodule

module router_merge (interface in1, interface in2, interface in3, interface in4, interface in5, interface control_in, interface out);
	parameter FL = 2;
	parameter BL = 2;
	logic [10:0] data;
	logic [2:0] control_in_bit;
	always begin
		control_in.Receive(control_in_bit);
		if (control_in_bit == 0) 
			begin
				in1.Receive(data);
			end
		else if (control_in_bit == 1)
			begin
				in2.Receive(data);
			end
		else if (control_in_bit == 2)
			begin
				in3.Receive(data);
			end
		else if (control_in_bit == 3)
			begin
				in4.Receive(data);
			end
		else if (control_in_bit == 4)
			begin
				in5.Receive(data);
			end

		#FL;
		out.Send(data);
		#BL;
	end
endmodule


