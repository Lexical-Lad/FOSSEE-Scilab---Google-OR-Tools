mode(1)
//
// Demo of linsum.sci
//

//Ref :
//http://www.hungarianalgorithm.com/examplehungarianalgorithm.php
halt()   // Press return to continue
 
kNumLeftNodes = 4;
kNumRightNodes = 4;
kCost = [82, 83, 69, 92; 77, 37, 49, 92; 11, 69, 5, 86; 8, 9, 98, 23];
[cost, assignment, status] = linsum(kNumLeftNodes, kNumRightNodes, kCost);
cost
assignment
status
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
