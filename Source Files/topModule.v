module topModule(clk, rst, buttons, enable, toDisplay);
    input clk, rst;
    input[3:0] buttons;
    output[3:0] enable;
    output[7:0] toDisplay;
    parameter A = 0, B = 1, C = 2, L = 3, U = 4, OFF = 5; // No D state
    reg[2:0] state;
    wire[3:0] debOut, detOut;
    genvar i;
    generate for (i = 0; i < 4; i = i + 1) begin: block1
        debAndSynch deb(clk, rst, buttons[i], debOut[i]);
        risingDet det(clk, rst, debOut[i], detOut[i]);
    end endgenerate
    reg[3:0] digit[3:0];
    integer j;
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            for (j = 0; j < 4; j = j + 1) digit[j] <= L;
            state <= L;
        end
        else begin
            if (detOut != 0) begin
                case (state) 
                    L: begin
                        if (detOut == 4'b1000) begin
                            digit[3] <= A;
                            for (j = 0; j < 3; j = j + 1) digit[j] <= OFF;
                            state <= A;
                        end
                    end
                    A: begin
                       if (detOut == 4'b0100) begin
                            digit[2] <= B;
                            state <= B;
                       end 
                       else begin
                            for (j = 0; j < 4; j = j + 1) digit[j] <= L;
                            state <= L;
                       end
                    end
                    B: begin                                            
                       if (detOut == 4'b0010) begin                     
                            digit[1] <= C;                              
                            state <= C;                                 
                       end                                              
                       else begin                                       
                            for (j = 0; j < 4; j = j + 1) digit[j] <= L;
                            state <= L;                                 
                       end                                     
                    end
                    C: begin                                            
                       if (detOut == 4'b0001) begin                     
                            for (j = 0; j < 4; j = j + 1) digit[j] <= U;
                            state <= U;
                       end                                              
                       else begin                                       
                            for (j = 0; j < 4; j = j + 1) digit[j] <= L;
                            state <= L;                                 
                       end                                              
                    end
                    U: begin
                       if (detOut == 4'b1000) begin                           
                            digit[3] <= A;                                     
                            for (j = 0; j < 3; j = j + 1) digit[j] <= OFF;     
                            state <= A;                                        
                       end
                       else begin
                            for (j = 0; j < 4; j = j + 1) digit[j] <= L;
                            state <= L;
                       end
                    end                                                                                                                                          
                endcase
            end
        end
    end
    wire[7:0] toFPGA[3:0];
    generate for (i = 0; i < 4; i = i + 1) begin: block2
        segDisplay display(digit[i], toFPGA[i]);
    end endgenerate
    digitSwitcher switcher(clk, rst, toFPGA[0], toFPGA[1], toFPGA[2], toFPGA[3], toDisplay, enable);
endmodule