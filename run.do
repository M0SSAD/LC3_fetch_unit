vlib work
vlog *.sv
vsim -voptargs=+acc top
add wave *
run _all
quit -sim