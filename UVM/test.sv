package pkg_test;
import agt_pkg::*;
import pkg_driver::*;
import uvm_pkg::*;
import seq_item_pkg::*;
import seq_pkg::*;
import sequencer_pkg::*;
import pkg_config::*;
import pkg_env::*;
 `include "uvm_macros.svh"
class ram_test extends uvm_test;
`uvm_component_utils(ram_test)

virtual ram_interface ram_vif;
//build main sequence class & env class
ram_env env; 
ram_config_obj ram_config;
reset_sequence reset_seq ;
write_only_sequence write_only_seq;
read_only_sequence read_only_seq;
write_read_sequence write_read_seq;
ram_agent agt;


//Provide the constructor default values
function new(string name="ram_test", uvm_component parent =null) ;
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);

env=ram_env::type_id::create("env",this);
ram_config= ram_config_obj::type_id::create("ram_config",this);
reset_seq= reset_sequence ::type_id::create("reset_seq",this);
write_only_seq= write_only_sequence ::type_id::create("write_only_seq",this);
read_only_seq= read_only_sequence::type_id::create("read_only_seq",this);
write_read_seq= write_read_sequence ::type_id::create("write_read_seq",this);

if(!uvm_config_db#(virtual ram_interface)::get (this,"","ram_interface",ram_config.ram_vif))
`uvm_fatal("build_phase","Unable to get virtual interface");


uvm_config_db #(ram_config_obj)::set(this,"*","CFG",ram_config);

endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
phase.raise_objection(this);
`uvm_info("run_phase","stimulus generated started",UVM_LOW); 

reset_seq.start(env.agt.sqr); 
write_only_seq.start(env.agt.sqr);
read_only_seq.start(env.agt.sqr);  
write_read_seq.start(env.agt.sqr);
 
`uvm_info("run_phase","stimulus generated ended",UVM_LOW); 
phase.drop_objection(this); 
endtask
endclass 
endpackage