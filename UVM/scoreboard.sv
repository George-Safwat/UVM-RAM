package scoreboard_pkg;
`include "uvm_macros.svh" 
import uvm_pkg::*;
import seq_item_pkg::*;
import seq_pkg::*;
class ram_scoreboard extends uvm_scoreboard;
`uvm_component_utils(ram_scoreboard)

uvm_analysis_export #(ram_seq_item) sb_export;
uvm_tlm_analysis_fifo #(ram_seq_item) sb_fifo;
ram_seq_item seq_item_sb;

int error_count=0; 
int correct_count=0;
logic tx_valid_ref;
logic [7:0] dout_ref; 

reg [7:0] MEM [255:0];
reg [7:0] Rd_Addr, Wr_Addr;

function new(string name="ram_scoreboard",uvm_component parent=null);
super.new(name,parent);
endfunction

//BUILD ANALYSIS EXPORT AND FIFO
function void build_phase(uvm_phase phase);
super.build_phase(phase);
sb_export=new("sb_export",this);
sb_fifo=new("sb_fifo",this);
endfunction

//CONNECT ANALYSIS EXPORT
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
sb_export.connect(sb_fifo.analysis_export);//Connecting fifo with scoreboard
endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
sb_fifo.get(seq_item_sb);
ref_model(seq_item_sb);
if((seq_item_sb.dout!=dout_ref)&&(seq_item_sb.tx_valid!=tx_valid_ref))begin
     `uvm_error("run_phase",$sformatf("comparison failed,transaction recieved by the DUT:%s",seq_item_sb.convert2string()));      
                    error_count++; 
                end 
                else begin 
 `uvm_info("run_phase",$sformatf("correct out_refput:%s ",seq_item_sb.convert2string()),UVM_LOW);      
                     correct_count++;  
                end 
            end 

endtask


task ref_model(ram_seq_item seq_item_chk);
if (!seq_item_chk.rst_n) begin
        dout_ref = 0;
        tx_valid_ref = 0;
        Rd_Addr = 0;
        Wr_Addr = 0;
    end
    else begin                                          
        if (seq_item_chk.rx_valid) begin
            if (seq_item_chk.din[9:8]== 2'b00)
                Wr_Addr = seq_item_chk.din[7:0];
            else if (seq_item_chk.din[9:8]== 2'b01)
                MEM[Wr_Addr] = seq_item_chk.din[7:0];
            else if (seq_item_chk.din[9:8]== 2'b10)
                Rd_Addr = seq_item_chk.din[7:0];
            else if (seq_item_chk.din[9:8]== 2'b11)
                dout_ref = MEM[Wr_Addr];
            else dout_ref = 0;
        end
        tx_valid_ref = (seq_item_chk.din[9] && seq_item_chk.din[8])? 1'b1 : 1'b0;
    end
endtask

 function void report_phase (uvm_phase phase); 
        super.report_phase(phase); 
        `uvm_info("report_phase",$sformatf("Total successful counts:%0d",correct_count),UVM_MEDIUM);      
        `uvm_info("report_phase",$sformatf("Total failed counts:%0d",error_count),UVM_MEDIUM);      
    endfunction 
endclass
endpackage