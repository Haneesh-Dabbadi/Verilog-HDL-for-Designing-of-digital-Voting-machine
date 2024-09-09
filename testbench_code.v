`timescale 1ns/1ns
module tb_voting_machine();

    reg t_clk, t_rst, t_candidate_1, t_candidate_2, t_candidate_3, t_vote_over;
    wire [31:0] t_result_1, t_result_2, t_result_3;

    // Instantiate the unit under test (UUT)
    voting_machine uut (
        .clk(t_clk), .rst(t_rst),
        .i_candidate_1(t_candidate_1), .i_candidate_2(t_candidate_2), .i_candidate_3(t_candidate_3),
        .i_voting_over(t_vote_over),
        .o_count1(t_result_1), .o_count2(t_result_2), .o_count3(t_result_3)
    );

    // Initialize clock
    initial t_clk = 1'b1;
    always #5 t_clk = ~t_clk;

    // Stimulus to the design
    initial begin
        $monitor("time=%d rst=%b candidate_1=%b candidate_2=%b candidate_3=%b vote_over=%b result_1=%3d result_2=%3d result_3=%3d",
                  $time, t_rst, t_candidate_1, t_candidate_2, t_candidate_3, t_vote_over, t_result_1, t_result_2, t_result_3);
        // Initialize inputs
        t_rst = 1'b1; 
        t_candidate_1 = 1'b0; 
        t_candidate_2 = 1'b0; 
        t_candidate_3 = 1'b0; 
        t_vote_over = 1'b0;
        
        #20 t_rst = 1'b0;
        
        #10 t_candidate_1 = 1'b1; 
        #10 t_candidate_1 = 1'b0; // Vote for candidate 1
        
        #20 t_candidate_2 = 1'b1; 
        #10 t_candidate_2 = 1'b0; // Vote for candidate 2
        
        #20 t_candidate_1 = 1'b1; 
        #10 t_candidate_1 = 1'b0; // Vote for candidate 1
        
        #20 t_candidate_3 = 1'b1; 
        #10 t_candidate_3 = 1'b0; // Vote for candidate 3
        
        #20 t_candidate_2 = 1'b1; 
        #10 t_candidate_2 = 1'b0; // Vote for candidate 2
        
        #20 t_candidate_2 = 1'b1; 
        #10 t_candidate_2 = 1'b0; // Vote for candidate 2
        
        #20 t_candidate_1 = 1'b1; 
        #10 t_candidate_1 = 1'b0; // Vote for candidate 1
        
        #20 t_candidate_3 = 1'b1; 
        #10 t_candidate_3 = 1'b0; // Vote for candidate 3
        
        #30 t_vote_over = 1'b1;   // End of voting
        
        #50 t_rst = 1'b1;         // Reset
        
        #60 $stop;                // Stop simulation
    end

    // Generate .vcd file for waveform plotting
    initial begin
        $dumpfile("voting_dumpfile.vcd");
        $dumpvars(0, tb_voting_machine);
    end
endmodule
