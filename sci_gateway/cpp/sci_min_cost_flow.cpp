/*
	Sample:

	Source: Ex.2: http://www.yourarticlelibrary.com/ergonomics/operation-research/checking-for-optimality-transportation-problem/34743/

	// Doesn't Work (Unbalanced)
	a = 4;
	b = 4;
	c = [4, 6, 8, 13; 13, 11, 10, 8; 14, 4, 10, 13; 9, 11, 13, 8];
	d = [200, 200, 200, 200; 200, 200, 200, 200; 200, 200, 200, 200; 200, 200, 200, 200];
	e = [50, 70, 30, 50];
	f = [25, 35, 105, 20];
	[x, y] = solve_mincostflow(a, b, c, d, e, f);

	// Works (Balanced)
	a = 4;
	b = 5;
	c = [4, 6, 8, 13, 0; 13, 11, 10, 8, 0; 14, 4, 10, 13, 0; 9, 11, 13, 8, 0];
	d = [200, 200, 200, 200, 200; 200, 200, 200, 200, 200; 200, 200, 200, 200, 200; 200, 200, 200, 200, 200];
	e = [50, 70, 30, 50];
	f = [25, 35, 105, 20, 15];
	[x, y] = solve_mincostflow(a, b, c, d, e, f);
*/
#include "ortools/graph/min_cost_flow.h"

extern "C"{
	#include <stdlib.h>
	#include <api_scilab.h>
	#include <localization.h>
	#include <Scierror.h>
	#include <sciprint.h>

	int sci_min_cost_flow(const char* fname, unsigned long fname_len);
}

#include "sci_iofunc.hpp"

using namespace operations_research;

int sci_min_cost_flow(const char* fname, unsigned long fname_len)
{
	CheckInputArgument(pvApiCtx, 6, 6);
	CheckOutputArgument(pvApiCtx, 2, 3);

	// Input Args
	int kNumSources = 0;
	int kNumTargets = 0;
	long long* kCost = NULL;
	long long* kCapacity = NULL;
	long long* kSupply = NULL;
	long long* kDemand = NULL;

	// Output Args
	long long OptimalCost = 0;
	long long* FlowMatrix = NULL;
	int Status = 0;

	// Input from Scilab
	if(getInt32FromScilab(1, &kNumSources))
	{
		return 1;
	}
	if(getInt32FromScilab(2, &kNumTargets))
	{
		return 1;
	}
	if(getFixedSizeInt64MatrixFromScilab(3, kNumSources, kNumTargets, &kCost))
	{
		return 1;
	}
	if(getFixedSizeInt64MatrixFromScilab(4, kNumSources, kNumTargets, &kCapacity))
	{
		return 1;
	}
	if(getFixedSizeInt64MatrixFromScilab(5, 1, kNumSources, &kSupply))
	{
		return 1;
	}
	if(getFixedSizeInt64MatrixFromScilab(6, 1, kNumTargets, &kDemand))
	{
		return 1;
	}

	// Solve
	StarGraph graph(kNumSources + kNumTargets, kNumSources * kNumTargets);
	MinCostFlow obj(&graph);
	for (NodeIndex source = 0; source < kNumSources; ++source)
	{
		for (NodeIndex target = 0; target < kNumTargets; ++target)
		{
			ArcIndex arc = graph.AddArc(source, kNumSources + target);
			// sciprint("Cost: %ld\n", kCost[target * kNumSources + source]);
			// obj.SetArcUnitCost(arc, *kCost[source * kNumTargets + target]);
			obj.SetArcUnitCost(arc, (CostValue)kCost[target * kNumSources + source]);
			// sciprint("Capacity: %ld\n", kCapacity[target * kNumSources + source]);
			// obj.SetArcCapacity(arc, *kCapacity[source * kNumTargets + target]);
			obj.SetArcCapacity(arc, (FlowQuantity)kCapacity[target * kNumSources + source]);
		}
	}
	for (NodeIndex source = 0; source < kNumSources; ++source)
	{
		// sciprint("Supply: %ld\n", kSupply[source]);
		obj.SetNodeSupply(source, (FlowQuantity)(1 * kSupply[source]));
	}
	for (NodeIndex target = 0; target < kNumTargets; ++target)
	{
		// sciprint("Demand: %ld\n", kDemand[target]);
		obj.SetNodeSupply(kNumSources + target, (FlowQuantity)(-1 * kDemand[target]));
	}
	obj.Solve();

	// Format Solution
	OptimalCost = (long long)obj.GetOptimalCost();
	FlowMatrix = (long long*)malloc(sizeof(long long) * kNumSources * kNumTargets);
	for (int source = 0; source < kNumSources; ++source)
	{
		for (int target = 0; target < kNumTargets; ++target)
		{
			int arc = source * kNumTargets + target;
			// FlowMatrix[source * kNumTargets + target] = (long long)(obj.Flow(arc));
			FlowMatrix[target * kNumSources + source] = (long long)(obj.Flow(arc));
		}
	}
	Status = (int)(obj.status());

	// Output
	if (returnInt64ToScilab(1, OptimalCost))
	{
		return 1;
	}
	if (returnInt64MatrixToScilab(2, kNumSources, kNumTargets, FlowMatrix))
	{
		return 1;
	}
	if (returnInt32ToScilab(3, Status))
	{
		return 1;
	}

	// Cleanup
	free(kCost);
	free(kCapacity);
	free(kSupply);
	free(kDemand);
	free(FlowMatrix);

	return 0;
}