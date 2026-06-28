`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2026 20:00:19
// Design Name: 
// Module Name: fifo_tb
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
module FIFO_tb;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter DEPTH      = 16;

    // Inputs to DUT 
    reg clk;
    reg rst;
    reg write_en;
    reg read_en;
    reg [DATA_WIDTH-1:0] data_in;

    // Outputs from DUT
    wire [DATA_WIDTH-1:0] data_out;
    wire                  full;
    wire                  empty;

    // Reference Model Implementation
    reg [DATA_WIDTH-1:0] ref_model [0:DEPTH-1];
    integer wr_ptr_ref = 0;
    integer rd_ptr_ref = 0;
    integer count_ref  = 0;
    reg [DATA_WIDTH-1:0] expected_data;

    // Instantiate the Device Under Test
    FIFO #(DATA_WIDTH, DEPTH) dut (
        .clk(clk),
        .rst(rst),
        .write_en(write_en),
        .read_en(read_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock Generation
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        write_en = 0;
        read_en = 0;
        data_in = 0;
        #20 rst = 0;
        repeat (DEPTH) begin
            @(posedge clk);
            if (!full) begin
                write_en <= 1;
                data_in <= $random % 256;
                ref_model[wr_ptr_ref] <= data_in;
                wr_ptr_ref <= (wr_ptr_ref + 1) % DEPTH;
                count_ref <= count_ref + 1;
            end
        end
        @(posedge clk) write_en <= 0;
        repeat (DEPTH) begin
            @(posedge clk);
            if (!empty) begin
                read_en <= 1;
            end
            @(posedge clk);
            read_en <= 0;
            expected_data <= ref_model[rd_ptr_ref];
            if (data_out !== expected_data) begin
                $stop;
            end else begin                
            end
            rd_ptr_ref <= (rd_ptr_ref + 1) % DEPTH;
            count_ref <= count_ref - 1;
        end

       
        $finish;
    end

endmodule
