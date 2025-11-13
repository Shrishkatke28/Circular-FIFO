module FIFO(
    output reg [7:0]seg,
    output reg[3:0]an,
    input [7:0]data_in,
    input wr_en,rd_en,
    input clk,rst
);

reg[7:0]data_out;
reg [7:0]mem[0:7];
reg [3:0]wr_ptr,rd_ptr;
reg empty,full;
always@(posedge clk or posedge rst)begin

    if(rst)begin
        data_out<=0;
        full<=0;
        empty<=1;
        wr_ptr<=0;
        rd_ptr<=0;
    end else begin

        //write logic
        if(wr_en && !full)begin
            if(wr_ptr == 4'b1000)begin
                wr_ptr<=0;
                // full<=1;
            end else begin
                if(wr_ptr+1 == rd_ptr)begin
                    full<=1;
                end else begin
                    mem[wr_ptr]<=data_in;
                    wr_ptr<=wr_ptr+1;
                    // empty<=1;
                end

            end
        end

        //read logic
        if(rd_en && empty)begin
            if(rd_ptr == 4'b1000)begin
                rd_ptr<=0;
                // empty<=0;
            end else begin
                if(rd_ptr-wr_ptr == 1)begin
                    full<=0;
                end else begin
                    data_out<=mem[rd_ptr];
                    rd_ptr<=rd_ptr+1;
                    full<=0;
                end

            end

        end



    end

end

endmodule


module tb_circular_fifo();

    wire [7:0]seg;
    wire[3:0]an;
    reg [7:0]data_in;
    reg wr_en,rd_en;
    reg clk,rst;

    FIFO f1(seg,an,data_in,wr_en,rd_en,clk,rst);

    initial begin
        clk=1;
        forever #5 clk=~clk;
    end

    initial begin
        $monitor("Time:%0t\t | wr_en:%b\t | rd_en:%b\t | input:%d\t | wr_ptr:%d\t | rd_ptr:%d\t | output:%d\t ",$time,wr_en,rd_en,data_in,f1.wr_ptr,f1.rd_ptr,f1.data_out);

        rst=1;
        #10;
        rst=0;

        #2;
        wr_en=1;
        data_in=8'd1;#10;
        data_in=8'd2;#10;
        data_in=8'd3;#10;
        data_in=8'd4;#10;
        data_in=8'd5;#10;
        data_in=8'd6;#10;
        data_in=8'd7;#10;
        data_in=8'd8;#10;

        wr_en=0;#10;
        rd_en=1;
        #90;
        rd_en=0;#10;
        wr_en=1;#10;
        data_in=8'd9;#10;
        data_in=8'd10;#10;
        wr_en=0;#10;
        rd_en=1;#50;

        #300;
        $finish;

    end


endmodule