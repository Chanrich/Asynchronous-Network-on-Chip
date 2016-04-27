//Written by Arash Saifhashemi
//Edited by Mehrdad
//EE552, Department of Electrical Engineering
//University of Southern California
//Spring 2011
`timescale 1ns/100ps
module data_generator (interface R);

	parameter W = 16;	
	reg signed [W-1:0] SendValue = 0;

	initial
	begin
	        #500;	
		forever
		begin
			SendValue = SendValue + 1;		
			R.Send(SendValue);
			$display("Send: %d", SendValue);
		end
	end
endmodule

module copy (interface L, interface R1, interface R2);

	parameter W = 16;
	logic [W-1:0] data = 0;

	always
	begin
		L.Receive(data);
		fork
			R1.Send(data);
			R2.Send(data);
		join
	end
endmodule

module cosim_checker (interface L1, interface L2);

	parameter W = 16;

	reg signed [W-1:0] CSPReceiveValue = 0;
	reg signed [W-1:0] ProteusReceiveValue = 0;

	always
	begin
		#300;
		fork
			L1.Receive(CSPReceiveValue);
			L2.Receive(ProteusReceiveValue);
		join
		if (CSPReceiveValue != ProteusReceiveValue)
			$display("ERROR");
		else
			$display("CORRECT");

		$display("CSPReceiveValue = %d", CSPReceiveValue);
		$display("ProteusReceiveValue = %d", ProteusReceiveValue);			
	end
endmodule

module check_position_cosim_tb;

	parameter W = 7;

	reg _RESET ;
	
	e1ofN_M #(.N(2), .M(4)) A ();
	e1ofN_M #(.N(2), .M(4)) A_CSP();
	e1ofN_M #(.N(2), .M(4)) A_RTL();

	e1ofN_M #(.N(2), .M(1)) Sum_CSP();
	e1ofN_M #(.N(2), .M(1)) Sum_RTL();	
	e1ofN_M #(.N(2), .M(2)) Sum2_CSP();
	e1ofN_M #(.N(2), .M(2)) Sum2_RTL();	
  
	data_generator	#(.W(4)) dgI1 (.R(A));
	copy		#(.W(4)) cpdgI1 (.L(A), .R1(A_CSP), .R2(A_RTL));

	
	check_position_csp_gold		u_ecu_csp	(.in(A_CSP), .core_contr(Sum_CSP), .router_contr(Sum2_CSP));
		
	check_position_cosim_wrapper u_ecu_rtl (.in(A_RTL), .core_contr(Sum_RTL), .router_contr(Sum2_RTL), ._RESET(_RESET));
	
	cosim_checker	#(.W(1))	cc	(.L1(Sum_CSP), .L2(Sum_RTL));
	cosim_checker	#(.W(2))	cc2	(.L1(Sum2_CSP), .L2(Sum2_RTL));
	
	initial 
	begin : reset
	
		_RESET = 0;
		A_RTL.d_log= '0;
		Sum_RTL.e_log = '0;
		Sum2_RTL.e_log = '0;
		
		#400;  
		
		_RESET =  1;
		Sum_RTL.e_log = '1;
		Sum2_RTL.e_log = '1;

	end
	
endmodule