package pkg_driver;
import uvm_pkg::*;
import pkg_config::*;
import sequencer_pkg::*;
import seq_item_pkg::*;
import seq_pkg::*;
 `include "uvm_macros.svh"
class ram_driver extends uvm_driver #(ram_seq_item);
`uvm_component_utils(ram_driver)

virtual ram_interface ram_vif;
ram_seq_item stim_seq_item;

function new(string name="ram_driver",uvm_component parent =null) ;
super.new(name,parent);
endfunction


task run_phase(uvm_phase phase);
forever begin
               stim_seq_item=ram_seq_item::type_id::create("stim_seq_item"); 
               seq_item_port.get_next_item(stim_seq_item); //start of pulling data from sequencer

                ram_vif.rst_n=stim_seq_item.rst_n; 
                ram_vif.din=stim_seq_item.din; 
                ram_vif.rx_valid=stim_seq_item.rx_valid; 
                @(negedge ram_vif.clk);
                 
                seq_item_port.item_done(); //End of pilling
     `uvm_info("run_phase",stim_seq_item.convert2string_stimulus(),UVM_HIGH); 
end
endtask
endclass
endpackage