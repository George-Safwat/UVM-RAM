vlib work
vlog -f ram/src_files.list\
    +incdir+ram/uvm\
    +incdir+ram/rtl  +cover -covercells

vsim -voptargs=+acc work.top -cover -classdebug -uvmcontrol=all
coverage exclude -src ram/rtl/RAM.sv -line 20 -code b
coverage exclude -src ram/rtl/RAM.sv -line 20 -code s
coverage save ram.ucdb -onexit -du work.RAM
add wave -position insertpoint sim:/top/intf/*
add wave -position insertpoint sim:/top/DUT/*
add wave /top/DUT/binding_all/Assert_reset /top/DUT/binding_all/Assert_tx_valid /top/DUT/binding_all/Assert_tx_valid_fell /top/DUT/binding_all/Assert_wr_add_to_wr_data /top/DUT/binding_all/Assert_rd_add_to_rd_data /top/assertion/Assert_reset /top/assertion/Assert_tx_valid /top/assertion/Assert_tx_valid_fell /top/assertion/Assert_wr_add_to_wr_data /top/assertion/Assert_rd_add_to_rd_data
run -all
coverage report -detail -cvg -directive -comments -file F_cover_RAM.txt -noa -all
#quit -sim
#vcover report ram.ucdb -details -all -output coverage_rpt_RAM.txt



