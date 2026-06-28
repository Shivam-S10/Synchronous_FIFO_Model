`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2026 22:00:02
// Design Name: 
// Module Name: FIFO
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module FIFO #(
parameter Data_width=8,
parameter Depth=16,
parameter Address_width = $clog2(Depth)
)(
    input clk,
    input rst,
    input write_en,
    input read_en,
    input [Data_width-1:0] data_in,
    output reg [Data_width-1:0] data_out,
    output wire full,
    output wire empty
    );
    // Internal file memory
    reg [Data_width-1:0] fifo_mem [0:Depth-1];
    reg [Address_width-1:0] write_ptr;
    reg [Address_width-1:0] read_ptr;
    reg [Address_width:0]   count;
    
    assign empty =(count==0);
    assign full = (count==Depth);
    
    always @(clk) begin //write part 
    if (rst) write_ptr<=0 ;
    else if( write_en && !full) begin
    fifo_mem[write_ptr]<= data_in;
    write_ptr<=write_ptr+1;
    end
    end
    
    always @(clk) begin //read part 
    if(rst) begin
    read_ptr<=0;
    data_out<=0;
    end
    else if (read_en && !empty) begin
    data_out<=fifo_mem[read_ptr];
    read_ptr<=read_ptr+1;
    end
    end
    
    always @(clk) begin // handle counter
    if(rst) count<=0;
    else begin
    case ({write_en && !full, read_en && !empty})
    2'b10: count <= count + 1;         
    2'b01: count <= count - 1;         
    2'b11: count <= count;             
    default: count <= count; 
    endcase
    end  
    end
endmodule
