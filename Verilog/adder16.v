module cladder4(output [3:0] S, output Cout,PG,GG, input [3:0] A,B, input Cin);
  wire [3:0] G,P,C;

  assign G = A & B; //Generate
  assign P = A ^ B; //Propagate
  assign C[0] = Cin;
  assign C[1] = G[0] | (P[0]&C[0]);
  assign C[2] = G[1] | (P[1]&G[0]) | (P[1]&P[0]&C[0]);
  assign C[3] = G[2] | (P[2]&G[1]) | (P[2]&P[1]&G[0]) | (P[2]&P[1]&P[0]&C[0]);
  assign Cout = G[3] | (P[3]&G[2]) | (P[3]&P[2]&G[1]) | (P[3]&P[2]&P[1]&G[0]) |(P[3]&P[2]&P[1]&P[0]&C[0]);
  assign S = P ^ C;
  assign PG = P[3] & P[2] & P[1] & P[0];
  assign GG = G[3] | (P[3]&G[2]) | (P[3]&P[2]&G[1]) | (P[3]&P[2]&P[1]&G[0]);
endmodule

module adder16(
  output [15:0] S,
  output Cout,
  input [15:0] A,
  input [15:0] B,
  input Cin
);
  wire C1, C2, C3, C4;
  wire PG1, PG2, PG3, PG4;
  wire GG1, GG2, GG3, GG4;
  wire [3:0] S1, S2, S3, S4;

  cladder4 DUT0 (S1, C1, PG1, GG1, A[3:0], B[3:0], Cin);
  cladder4 DUT1 (S2, C2, PG2, GG2, A[7:4], B[7:4], C1);
  cladder4 DUT2 (S3, C3, PG3, GG3, A[11:8], B[11:8], C2);
  cladder4 DUT3 (S4, C4, PG4, GG4, A[15:12], B[15:12], C3);

  assign S = {S4, S3, S2, S1};
  assign Cout = DUT3.Cout;
endmodule

module main;
  reg signed [15:0] a;
  reg signed [15:0] b;
  wire signed [15:0] sum;
  wire c_out;

  adder16 DUT(sum, c_out, a, b, 1'b0);

  initial
  begin
    a = 5;
    b = -3;
    $monitor("%dns monitor: a=%d b=%d sum=%d", $stime, a, b, sum);
  end
endmodule
