module SVA(ram_interface.sva intf);
property p1;
@(posedge intf.clk) (!intf.rst_n) |=> ( intf.tx_valid==1'b0 && intf.dout==8'b0);//Scheduling semantics
endproperty
Assert_reset: assert property(p1);
cover_reset:cover property(p1);


property p2;
@(posedge intf.clk) disable iff(!intf.rst_n) (intf.din[9:8]==2'b00 || intf.din[9:8]==2'b01 || intf.din[9:8]==2'b10) |=> (intf.tx_valid==0);
endproperty
Assert_tx_valid: assert property(p2);
cover_tx_valid:cover property(p2);

property p3;
@(posedge intf.clk) disable iff(!intf.rst_n) (intf.din[9:8]==2'b11) |=> (intf.tx_valid==1) |=> (intf.din[9:8]==2'b00||intf.din[9:8]==2'b10) |=> (intf.tx_valid==0) ;
endproperty
Assert_tx_valid_fell: assert property(p3);
cover_tx_valid_fell:cover property(p3);

property p4;//we did [=1:$] because 2'b00 can come more than one time consecutively
@(posedge intf.clk) disable iff(!intf.rst_n)  (intf.din[9:8]==2'b00) [=1:$] ##1 (intf.din[9:8]==2'b01);
endproperty
Assert_wr_add_to_wr_data: assert property(p4);
cover_wr_add_to_wr_data:cover property(p4);

property p5;//we did [=1:$] because 2'b10 can come more than one time consecutively
@(posedge intf.clk) disable iff(!intf.rst_n)  (intf.din[9:8]==2'b10) [=1:$] ##1  (intf.din[9:8]==2'b11);
endproperty
Assert_rd_add_to_rd_data: assert property(p5);
cover_rd_add_to_rd_data:cover property(p5);

endmodule