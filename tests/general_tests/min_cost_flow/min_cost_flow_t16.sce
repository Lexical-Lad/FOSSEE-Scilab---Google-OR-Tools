// Expected size [1 5] for input argument kDemand at input #6, but got [1 4] instead.

kNumSources = 4;
kNumTargets = 5;
kCost = [4, 6, 8, 13, 0; 13, 11, 10, 8, 0; 14, 4, 10, 13, 0; 9, 11, 13, 8, 0];
kCapacity = [200, 200, 200, 200, 200; 200, 200, 200, 200, 200; 200, 200, 200, 200, 200; 200, 200, 200, 200, 200];
kSupply = [50, 70, 30, 50];
kDemand = [25, 35, 105, 20];
[cost, flow, status] = min_cost_flow(kNumSources, kNumTargets, kCost, kCapacity, kSupply, kDemand);
