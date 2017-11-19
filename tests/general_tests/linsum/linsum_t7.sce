// Unexpected number of input arguments : 2 provided while the number of expected input arguments should be in the set [3]

kNumLeftNodes = 4;
kNumRightNodes = 4;
kCost = [82, 83, 69, 92; 77, 37, 49, 92; 11, 69, 5, 86; 8, 9, 98, 23];
[cost, assignment, status] = linsum(kNumLeftNodes, kNumRightNodes); // <---
