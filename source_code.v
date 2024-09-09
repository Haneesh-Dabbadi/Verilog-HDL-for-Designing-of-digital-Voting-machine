module voting_machine #(
    parameter idle = 2'b00, vote = 2'b01, hold = 2'b10, finish = 2'b11
)(
    input clk, rst, i_candidate_1, i_candidate_2, i_candidate_3, i_voting_over,
    output reg [31:0] o_count1, o_count2, o_count3
);

    reg [31:0] r_cand1_prev, r_cand2_prev, r_cand3_prev;
    reg [31:0] r_counter_1, r_counter_2, r_counter_3;
    reg [1:0] r_present_state, r_next_state;
    reg [3:0] r_hold_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            r_present_state <= idle;
            o_count1 <= 0;
            o_count2 <= 0;
            o_count3 <= 0;
            r_hold_count <= 0;
        end else begin
            r_present_state <= r_next_state;
        end
    end

    always @(posedge clk or negedge rst) begin
        case (r_present_state)
            idle: begin
                r_counter_1 <= 0;
                r_counter_2 <= 0;
                r_counter_3 <= 0;
                r_hold_count <= 0;
                if (!rst) 
                    r_next_state <= vote;
                else 
                    r_next_state <= idle;
            end
            vote: begin
                if (i_voting_over) 
                    r_next_state <= finish;
                else if (i_candidate_1 == 0 && r_cand1_prev) begin
                    r_counter_1 <= r_counter_1 + 1;
                    r_next_state <= hold;
                end else if (i_candidate_2 == 0 && r_cand2_prev) begin
                    r_counter_2 <= r_counter_2 + 1;
                    r_next_state <= hold;
                end else if (i_candidate_3 == 0 && r_cand3_prev) begin
                    r_counter_3 <= r_counter_3 + 1;
                    r_next_state <= hold;
                end else 
                    r_next_state <= vote;
            end
            hold: begin
                if (i_voting_over) 
                    r_next_state <= finish;
                else if (r_hold_count != 4'b1111) 
                    r_hold_count <= r_hold_count + 1;
                else 
                    r_next_state <= vote;
            end
            finish: begin
                if (!i_voting_over) 
                    r_next_state <= idle;
                else 
                    r_next_state <= finish;
            end
            default: begin
                r_counter_1 <= 0;
                r_counter_2 <= 0;
                r_counter_3 <= 0;
                r_hold_count <= 0;
                r_next_state <= idle;
            end
        endcase
    end

    always @(posedge clk or negedge rst) begin
        if (rst) begin
            o_count1 <= r_counter_1;
            o_count2 <= r_counter_2;
            o_count3 <= r_counter_3;
        end else begin
            r_cand1_prev <= i_candidate_1;
            r_cand2_prev <= i_candidate_2;
            r_cand3_prev <= i_candidate_3;
        end
    end
endmodule
