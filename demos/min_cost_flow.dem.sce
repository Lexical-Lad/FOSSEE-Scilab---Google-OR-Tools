mode(1)
//
// Demo of min_cost_flow.sci
//

//Ref : Example 2 :
//http://www.yourarticlelibrary.com/ergonomics/operation-research/checking-for-optimality-transportation-problem/34743/
halt()   // Press return to continue
 
// Before balancing (Infeasible):
//    kNumSources = 4;
//    kNumTargets = 4;
//    kCost = [4, 6, 8, 13; 13, 11, 10, 8; 14, 4, 10, 13; 9, 11, 13, 8];
//    kCapacity = [200, 200, 200, 200; 200, 200, 200, 200; 200, 200, 200, 200; 200, 200, 200, 200];
//    kSupply = [50, 70, 30, 50];
//    kDemand = [25, 35, 105, 20];
//    [cost, flow, status] = min_cost_flow(kNumSources, kNumTargets, kCost, kCapacity, kSupply, kDemand);
halt()   // Press return to continue
 
// After balancing (Optimal):
kNumSources = 4;
kNumTargets = 5;
kCost = [4, 6, 8, 13, 0; 13, 11, 10, 8, 0; 14, 4, 10, 13, 0; 9, 11, 13, 8, 0];
kCapacity = [200, 200, 200, 200, 200; 200, 200, 200, 200, 200; 200, 200, 200, 200, 200; 200, 200, 200, 200, 200];
kSupply = [50, 70, 30, 50];
kDemand = [25, 35, 105, 20, 15];
[cost, flow, status] = min_cost_flow(kNumSources, kNumTargets, kCost, kCapacity, kSupply, kDemand);
cost
flow
status
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
