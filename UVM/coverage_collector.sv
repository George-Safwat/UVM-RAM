package cov_pkg;
import uvm_pkg::*;
import seq_item_pkg::*;
import pkg_config::*;
 `include "uvm_macros.svh"
class ram_coverage extends uvm_component;
`uvm_component_utils(ram_coverage)

virtual ram_interface ram_vif;
uvm_analysis_export #(ram_seq_item) cov_export;
uvm_tlm_analysis_fifo #(ram_seq_item) cov_fifo;
ram_seq_item seq_item_cov;

covergroup cvr_gp;

Transaction_ordering_cp: coverpoint seq_item_cov.din[9:8]
{
    bins possible_values={2'b00,2'b01,2'b10,2'b11};
    bins write_address_then_write_data=(2'b00 => 2'b01);
    bins read_address_then_read_data=(2'b10 => 2'b11);
    bins wr_address_then_wr_data_rd_address_then_rd_data= (2'b00=>2'b01=>2'b10=>2'b11);
}
rx_valid_high_cp: coverpoint seq_item_cov.rx_valid
{bins rx_valid_high={1};}
tx_valid_high_cp: coverpoint seq_item_cov.tx_valid
iff(seq_item_cov.din[9:8]==2'b11)
{bins tx_valid_high={1};}

rx_valid_with_all_bins_din: cross Transaction_ordering_cp,rx_valid_high_cp;
rd_data_with_tx_valid_high: cross Transaction_ordering_cp,tx_valid_high_cp
{ignore_bins write_address_then_write_data_with_tx_valid_high= binsof(Transaction_ordering_cp.write_address_then_write_data);}

endgroup

function new(string name="alsu_scoreboard", uvm_component parent =null) ;
super.new(name,parent);
cvr_gp=new();//create covergroup
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
cov_export=new("cov_export",this);
cov_fifo=new("cov_fifo",this);
endfunction

function void connect_phase(uvm_phase phase); 
super.connect_phase(phase); 
cov_export.connect(cov_fifo.analysis_export);
endfunction


task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
cov_fifo.get(seq_item_cov);
cvr_gp.sample();
end
endtask

endclass
endpackage 