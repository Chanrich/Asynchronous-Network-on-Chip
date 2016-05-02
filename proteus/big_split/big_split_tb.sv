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

module big_split_cosim_tb;

	parameter W = 7;

	reg _RESET ;
	
	e1ofN_M #(.N(2), .M(11)) inPort();
	e1ofN_M #(.N(2), .M(11)) inPort_CSP();
	e1ofN_M #(.N(2), .M(11)) inPort_RTL();
	e1ofN_M #(.N(2), .M(2)) controlPort();
	e1ofN_M #(.N(2), .M(2)) controlPort_CSP();
	e1ofN_M #(.N(2), .M(2)) controlPort_RTL();
	e1ofN_M #(.N(2), .M(1)) core_control();
	e1ofN_M #(.N(2), .M(1)) core_control_CSP();
	e1ofN_M #(.N(2), .M(1)) core_control_RTL();


	e1ofN_M #(.N(2), .M(11)) core_output();
	e1ofN_M #(.N(2), .M(11)) core_output_CSP();
	e1ofN_M #(.N(2), .M(11)) core_output_RTL();
	//e1ofN_M #(.N(2), .M(11)) outPort1();
	e1ofN_M #(.N(2), .M(11)) outPort1_CSP();
	e1ofN_M #(.N(2), .M(11)) outPort1_RTL();
	//e1ofN_M #(.N(2), .M(11)) outPort2();
	e1ofN_M #(.N(2), .M(11)) outPort2_CSP();
	e1ofN_M #(.N(2), .M(11)) outPort2_RTL();
	//e1ofN_M #(.N(2), .M(11)) outPort3();
	e1ofN_M #(.N(2), .M(11)) outPort3_CSP();
	e1ofN_M #(.N(2), .M(11)) outPort3_RTL();
	//e1ofN_M #(.N(2), .M(11)) outPort4();
	e1ofN_M #(.N(2), .M(11)) outPort4_CSP();
	e1ofN_M #(.N(2), .M(11)) outPort4_RTL();
  
	data_generator	#(.W(11)) dg1(.R(inPort));
	data_generator	#(.W(2)) dg2(.R(controlPort));
	data_generator	#(.W(1)) dg3(.R(A));
	copy		#(.W(11)) cp1 (.L(inPort), .R1(inPort_CSP), .R2(inPort_RTL));
	copy		#(.W(2)) cp2 (.L(controlPort), .R1(controlPort_CSP), .R2(controlPort_RTL));
	copy		#(.W(1)) cp3 (.L(core_control), .R1(core_control_CSP), .R2(core_control_RTL));

	
	big_split_csp_gold		u_big_split_csp	(.inPort(inPort_CSP), .controlPort(controlPort_CSP), .core_control(core_control_CSP), .core_output(core_output_CSP), .outPort1(outPort1_CSP), .outPort2(outPort2_CSP), .outPort3(outPort3_CSP), .outPort4(outPort4_CSP));
		
	big_split_cosim_wrapper u_big_split_rtl (.inPort(inPort_RTL), .controlPort(controlPort_RTL), .core_control(core_control_RTL), .core_output(core_output_RTL), .outPort1(outPort1_RTL), .outPort2(outPort2_RTL), .outPort3(outPort3_RTL), .outPort4(outPort4_RTL), ._RESET(_RESET));
	
	cosim_checker	#(.W(11))	cc1	(.L1(core_output_CSP), .L2(core_output_RTL));
	cosim_checker	#(.W(11))	cc2	(.L1(outPort1_CSP), .L2(outPort1_RTL));
	cosim_checker	#(.W(11))	cc3	(.L1(outPort2_CSP), .L2(outPort2_RTL));
	cosim_checker	#(.W(11))	cc4	(.L1(outPort3_CSP), .L2(outPort3_RTL));
	cosim_checker	#(.W(11))	cc5	(.L1(outPort4_CSP), .L2(outPort4_RTL));
	
	initial 
	begin : reset
	
		_RESET = 0;
		inPort_RTL.d_log= '0;
		controlPort_RTL.d_log= '0;
		core_control_RTL.d_log= '0;

		core_output_RTL.e_log = '0;
		outPort1_RTL.e_log = '0;
		outPort2_RTL.e_log = '0;
		outPort3_RTL.e_log = '0;
		outPort4_RTL.e_log = '0;
		
		#400;  
		
		_RESET =  1;
		core_output_RTL.e_log = '1;
		outPort1_RTL.e_log = '1;
		outPort2_RTL.e_log = '1;
		outPort3_RTL.e_log = '1;
		outPort4_RTL.e_log = '1;

	end
	
endmodule