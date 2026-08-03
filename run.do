vlib work
vlog *.sv
vsim -voptargs=+acc top
add wave *
run -all
quit -sim