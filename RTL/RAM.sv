module RAM (ram_interface.DUT intf);

reg [7:0] MEM [255:0];
reg [7:0] Rd_Addr, Wr_Addr;

always @(posedge intf.clk) begin
    if (!intf.rst_n) begin
        intf.dout <= 0;
        intf.tx_valid <= 0;
        Rd_Addr <= 0;
        Wr_Addr <= 0;
    end
    else  begin  //put begin & end                                    
        if (intf.rx_valid) begin
            case (intf.din[9:8])
                2'b00 : Wr_Addr <= intf.din[7:0];
                2'b01 : MEM[Wr_Addr] <= intf.din[7:0];
                2'b10 : Rd_Addr <= intf.din[7:0];
                2'b11 : intf.dout <= MEM[Rd_Addr]; //bug MEM[Rd_Addr] instead of MEM[Wr_Addr]
                default : intf.dout <= 0;
            endcase
        end
        intf.tx_valid <= (intf.din[9] && intf.din[8])? 1'b1 : 1'b0;  //Deleting dependancy on rx_valid 
    end
end       

endmodule