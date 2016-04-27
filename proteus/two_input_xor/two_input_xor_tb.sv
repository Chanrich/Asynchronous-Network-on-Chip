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

module two_input_xor_cosim_tb;

	parameter W = 7;

	reg _RESET ;
	
	e1ofN_M #(.N(2), .M(4)) A ();
	e1ofN_M #(.N(2), .M(4)) A2 ();
	e1ofN_M #(.N(2), .M(4)) A2_CSP();
	e1ofN_M #(.N(2), .M(4)) A_CSP();
	e1ofN_M #(.N(2), .M(4)) A2_RTL();
	e1ofN_M #(.N(2), .M(4)) A_RTL();
	e1ofN_M #(.N(2), .M(4)) Sum_CSP();
	e1ofN_M #(.N(2), .M(4)) Sum_RTL();	

  
	data_generator	#(.W(4)) dgI1 (.R(A));
	data_generator	#(.W(4)) dgI2 (.R(A2));
	copy		#(.W(4)) cpdgI1 (.L(A), .R1(A_CSP), .R2(A_RTL));
	copy		#(.W(4)) cpdgI2 (.L(A2), .R1(A2_CSP), .R2(A2_RTL));

	
	two_input_xor_csp_gold	u_xor_csp	(.in(A_CSP),.out(Sum_CSP), .addr(A2_CSP) );
		
	two_input_xor_cosim_wrapper u_xor_rtl (.in(A_RTL),.out(Sum_RTL), .addr(A2_RTL), ._RESET(_RESET));
	
	cosim_checker	#(.W(4))	cc	(.L1(Sum_CSP), .L2(Sum_RTL));
	
	initial 
	begin : reset
	
		_RESET = 0;
		A_RTL.d_log= '0;
		A2_RTL.d_log= '0;
		Sum_RTL.e_log = '0;
		
		#400;  
		
		_RESET =  1;
		Sum_RTL.e_log = '1;

	end
	
endmodule