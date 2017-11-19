// Number of Left Nodes should be > 0. Check input #1

kNumLeftNodes = -1;
kNumRightNodes = 4;
kCost = [82, 83, 69, 92; 77, 37, 49, 92; 11, 69, 5, 86; 8, 9, 98, 23];
[cost, assignment, status] = linsum(kNumLeftNodes, kNumRightNodes, kCost);
