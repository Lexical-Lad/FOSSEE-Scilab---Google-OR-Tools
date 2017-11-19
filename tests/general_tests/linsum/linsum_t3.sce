// Number of Left Nodes should be EQUAL to Number of Right Nodes

kNumLeftNodes = 4;
kNumRightNodes = 5;
kCost = [82, 83, 69, 92, 0; 77, 37, 49, 92, 0; 11, 69, 5, 86, 0; 8, 9, 98, 23, 0];
[cost, assignment, status] = linsum(kNumLeftNodes, kNumRightNodes, kCost);
