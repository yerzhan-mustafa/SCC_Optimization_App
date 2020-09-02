function W_optimized = optimized_width(W_total,R_optimized,mobility)

W1_opt = mobility*W_total/(R_optimized(1)*(5+mobility*2));
W2_opt = W_total/(R_optimized(2)*(5+mobility*2));
W3_opt = W_total/(R_optimized(3)*(5+mobility*2));
W4_opt = mobility*W_total/(R_optimized(4)*(5+mobility*2));
W5_opt = W_total/(R_optimized(5)*(5+mobility*2));
W6_opt = W_total/(R_optimized(6)*(5+mobility*2));
W7_opt = W_total/(R_optimized(7)*(5+mobility*2));

W_optimized = [W1_opt;W2_opt;W3_opt;W4_opt;W5_opt;W6_opt;W7_opt];

end
