quit -sim

vlog ../../source/sv/rtl/*.sv
vlog ../../source/sv/rtl_tb/*.sv

vsim -t ns -novopt work.testbench
do wave_pipeline.do
add log -r /*
run 1 us
#run -all
