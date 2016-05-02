#!/bin/tcsh
set design = edu
if ( $1 == "skip") goto compile
echo "Checking Syntax of The Input File Using vlog ..."   
vlib work
vlog ${design}_csp.sv +incdir+$PROTEUS_PDK_PATH
if ($status != 0) exit(1)
echo "Running svc2rtl \n";
time svc2rtl ${design}_csp.sv ${design}.rtl.sv > & /dev/null
if ($status != 0) exit(1)
echo "Formatting Verilog Output"
iStyle ${design}.rtl.sv --style=ansi -s1 -M1 -m1 -E
if ($status != 0) exit(1)
echo "Running RC... \n";
time proteus-a --include=${design}.config --sv=1 --task=rc --force=1
if ($status != 0) exit(1)
echo "Running clockfree... \n";
time proteus-a --include=${design}.config --sv=1 --task=clockfree --force=1
if ($status != 0) exit(1)
echo "Running encounter... \n";
#time proteus-a --include=${design}.config --sv=1 --task=encounter --force=1
echo "Generating cosim wrapper... \n";
cosim_wrapper.pl *.qdi/*.qdi.noclk.flat.v ./${design}.qdi.noclk.flat.cosim.sv
if ($status != 0) exit(1)
echo "Reading total number of gates in RC results"
grep -C 5 "START: generating verilog" *.qdi/*rc.out | grep total
compile:
echo "Compiling the post synthesis top level file in Modelsim"
vlog ${design}.qdi.noclk.flat.cosim.sv +incdir+$PROTEUS_PDK_PATH
vlog core_db.qdi.noclk.flat.cosim.sv +incdir+$PROTEUS_PDK_PATH
vlog core_dg.qdi.noclk.flat.cosim.sv +incdir+$PROTEUS_PDK_PATH
vlog nodemerge.qdi.noclk.flat.cosim.sv +incdir+$PROTEUS_PDK_PATH
vlog routermerge.qdi.noclk.flat.cosim.sv +incdir+$PROTEUS_PDK_PATH
vlog arbiter_block.sv +incdir+$PROTEUS_PDK_PATH
## vlog core.sv +incdir+$PROTEUS_PDK_PATH
vlog path_comp.sv +incdir+$PROTEUS_PDK_PATH
vlog node.sv +incdir+$PROTEUS_PDK_PATH
vlog top.sv  +incdir+$PROTEUS_PDK_PATH
vlog test_bench.sv +incdir+$PROTEUS_PDK_PATH
echo "Creating Modelsim do file"
/usr/bin/rm run.do
echo "cd `pwd`" > run.do
echo "vsim work.tb_module -L $PROTEUS_PDK_PATH/qdi.synth -L $PROTEUS_PDK_PATH/svclib" >> run.do 
echo "Successful Compliation!"
vsim -do run.do
