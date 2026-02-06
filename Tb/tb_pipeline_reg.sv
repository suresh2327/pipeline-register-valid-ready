module tb_pipeline_reg;

    parameter DATA_WIDTH=32;

    logic clk;
    logic rst_n;

    logic in_valid;
    logic in_ready;
    logic [DATA_WIDTH-1:0] in_data;

    logic out_valid;
    logic out_ready;
    logic [DATA_WIDTH-1:0] out_data;

    pipeline_reg #(
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .in_valid(in_valid),
        .in_ready(in_ready),
        .in_data(in_data),
        .out_valid(out_valid),
        .out_ready(out_ready),
        .out_data(out_data)
    );

    always #5 clk=~clk;

    initial begin
        clk=0;
        rst_n=0;
        in_valid=0;
        in_data=0;
        out_ready=0;

        #20;
        rst_n=1;

        // Case 1: Normal transfer
        @(posedge clk);
        in_valid=1;
        in_data=32'hA5A5A5A5;
        out_ready=1;

        @(posedge clk);
        in_valid=0;

        // Case 2: Backpressure (out_ready low)
        @(posedge clk);
        in_valid=1;
        in_data=32'h12345678;
        out_ready=0;

        repeat(3) @(posedge clk);

        out_ready=1;

        @(posedge clk);
        in_valid=0;

        // Case 3: Continuous transfers
        repeat(3) begin
            @(posedge clk);
            in_valid=1;
            in_data=in_data+1;
        end

        @(posedge clk);
        in_valid=0;

        #50;
        $finish;
    end

    initial begin
        $monitor("T=%0t | in_valid=%b in_ready=%b in_data=%h | out_valid=%b out_ready=%b out_data=%h",
                 $time,in_valid,in_ready,in_data,out_valid,out_ready,out_data);
    end

endmodule
