// Code your testbench here
// or browse Examples
module tb_FIFO_Counter();

logic [7:0]data_out;
logic empty;
logic full;
logic [7:0]data;
logic wr_en;
logic rd_en;
logic clk;
logic rst_n;

FIFO_Counter f1(
     data_out,
     empty,
     full,
     data,
     wr_en,
     rd_en,
     clk,
     rst_n
);


initial begin
  clk=0;
    forever #5 clk = ~clk;
end

initial begin
  $monitor("Time:%0t\t | data:%h\t | wr_en:%b\t | rd_rn:%b\t | data_out : %d\t counter:%d\t | wr_ptr:%d\t | rd_ptr:%d | full:%b\t | empty:%b",$time,data,wr_en,rd_en,data_out,f1.counter,f1.wr_ptr,f1.rd_ptr,f1.full,f1.empty);
    rst_n = 0;
    #10;
    rst_n = 1;
    #2;
    wr_en = 1;
    data = 8'd1;#10; //1
    data = 8'd2;#10;
    data = 8'd3;#10;
    data = 8'd4;#10;
    data = 8'd5;#10;
    data = 8'd6;#10;
    data = 8'd7;#10;
    data = 8'd8;#10;
    data = 8'd9;#10;
    data = 8'd10;#10;
    data = 8'd20;#10;
    data = 8'd30;#10;
    data = 8'd40;#10;
    data = 8'd50;#10;
    data = 8'd60;#10;  // 15
    data = 8'd70;#10;
    data = 8'd80;#10;
    data = 8'd90;#10;  //18
    wr_en = 0;#10;
    rd_en = 1;#500;
  $display("data_out%h",data_out);
    $finish;

end


endmodule