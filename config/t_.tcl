vlib work
do generated_vars.tcl
#vlog $NANGATE
#vlog $PAR
pwd
vlog +incdir$INCLUDE_DIR $TOP
vsim -voptargs=+acc work.$TOPLEVEL
vcd file ./$TOPLEVEL.vcd
vcd add -r /$TOPLEVEL/*
run $RUNTIME
vcd flush
quit
