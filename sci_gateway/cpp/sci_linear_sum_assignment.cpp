/*
	Source: http://www.hungarianalgorithm.com/examplehungarianalgorithm.php

	a = 4;
	b = 4;
	c = [9, 2, 7, 8; 6, 4, 3, 7; 5, 8, 1, 8; 7, 6, 9, 4];
	or
	c = [82, 83, 69, 92; 77, 37, 49, 92; 11, 69, 5, 86; 8, 9, 98, 23];
	[x, y] = solve_linsumassignment(a, b, c);
*/
#include "ortools/graph/linear_assignment.h"

extern "C"{
	#include <stdlib.h>
	#include <api_scilab.h>
	#include <localization.h>
	#include <Scierror.h>
	#include <sciprint.h>

	int sci_linear_sum_assignment(const char* fname, unsigned long fname_len);
}

#include "sci_iofunc.hpp"

using namespace operations_research;

int sci_linear_sum_assignment(const char* fname, unsigned long fname_len)
{
	CheckInputArgument(pvApiCtx, 3, 3);
	CheckOutputArgument(pvApiCtx, 2, 3);

	// Input Args
	int kNumLeftNodes = 0;
	int kNumRightNodes = 0;
	long long* kCost = NULL;

	// Output Args
	long long OptimalCost = 0;
	BOOL* AssignmentMatrix = NULL;
	int Status = 0;

	// Input from Scilab
	if(getInt32FromScilab(1, &kNumLeftNodes))
	{
		return 1;
	}
	if(getInt32FromScilab(2, &kNumRightNodes))
	{
		return 1;
	}
	if(getFixedSizeInt64MatrixFromScilab(3, kNumLeftNodes, kNumRightNodes, &kCost))
	{
		return 1;
	}

	// Solve
	ForwardStarGraph graph(kNumLeftNodes + kNumRightNodes, kNumLeftNodes * kNumRightNodes);
	LinearSumAssignment<ForwardStarGraph> obj(graph, kNumLeftNodes);
	for (NodeIndex leftnode = 0; leftnode < kNumLeftNodes; ++leftnode)
	{
		for (NodeIndex rightnode = 0; rightnode < kNumRightNodes; ++rightnode)
		{
			ArcIndex arc = graph.AddArc(leftnode, kNumLeftNodes + rightnode);
			// sciprint("Cost: %ld\n", kCost[rightnode * kNumLeftNodes + leftnode]);
			// obj.SetArcCost(arc, kCost[leftnode * kNumRightNodes + rightnode]);
			obj.SetArcCost(arc, kCost[rightnode * kNumLeftNodes + leftnode]);
		}
	}
	Status = (int)(obj.ComputeAssignment());

	// Format Solution
	OptimalCost = (long long)obj.GetCost();
	AssignmentMatrix = (BOOL*)malloc(sizeof(BOOL) * kNumLeftNodes * kNumRightNodes);
	for (int leftnode = 0; leftnode < kNumLeftNodes; ++leftnode)
	{
		for (int rightnode = 0; rightnode < kNumRightNodes; ++rightnode)
		{
			// AssignmentMatrix[leftnode * kNumRightNodes + rightnode]
			AssignmentMatrix[rightnode * kNumLeftNodes + leftnode] = \
			(kNumLeftNodes + rightnode == (int)(obj.GetMate(leftnode))) ? TRUE : FALSE;
		}
	}

	// Output
	if (returnInt64ToScilab(1, OptimalCost))
	{
		return 1;
	}
	if (returnBooleanMatrixToScilab(2, kNumLeftNodes, kNumRightNodes, AssignmentMatrix))
	{
		return 1;
	}
	if (returnInt32ToScilab(3, Status))
	{
		return 1;
	}

	// Cleanup
	free(kCost);
	free(AssignmentMatrix);

	return 0;
}