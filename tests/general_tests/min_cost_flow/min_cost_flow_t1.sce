// Number of Sources should be > 0. Check input #1

kNumSources = -1;
kNumTargets = 4;
kCost = [4, 6, 8, 13; 13, 11, 10, 8; 14, 4, 10, 13; 9, 11, 13, 8];
kCapacity = [200, 200, 200, 200; 200, 200, 200, 200; 200, 200, 200, 200; 200, 200, 200, 200];
kSupply = [50, 70, 30, 50];
kDemand = [25, 35, 105, 20];
[cost, flow, status] = min_cost_flow(kNumSources, kNumTargets, kCost, kCapacity, kSupply, kDemand);
