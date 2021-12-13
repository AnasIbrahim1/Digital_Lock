module segDisplay(digit, toDisplay);
    input[3:0] digit;
    output reg[7:0] toDisplay;
    parameter A = 0, B = 1, C = 2, L = 3, U = 4;
    always @(digit) begin
        case (digit) 
            A: toDisplay <= 8'b00010001;
            B: toDisplay <= 8'b00000001;
            C: toDisplay <= 8'b01100011;
            L: toDisplay <= 8'b11100011;
            U: toDisplay <= 8'b10000011;
            default: toDisplay <= 8'b11111111;
        endcase
    end
endmodule
