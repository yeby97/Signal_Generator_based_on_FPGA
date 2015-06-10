`timescale 1 ps/ 1 ps
module DDS_vlg_tst();

reg [2:0] choose;
reg clk;
reg key_s4;
reg reset;
// wires                                               
wire clk_25M;
wire [7:0]  out_wave;

// assign statements (if any)                          
DDS i1 (
// port map - connection between master ports and signals/registers   
	.choose(choose),
	.clk(clk),
	.clk_25M(clk_25M),
	.key_s4(key_s4),
	.out_wave(out_wave),
	.reset(reset)
);
initial                                                
begin                                                  
	reset = 0;
	clk = 0;
	#20 reset = 1;   
	choose = 3'b100;
	key_s4 = 0;
end 
                                                   
always #2 clk = ~clk;

always #64000 key_s4 = ~key_s4;
endmodule
