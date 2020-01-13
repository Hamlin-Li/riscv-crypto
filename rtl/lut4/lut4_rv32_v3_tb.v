
module lut4_rv32_v3_tb ();

reg clk     ;
reg resetn  ;

integer ticks;

//
// DUT interface variables.
reg  [31:0] rs1;
reg  [31:0] rs2;
reg         hi ;
wire [31:0] rd_dut;

// Golden reference
reg  [31:0] rd_ref;

// Calculate the lut in the testbench too.
wire [3:0] lut [7:0];

genvar i;
generate for(i = 0; i < 8; i = i + 1) begin
    assign lut[i] = rs2[4*i+:4];
end endgenerate

//
// Clock / reset wavedumping
initial begin
    clk     = 1'b0;
    resetn  = 1'b0;
    ticks   = 0;
    
    $dumpfile(``WAVEFILE);
    $dumpvars(0,lut4_rv32_v3_tb);
end

initial #50 resetn = 1'b1;

always @(clk) #10 clk <= !clk;


//
// Compute expected result.
always @(*) begin
    rd_ref[4*0+:4] = hi ^ rs1[4*0+3] ? 4'b0000 : lut[rs1[4*0+:3]];
    rd_ref[4*1+:4] = hi ^ rs1[4*1+3] ? 4'b0000 : lut[rs1[4*1+:3]];
    rd_ref[4*2+:4] = hi ^ rs1[4*2+3] ? 4'b0000 : lut[rs1[4*2+:3]];
    rd_ref[4*3+:4] = hi ^ rs1[4*3+3] ? 4'b0000 : lut[rs1[4*3+:3]];
    rd_ref[4*4+:4] = hi ^ rs1[4*4+3] ? 4'b0000 : lut[rs1[4*4+:3]];
    rd_ref[4*5+:4] = hi ^ rs1[4*5+3] ? 4'b0000 : lut[rs1[4*5+:3]];
    rd_ref[4*6+:4] = hi ^ rs1[4*6+3] ? 4'b0000 : lut[rs1[4*6+:3]];
    rd_ref[4*7+:4] = hi ^ rs1[4*7+3] ? 4'b0000 : lut[rs1[4*7+:3]];
end

//
// Check expected result.
always @(posedge clk) if(resetn) begin

    if(rd_ref !== rd_dut) begin
        $display("RS1=%h, RS2=%h, HI=%d, expect %h, got %h",rs1,rs2,hi,rd_ref,rd_dut);
        $display("ERROR");
        $finish(1);
    end

end

//
// New input stimulus / simulation finish.
always @(posedge clk) begin
    
    rs1 <= $random();
    rs2 <= $random();
    hi  <= $random() & 32'b1;

    ticks = ticks + 1;
    if(ticks >= 100) begin
        $display("PASS");
        $finish(0);
    end
end


lut4_rv32_v3 i_lut_rv32_v3 (
.rs1(rs1    ),
.rs2(rs2    ),
.hi (hi     ),
.rd (rd_dut ) 
);

endmodule

