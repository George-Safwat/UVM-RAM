import pkg_test::*;
import uvm_pkg::*; 
`include "uvm_macros.svh" 
module top();
bit clk,rst_n; 

initial begin
    clk=0;
    forever #1 clk=~clk;
end
//instantiations
ram_interface intf(clk);
RAM DUT(intf);
SVA assertion(intf);
bind RAM SVA binding_all(intf);

initial begin
uvm_config_db #(virtual ram_interface)::set(null,"uvm_test_top","ram_interface",intf);
$readmemb("mem.dat", DUT.MEM );//initializing memory
run_test("ram_test");
end
endmodule

