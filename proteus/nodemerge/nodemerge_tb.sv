//Written by Arash Saifhashemi
//Edited by Mehrdad
//EE552, Department of Electrical Engineering
//University of Southern California
//Spring 2011
`timescale 1ns/100ps
module data_generator (interface R);

  parameter W = 16; 
  reg unsigned [W-1:0] SendValue = 0;

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

module data_generator_control (interface R);

  parameter W = 16; 
  reg unsigned [W-1:0] SendValue = 0;

  initial
  begin
          #500; 
    forever
    begin
      SendValue = {$random} % 4;   
      R.Send(SendValue);
      $display("Send_Control: %d", SendValue);
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

module nodemerge_cosim_tb;
  parameter WIDTH = 11;
  logic _RESET;

  e1ofN_M #(.N(2), .M(11)) inPort0();
  e1ofN_M #(.N(2), .M(11)) inPort0_CSP();
  e1ofN_M #(.N(2), .M(11)) inPort0_RTL();

  e1ofN_M #(.N(2), .M(11)) inPort1();
  e1ofN_M #(.N(2), .M(11)) inPort1_CSP();
  e1ofN_M #(.N(2), .M(11)) inPort1_RTL();

  e1ofN_M #(.N(2), .M(11)) inPort2();
  e1ofN_M #(.N(2), .M(11)) inPort2_CSP();
  e1ofN_M #(.N(2), .M(11)) inPort2_RTL();

  e1ofN_M #(.N(2), .M(11)) inPort3();
  e1ofN_M #(.N(2), .M(11)) inPort3_CSP();
  e1ofN_M #(.N(2), .M(11)) inPort3_RTL();

  e1ofN_M #(.N(2), .M(3)) controlPort();
  e1ofN_M #(.N(2), .M(3)) controlPort_CSP();
  e1ofN_M #(.N(2), .M(3)) controlPort_RTL();

  //e1ofN_M #(.N(2), .M(11)) outPort();
  e1ofN_M #(.N(2), .M(11)) outPort_CSP();
  e1ofN_M #(.N(2), .M(11)) outPort_RTL();

  //data_generator #(.WIDTH(11)) dg(.data0(inPort0), .data1(inPort1), .data2(inPort2), .control(controlPort));
  data_generator #(.W(11)) dg1(.R(inPort0));
  data_generator #(.W(11)) dg2(.R(inPort1));
  data_generator #(.W(11)) dg3(.R(inPort2));
  data_generator #(.W(11)) dg4(.R(inPort3));
  data_generator_control #(.W(3)) dg5(.R(controlPort));
  copy #(.W(11)) cp1(.L(inPort0), .R1(inPort0_CSP), .R2(inPort0_RTL));
  copy #(.W(11)) cp2(.L(inPort1), .R1(inPort1_CSP), .R2(inPort1_RTL));
  copy #(.W(11)) cp3(.L(inPort2), .R1(inPort2_CSP), .R2(inPort2_RTL));
  copy #(.W(11)) cp4(.L(inPort3), .R1(inPort3_CSP), .R2(inPort3_RTL));
  copy #(.W(3)) cp5(.L(controlPort), .R1(controlPort_CSP), .R2(controlPort_RTL));

  nodemerge_csp_gold u_merge_csp(.in1(inPort0_CSP), .in2(inPort1_CSP), .in3(inPort2_CSP), .in4(inPort3_CSP),
             .control_in(controlPort_CSP), .out(outPort_CSP));
  nodemerge_cosim_wrapper u_merge_rtl(.in1(inPort0_RTL), .in2(inPort1_RTL), .in3(inPort2_RTL), .in4(inPort3_RTL),
             .control_in(controlPort_RTL), .out(outPort_RTL), ._RESET(_RESET));

  cosim_checker #(.W(11)) cc1(.L1(outPort_CSP), .L2(outPort_RTL));

  initial 
  begin : reset
  
    _RESET = 0;
    controlPort_RTL.d_log = '0;
    inPort0_RTL.d_log = '0;
    inPort1_RTL.d_log = '0;
    inPort2_RTL.d_log = '0;
    inPort3_RTL.d_log = '0;
    
    outPort_RTL.e_log = '0;
    
    #400;  
    
    _RESET =  1;
    outPort_RTL.e_log = '1;

  end

endmodule