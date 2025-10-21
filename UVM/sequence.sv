package seq_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*; 
import seq_item_pkg::*;

class reset_sequence extends uvm_sequence #(ram_seq_item);
`uvm_object_utils(reset_sequence)

ram_seq_item seq_item;

function new(string name="reset_sequence");
super.new(name);
endfunction

//Reset
task body();
seq_item=ram_seq_item::type_id::create("seq_item");//put the object created in factory 
$display("START OF RESET");
start_item(seq_item);

seq_item.din=0;
seq_item.rx_valid=0;
seq_item.rst_n=0;
finish_item(seq_item);
#1 $display("END OF RESET");
endtask
endclass

//WRITE ONLY
class write_only_sequence extends uvm_sequence #(ram_seq_item);
`uvm_object_utils(write_only_sequence)

ram_seq_item seq_item;

function new(string name="write_only_sequence");
super.new(name);
endfunction

task body();
seq_item=ram_seq_item::type_id::create("seq_item");//put the object created in factory 
seq_item.read_only.constraint_mode(0);
seq_item.write_only.constraint_mode(1);
seq_item.mix_read_write.constraint_mode(0);
$display("START OF WRITE ONLY");
repeat(10000) begin
start_item(seq_item);

assert(seq_item.randomize());

finish_item(seq_item);
end
$display("END OF WRITE ONLY");
endtask
endclass


//READ ONLY
class read_only_sequence extends uvm_sequence #(ram_seq_item);
`uvm_object_utils(read_only_sequence)

ram_seq_item seq_item;

function new(string name="read_only_sequence");
super.new(name);
endfunction

task body();
seq_item=ram_seq_item::type_id::create("seq_item");//put the object created in factory 
seq_item.read_only.constraint_mode(1);
seq_item.write_only.constraint_mode(0);
seq_item.mix_read_write.constraint_mode(0);
$display("START OF READ ONLY");
repeat(10000) begin
start_item(seq_item);

assert(seq_item.randomize());


finish_item(seq_item);
end
$display("END OF READ ONLY");
endtask
endclass

//WRITE & READ
class write_read_sequence extends uvm_sequence #(ram_seq_item);
`uvm_object_utils(write_read_sequence)

ram_seq_item seq_item;

function new(string name="write_read_sequence");
super.new(name);
endfunction

task body();
seq_item=ram_seq_item::type_id::create("seq_item");//put the object created in factory 
seq_item.read_only.constraint_mode(0);
seq_item.write_only.constraint_mode(0);
seq_item.mix_read_write.constraint_mode(1);
$display("START OF WRITE & READ");
repeat(10000) begin

start_item(seq_item);

assert(seq_item.randomize());

finish_item(seq_item);
end
$display("END OF WRITE & READ");
endtask


endclass
endpackage