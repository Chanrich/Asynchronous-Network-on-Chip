`include "svc2rtl.sv"
`E1OFN_M(2,11)
`timescale 1ns/100ps
module full_buffer_node(interface L, interface R);
  logic[10:0] data;
  always begin
    L.Receive(data);
    R.Send(data);
  end

endmodule

module node(interface in1, interface in2, interface in3, interface in4,
	 interface out1, interface out2, interface out3, interface out4,
	 interface db, interface dg);

	// Set IP for current node.
	parameter MyIP = 0;
	reg _RESET;
	e1ofN_M #(.N(2), .M(11)) core_data_to_arbiter(); 
	e1ofN_M #(.N(2), .M(11)) core_data_to_arbiter_buf(); 
    e1ofN_M #(.N(2), .M(11)) data_11b [4:0] (); 
    // e1ofN_M #(.N(2), .M(11)) data_11b_2(); 
    e1ofN_M #(.N(2), .M(3))  core_control_intf[4:0] (); 
    e1ofN_M #(.N(2), .M(3))  router_control_intf[3:0] (); 
    e1ofN_M #(.N(2), .M(3))  data_control_intf0[3:0] (); 
    e1ofN_M #(.N(2), .M(3))  data_control_intf1[3:0] (); 
    e1ofN_M #(.N(2), .M(3))  data_control_intf2[3:0] (); 
    e1ofN_M #(.N(2), .M(3))  data_control_intf3[3:0] (); 
    e1ofN_M #(.N(2), .M(3))  data_control_intf4[3:0] (); 
    e1ofN_M #(.N(2), .M(11))  dg_buf (); 

	e1ofN_M #(.N(2), .M(11)) data_to_merge0 [4:0] (); 
	e1ofN_M #(.N(2), .M(11)) data_to_merge1 [4:0] (); 
	e1ofN_M #(.N(2), .M(11)) data_to_merge2 [4:0] (); 
	e1ofN_M #(.N(2), .M(11)) data_to_merge3 [4:0] (); 
	e1ofN_M #(.N(2), .M(11)) data_to_merge4 [4:0] (); 

	// full_buffer_node full_buffer_node1(.L(dg), .R(dg_buf));
	// full_buffer_node full_buffer_node2(.L(core_data_to_arbiter), .R(core_data_to_arbiter_buf));
	// core_db_csp_gold core_db_wrap (.db8b(db), .datain11b(data_11b[4]));
	// core_dg_csp_gold core_dg_wrap (.dg_8b(dg), .data_out_11b(core_data_to_arbiter));
	core core1 (.dg_8b(dg), .db_8b(db), .data_out_11b(core_data_to_arbiter), .data_in_11b(data_11b[4]));
	//full_buffer_node full_buffer_node1(.L(data_11b[4]), .R(data_11b_2));
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

	input_arbiter_4_3bit arbiter_4 (.in1(core_control_intf[0]), .in2(core_control_intf[1]),
									 .in3(core_control_intf[2]), .in4(core_control_intf[3]),
									 .data_out(core_control_intf[4]));
	nodemerge_cosim_wrapper node_merge_wrap (.in1(data_11b[0]), .in2(data_11b[1]), .in3(data_11b[2]), .in4(data_11b[3]),
					 .control_in(core_control_intf[4]), .out(data_11b[4]), ._RESET(_RESET));
	// node_merge node_merge1 (.in1(data_11b[0]), .in2(data_11b[1]), .in3(data_11b[2]), .in4(data_11b[3]),
	// 				 .control_in(core_control_intf[4]), .out(data_11b[4]));
	/// DATA 

routermerge_cosim_wrapper router_merge_wrap0 (.in1(data_to_merge0[0]), .in2(data_to_merge0[1]), .in3(data_to_merge0[2]), .in4(data_to_merge0[3]), .in5(data_to_merge0[4]),
	 			.control_in(router_control_intf[0]), .out(out1), ._RESET(_RESET));
	// router_merge router_merge0 (.in1(data_to_merge0[0]), .in2(data_to_merge0[1]), .in3(data_to_merge0[2]), .in4(data_to_merge0[3]), .in5(data_to_merge0[4]),
	//  			.control_in(router_control_intf[0]), .out(out1));

		input_arbiter_5_3bit arbiter_51(.in1(data_control_intf0[0]), .in2(data_control_intf1[0]), .in3(data_control_intf2[0]), .in4(data_control_intf3[0]),
							.in5(data_control_intf4[0]), .data_out(router_control_intf[0]));

routermerge_cosim_wrapper router_merge_wrap1 (.in1(data_to_merge1[0]), .in2(data_to_merge1[1]), .in3(data_to_merge1[2]), .in4(data_to_merge1[3]), .in5(data_to_merge1[4]),
				 .control_in(router_control_intf[1]), .out(out2), ._RESET(_RESET));

	// router_merge router_merge1 (.in1(data_to_merge1[0]), .in2(data_to_merge1[1]), .in3(data_to_merge1[2]), .in4(data_to_merge1[3]), .in5(data_to_merge1[4]),
	// 			 .control_in(router_control_intf[1]), .out(out2));

		input_arbiter_5_3bit arbiter_52(.in1(data_control_intf0[1]), .in2(data_control_intf1[1]), .in3(data_control_intf2[1]), .in4(data_control_intf3[1]),
							.in5(data_control_intf4[1]), .data_out(router_control_intf[1]));

routermerge_cosim_wrapper router_merge_wrap2 (.in1(data_to_merge2[0]), .in2(data_to_merge2[1]), .in3(data_to_merge2[2]), .in4(data_to_merge2[3]), .in5(data_to_merge2[4]),
				 .control_in(router_control_intf[2]), .out(out3), ._RESET(_RESET));
	// router_merge router_merge2 (.in1(data_to_merge2[0]), .in2(data_to_merge2[1]), .in3(data_to_merge2[2]), .in4(data_to_merge2[3]), .in5(data_to_merge2[4]),
	// 			 .control_in(router_control_intf[2]), .out(out3));

		input_arbiter_5_3bit arbiter_53(.in1(data_control_intf0[2]), .in2(data_control_intf1[2]), .in3(data_control_intf2[2]), .in4(data_control_intf3[2]),
							.in5(data_control_intf4[2]), .data_out(router_control_intf[2]));
routermerge_cosim_wrapper router_merge_wrap3 (.in1(data_to_merge3[0]), .in2(data_to_merge3[1]), .in3(data_to_merge3[2]), .in4(data_to_merge3[3]), .in5(data_to_merge3[4]),
				 .control_in(router_control_intf[3]), .out(out4), ._RESET(_RESET));
	// router_merge router_merge3 (.in1(data_to_merge3[0]), .in2(data_to_merge3[1]), .in3(data_to_merge3[2]), .in4(data_to_merge3[3]), .in5(data_to_merge3[4]),
	// 			 .control_in(router_control_intf[3]), .out(out4));

		input_arbiter_5_3bit arbiter_54(.in1(data_control_intf0[3]), .in2(data_control_intf1[3]), .in3(data_control_intf2[3]), .in4(data_control_intf3[3]),
							.in5(data_control_intf4[3]), .data_out(router_control_intf[3]));

		initial begin
		    _RESET = 0;
		    // dg_buf.d_log = '0;   
		    // data_11b[4].d_log = '0; 

		    // // Send
		    // core_data_to_arbiter.e_log = '0;
		    // db.e_log = '0;
		    // Node merge
		    data_11b[0].d_log = '0;    
		    data_11b[1].d_log = '0;    
		    data_11b[2].d_log = '0;  
		    data_11b[3].d_log = '0;  
		    core_control_intf[4].d_log = '0;

		    // Router Merge 1
		    router_control_intf[0].d_log = '0;
		    router_control_intf[1].d_log = '0;
		    router_control_intf[2].d_log = '0;
		    router_control_intf[3].d_log = '0;
		    data_to_merge0[0].d_log = '0;
		    data_to_merge0[1].d_log = '0;
		    data_to_merge0[2].d_log = '0;
		    data_to_merge0[3].d_log = '0;
		    data_to_merge0[4].d_log = '0;
		    data_to_merge1[0].d_log = '0;
		    data_to_merge1[1].d_log = '0;
		    data_to_merge1[2].d_log = '0;
		    data_to_merge1[3].d_log = '0;
		    data_to_merge1[4].d_log = '0;
		    data_to_merge2[0].d_log = '0;
		    data_to_merge2[1].d_log = '0;
		    data_to_merge2[2].d_log = '0;
		    data_to_merge2[3].d_log = '0;
		    data_to_merge2[4].d_log = '0;
		    data_to_merge3[0].d_log = '0;
		    data_to_merge3[1].d_log = '0;
		    data_to_merge3[2].d_log = '0;
		    data_to_merge3[3].d_log = '0;
		    data_to_merge3[4].d_log = '0;


		    data_11b[4].e_log = '0;
		    out1.e_log = '0;
		    out2.e_log = '0;
		    out3.e_log = '0;
		    out4.e_log = '0;
		    #400;  
		    _RESET = 1;
		    // Node merge
		    data_11b[4].e_log = '1;
		    // Router 1
		    out1.e_log = '1;
		    out2.e_log = '1;
		    out3.e_log = '1;
		    out4.e_log = '1;
		    // core_data_to_arbiter.e_log = '1;
		    // db.e_log = '1;

		end
endmodule // node

module node_merge (interface in1, interface in2, interface in3, interface in4, interface control_in, interface out);
	parameter FL = 1;
	parameter BL = 1;
	logic [10:0] data;
	logic [2:0] control_in_bit;
	always begin
		control_in.Receive(control_in_bit);
		if (control_in_bit == 3'b000) 
			begin
				in1.Receive(data);
			end
		else if (control_in_bit == 3'b001)
			begin
				in2.Receive(data);
			end
		else if (control_in_bit == 3'b010)
			begin
				in3.Receive(data);
			end
		else if (control_in_bit == 3'b011)
			begin
				in4.Receive(data);
			end

		#FL;
		out.Send(data);
		#BL;
	end
endmodule

module router_merge (interface in1, interface in2, interface in3, interface in4, interface in5, interface control_in, interface out);
	parameter FL = 1;
	parameter BL = 1;
	logic [10:0] data;
	logic [2:0] control_in_bit;
	always begin
		control_in.Receive(control_in_bit);
		if (control_in_bit == 3'b000) 
			begin
				in1.Receive(data);
			end
		else if (control_in_bit == 3'b001)
			begin
				in2.Receive(data);
			end
		else if (control_in_bit == 3'b010)
			begin
				in3.Receive(data);
			end
		else if (control_in_bit == 3'b011)
			begin
				in4.Receive(data);
			end
		else if (control_in_bit == 3'b100)
			begin
				in5.Receive(data);
			end

		#FL;
		out.Send(data);
		#BL;
	end
endmodule
