module FIFO_Counter(
    output logic [7:0]data_out,
    output logic empty,
    output logic full,
    input logic [7:0]data,
    input logic wr_en,
    input logic rd_en,
    input logic clk,
    input logic rst_n
);

logic [7:0]mem[15:0];
logic [4:0]wr_ptr;
logic [4:0]rd_ptr;
logic [4:0]counter;

always_ff@(posedge clk) begin : main_block
    if(!rst_n) begin
        // empty <= 1;
        // full <= 0;
        data_out <= 0;
        wr_ptr <= 0;
        rd_ptr <= 0;
        counter <= 0;
    end else begin


        //write logic
        if(wr_en & !full ) begin
            if(wr_ptr+1 == 5'd16) begin
                mem[wr_ptr] <= data;
                wr_ptr <= 0;
                counter <= counter + 1;
            end else begin
                mem[wr_ptr] <= data;
                counter <= counter + 1;
                wr_ptr <= wr_ptr + 1;
                // empty <= 0;
            end
        end

        //read logic 
        if(rd_en & !empty) begin
            if(rd_ptr+1 == 5'd16) begin
                data_out <= mem[rd_ptr];
                rd_ptr <= 0;
                counter <= counter - 1; 
            end else begin
                data_out <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                counter <= counter - 1; 
                // full <= 0;
            end
        end

        if(wr_en & !full & rd_en & !empty) begin
            counter <= counter;
        end
    
    
    end

end

always_comb begin
    case(counter)
    5'd16: 
    begin
        full = 1;
        empty = 0;
    end

    5'd0:
    begin
        empty = 1;
        full = 0;
    end

    default:
    begin
        full = 0;
        empty = 0;
    end

    endcase

   
end

// always_comb begin : Flag_status
//     if(counter == 4'd16) begin
//         full <= 1;
//         empty <= 0;
//     end else begin

//     end

//     if(counter == 0) begin
//         wr_ptr <= 0;
//         rd_ptr <= 0;
//         empty <= 1;
//         full<= 0;
//     end

//     // if(rd_ptr+1 == wr_ptr) begin
//     //     full <= 1;
//     // end

    

// end

endmodule






/*
so this approach is foucused on the counter method such as we will keep an counter , counting upto depth of the FIFO 
and whenever write happen we increament (+1) the counter and whenever read happen we decrements the counter 
so when counter reaches its maximum , we shall stop write
so case 1 : wr_ptr reaches top and roll over then we check if counter == max_depth if yes then stop write if no then continue to write
also if counter becomes 0 that means FIFO is empty we can make wr_ptr and rd_ptr 0 
case 2 : consider full write i.e. wr_ptr roll over to 0 and then 5 read (consiering depth of FIFO is 10) then counter value would be 5
so we can do 5 write and then counter value would be 10 so in this case write must stop 

*/