#!/bin/tcsh
vlib work
echo "Compiling the post synthesis top level file in Modelsim"
vlog edu.qdi.noclk.flat.cosim.sv +incdir+$PROTEUS_PDK_PATH
vlog nodemerge.qdi.noclk.flat.cosim.sv +incdir+$PROTEUS_PDK_PATH
vlog routermerge.qdi.noclk.flat.cosim.sv +incdir+$PROTEUS_PDK_PATH
vlog arbiter_block.sv +incdir+$PROTEUS_PDK_PATH
vlog core_db_csp_gold.sv +incdir+$PROTEUS_PDK_PATH
vlog core_dg_csp_gold.sv +incdir+$PROTEUS_PDK_PATH
vlog core.sv +incdir+$PROTEUS_PDK_PATH
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
