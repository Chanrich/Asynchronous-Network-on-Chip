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

module core_db_cosim_tb;

	parameter W = 7;

	reg _RESET ;
	
	e1ofN_M #(.N(2), .M(7)) A ();
	e1ofN_M #(.N(2), .M(7)) A_CSP();
	e1ofN_M #(.N(2), .M(7)) A_RTL();
	e1ofN_M #(.N(2), .M(7)) Sum_CSP();
	e1ofN_M #(.N(2), .M(7)) Sum_RTL();	
  
	data_generator	#(.W(7)) dgI1 (.R(A));
	copy		#(.W(7)) cpdgI1 (.L(A), .R1(A_CSP), .R2(A_RTL));

	
	core_db_csp_gold		u_ecu_csp	(.db_8b(), .data_in_11b());
		
	core_db_cosim_wrapper u_ecu_rtl (.datain(A_RTL), .dataout(Sum_RTL) , ._RESET(_RESET));
	
	cosim_checker	#(.W(7))	cc	(.L1(Sum_CSP), .L2(Sum_RTL));
	
	initial 
	begin : reset
	
		_RESET = 0;
		A_RTL.d_log= '0;
		Sum_RTL.e_log = '0;
		
		#400;  
		
		_RESET =  1;
		Sum_RTL.e_log = '1;

	end
	
endmodule