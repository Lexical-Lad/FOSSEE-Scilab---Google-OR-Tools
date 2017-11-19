// Expected size [4 4] for input argument kCost at input #3, but got [4 3] instead

kNumLeftNodes = 4;
kNumRightNodes = 4;
kCost = [82, 83, 69; 77, 37, 49; 11, 69, 5; 8, 9, 98];
[cost, assignment, status] = linsum(kNumLeftNodes, kNumRightNodes, kCost);
