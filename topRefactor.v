module top (
);

// Reg sync signal
reg clk = 0;
// Reg Input signal
reg dat = 0;
 
always
    #5 clk = ~clk;
 
initial
    #10000
        $finish();

// Create random input signal
always @(negedge clk)
    dat = $urandom_range(0,1);
 
initial
begin 
  $dumpfile("out.vcd");
  $dumpvars(0, top);
end

wire a_out;

my_automate my_automate_i (
  .clk(clk), 
  .dat(dat), 
  .a_out(a_out)
);


endmodule

module my_automate ( 
  input wire clk,
  input wire dat,
  output wire a_out
);


assign a_out = dat_sum_out; 

wire dat_d1;
wire dat_d2;
wire dat_d3;
 
// Display input signals
wire [2:0] dat_sum = {dat_d3 & cnt3, dat_d2 & cnt3, dat_d1 & cnt3};

 
// calculating summ here
wire dat_s1 = (dat_d1 | dat_d2) & ~(dat_d1 & dat_d2);
wire dat_s2 = (dat_s1 | dat_d3) & ~(dat_s1 & dat_d3);
wire dat_sum_calc = dat_s2;
 
/// RESULTED OUTPUT SIGNAL
wire dat_sum_out; 

// Helpers
wire [0:1] dat_sum2 = {dat_sum_out};
wire I = {dat};
 
// Kind of "SHIFT register" on D-triggers
DTRIG dt1 (
    .D(dat),
    .C(clk),
    .Q(dat_d1),
    .NQ()
);
 
DTRIG dt2 (
    .D(dat_d1),
    .C(clk),
    .Q(dat_d2),
    .NQ()
);
 
DTRIG dt3 (
    .D(dat_d2),
    .C(clk),
    .Q(dat_d3),
    .NQ()
);
// end of shift register

// single impulse every 3 takts
wire cnt3;

// output trigger
DTRIG out (
    .D(dat_sum_calc),
    .C(~clk & cnt3),
    .Q(dat_sum_out),
    .NQ()
);

 
CNT3 c3 (
    .C(clk),
    .OUT(cnt3)
);
 
endmodule
 
 
// 3 takt impulse generator
module CNT3 (
    input wire C,
    output wire OUT
);
 
wire c1;
wire c2;
wire c3;
 
assign OUT = (c1 & c2 & c3) | ~(c1 | c2 | c3);
 
DTRIG trig1 (
    .D(~c3),
    .C(C),
    .Q(c1),
    .NQ()
);
 
DTRIG trig2 (
    .D(c1),
    .C(C),
    .Q(c2),
    .NQ()
);
 
DTRIG trig3 (
    .D(c2),
    .C(C),
    .Q(c3),
    .NQ()
);
 
 
endmodule
 
 
/// D-TRIGGER model
module DTRIG (
    input wire D,
    input wire C,
    output wire Q,
    output wire NQ
);
 
reg Qr = 0;
assign Q = Qr;
assign NQ = ~Q;
 
always @(posedge C)
    Qr <= D;
 
endmodule