// Expected size [4 5] for input argument kCost at input #3, but got [4 4] instead.

kNumSources = 4;
kNumTargets = 5;
kCost = [4, 6, 8, 13; 13, 11, 10, 8; 14, 4, 10, 13; 9, 11, 13, 8]; // <---
kCapacity = [200, 200, 200, 200, 200; 200, 200, 200, 200, 200; 200, 200, 200, 200, 200; 200, 200, 200, 200, 200];
kSupply = [50, 70, 30, 50];
kDemand = [25, 35, 105, 20, 15];
[cost, flow, status] = min_cost_flow(kNumSources, kNumTargets, kCost, kCapacity, kSupply, kDemand);
