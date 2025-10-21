interface ram_interface (clk);
//INPUTS
input bit clk;
bit rst_n, rx_valid;
bit [9:0] din;
//OUTPUTS
bit tx_valid; //Should be high if we want to read
logic [7:0] dout;

modport DUT( input clk, din, rst_n, rx_valid,  output tx_valid,  dout);
modport sva(input clk, din, rst_n, rx_valid,  tx_valid,  dout);
endinterface