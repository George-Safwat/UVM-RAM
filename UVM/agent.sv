package agt_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;
import pkg_driver::*;
import mon_pkg::*;
import pkg_config::*;
import sequencer_pkg::*;
import seq_item_pkg::*;
import seq_pkg::*;

class ram_agent extends uvm_agent;
`uvm_component_utils(ram_agent);

ram_driver drv; //Create object for driver
ram_sequencer sqr;//Create object for sequencer
ram_monitor mon;//Create object for monitor
ram_config_obj ram_config;//Create object for config_object

uvm_analysis_port #(ram_seq_item) agt_ap;


function new(string name="ram_agent",uvm_component parent =null) ;
super.new(name,parent);
endfunction

//This function to Place it in the uvm hierarchy without this fun tion we cannot use this class
//you cannot make object without this function 
//super.new ==> to go to parent uvm_agent and extends from it and identify who will be parent to this agent


function void build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db #(ram_config_obj)::get(this,"","CFG",ram_config))
`uvm_fatal("build_phase","Unable to get configuration object of driver");

drv=ram_driver::type_id:: create("drv",this);
sqr=ram_sequencer::type_id:: create("sqr",this);
mon=ram_monitor::type_id:: create("mon",this);
agt_ap=new("agt_ap",this);

endfunction

function void connect_phase(uvm_phase phase); 
super.connect_phase(phase); 
 //driver
drv.ram_vif=ram_config.ram_vif;
drv.seq_item_port.connect(sqr.seq_item_export);//TLM
//monitor
mon.ram_vif=ram_config.ram_vif;
mon.mon_ap.connect(agt_ap);
 endfunction




endclass
endpackage