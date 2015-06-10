module DDS(
	clk,
	reset,
	key_s4,
	clk_25M,
	out_wave,
	choose
);

parameter WIDTH = 8;
parameter N = 16;

input [2:0] choose;
input key_s4;

reg [N-1:0] data;
input clk;
input reset;
output [WIDTH-1:0] out_wave;
reg [WIDTH-1:0] sine;
reg [WIDTH-1:0] AM;
reg [WIDTH-1:0] FM;
reg [WIDTH-1:0] ASK;
reg [WIDTH-1:0] FSK;
reg [WIDTH-1:0] out_wave;

output clk_25M;

reg [N-1:0] ADD_A;
reg [N-1:0] ADD_B;
reg [N-1:0] ADD_C;
reg [N-1:0] ADD_D;

wire [WIDTH-1:0] sine_D;
wire [WIDTH-1:0] sine_D_high;
wire [WIDTH-1:0] FM_D;
wire [WIDTH-1:0] AM_D;

wire [WIDTH-1:0] ROM_Address;
wire [WIDTH-1:0] ROM_Address_high;

assign ROM_Address = ADD_B[N-1:N-WIDTH];
assign ROM_Address_high = ADD_D[N-1:N-WIDTH];

reg clk_25M;
reg clk_4;
reg clk_3;
integer count;
integer count2;

initial
begin 
	clk_4 <= 0;
	clk_3 <= 0;
	clk_25M <= 0;
	count = 0;
	data = 16'h0080;
	count2 = 0;
	ASK <= 0;
	FSK <= 0;
end

always @ (posedge clk_4 or negedge reset)
begin
	if(!reset)
	begin
		ADD_A <= 0;
		ADD_B <= 0;
		sine <= 0;
		AM <= 0;
		FM <= 0;
	end
	else
	begin
		ADD_A <= data;
		ADD_B <= ADD_B + ADD_A;
		sine <= sine_D;
		AM <= AM_D;
		FM <= FM_D;
	end
end


sine_ROM sine_ROM_inst (
	.address ( ROM_Address ),
	.clock ( clk_4 ),
	.q ( sine_D )
);

AM_ROM AM_ROM_inst (
	.address ( ROM_Address ),
	.clock ( clk_4 ),
	.q ( AM_D )
	);

FM_ROM FM_ROM_inst (
	.address ( ROM_Address ),
	.clock ( clk_4 ),
	.q ( FM_D )
	);
	
sine_ROM sine_ROM_high_inst (
	.address ( ROM_Address_high ),
	.clock ( clk_3 ),
	.q ( sine_D_high )
	);
	
always @ (posedge clk)
begin
	if(count >= 9) 
		begin
			count <= 0;
			clk_4 <= ~clk_4; 
		end
	else count <= count+1;
end

always @ (posedge clk)
begin
	if(count2 >= 4)
		begin
			count2 <= 0;
			clk_3 <= ~clk_3; 
		end
	else count2 <= count2+1;
end

always @ (posedge clk)
	clk_25M <= ~clk_25M;
	
always @ (posedge clk_25M)
case (choose)
	3'b000:out_wave <= sine;
	3'b001:out_wave <= AM;
	3'b010:out_wave <= FM;
	3'b011:out_wave <= ASK;
	3'b100:out_wave <= FSK;
	default:out_wave <= 0;
endcase



always @ (posedge clk_3 or negedge reset)
begin
	if(!reset)
	begin
		ADD_C <= 0;
		ADD_D <= 0;
	end
	else
	begin
		ADD_C <= data;
		ADD_D <= ADD_D + ADD_C;
	end
end

always @ (posedge clk_4)
begin
	if (key_s4)
		ASK <= sine_D;
	else
		ASK <= 0;
end

always @ (posedge clk_3)
begin
	if (key_s4)
		FSK <= sine_D_high;
	else
		FSK <= sine_D;
end
	
endmodule
