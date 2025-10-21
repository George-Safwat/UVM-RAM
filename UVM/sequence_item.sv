package seq_item_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;

class ram_seq_item extends uvm_sequence_item;
`uvm_object_utils(ram_seq_item) 
rand bit rst_n,rx_valid;
rand bit [9:0] din;
bit tx_valid;
logic [7:0] dout;
bit [1:0] prev_din;

function new(string name="ram_seq_item");
super.new(name);
endfunction

function string convert2string();
return $sformatf("%s din=0b%b, rx_valid=0b%b ,rst_n= 0b%b, tx_valid= 0b%b ,dout= 0b%b", 
super.convert2string(),din ,rx_valid ,rst_n , tx_valid  , dout);
endfunction

function string convert2string_stimulus();
return $sformatf("%s din=0b%b, rx_valid=0b%b ,rst_n= 0b%b, tx_valid= 0b%b ,dout= 0b%b", 
super.convert2string(),din ,rx_valid ,rst_n , tx_valid  , dout);
endfunction

//CONSTRAINTS

constraint ram{
    rst_n dist{1:/95, 0:/5};
    rx_valid dist{1:/95, 0:/5};

}

constraint write_only{
    (prev_din==2'b00)->{din[9:8] dist{2'b00:/30, 2'b01:/70};}
    (prev_din==2'b01)->{din[9:8] dist{2'b01:/30, 2'b00:/70};}
}

constraint read_only{
    (prev_din==2'b10)->{din[9:8]==2'b11};
    (prev_din==2'b11)->{din[9:8]==2'b10};
}

constraint mix_read_write{
   (prev_din==2'b00) -> {din[9:8] dist{2'b00:/50, 2'b01:/50};}
     //After a Write Data  60% → Read Address & 40% → Write Address
    (prev_din==2'b01) -> {din[9:8] dist{2'b10:/60, 2'b00:/40};}
    //Read address
    (prev_din==2'b10) -> {din[9:8] == 2'b11};
    //After a Read Data  60% → Write Address & 40% → Read Address  
    (prev_din==2'b11) -> {din[9:8] dist{2'b00:/60, 2'b10:/40};}
}
function void post_randomize();
prev_din=din[9:8];//To check the prev_din with the din now in constraints
endfunction

endclass
endpackage


