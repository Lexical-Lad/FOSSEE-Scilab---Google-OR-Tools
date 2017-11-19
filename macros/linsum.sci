function [cost, assignment, status] = linsum(varargin)
	// Solves problem with finding minimum cost of assignment
	//
	//   Calling Sequence
	//   [cost, assignment] = linsum(kNumLeftNodes, kNumRightNodes, kCost)
	//   [cost, assignment, status] = linsum(kNumLeftNodes, kNumRightNodes, kCost)
	//   
	//   Parameters
	//   kNumLeftNodes : a double, Number of Left Nodes / Jobs
	//   kNumRightNodes : a double, Number of Right Nodes / Workers
	//   kCost : a matrix of double, kNumLeftNodes x kNumRightNodes, represents Cost of assigning a Job to a Worker
	//   cost : a double, Optimal (minimum) Cost
	//   assignment : a matrix of boolean, kNumLeftNodes x kNumRightNodes, represents Optimal Assignment for the Problem
	//   status : contains the exit flag of Solver. Currently 0 for Not Optimal, 1 for Optimal.
	//
	//   Description
	//   Find the minimum cost and assignment for a given set of jobs and workers
	//   
	//   The routine uses Google ORtools for solving the quadratic problem, ORtools is a library written in C++.
	//
	//	<latex>
	//		\text{}\\
	//		\begin{align}
	//		& \text{minimize} && \texttt{kCost}\text{ . }\texttt{assignment}\\
	//		& \text{subject to} && \sum_{i=0}^{\texttt{kNumLeftNodes}} \texttt{assignment}_{ij} = 1 \\
	//		&&& \sum_{j=0}^{\texttt{kNumRightNodes}} \texttt{assignment}_{ij} = 1
	//		\end{align}\\
	//		\text{}\\
	//		\text{}\\
	//		\text{}\\
	//	</latex>
	//
	//   Examples
	//   //Ref :
	//   //http://www.hungarianalgorithm.com/examplehungarianalgorithm.php
	//
	//   kNumLeftNodes = 4;
	//   kNumRightNodes = 4;
	//   kCost = [82, 83, 69, 92; 77, 37, 49, 92; 11, 69, 5, 86; 8, 9, 98, 23];
	//   [cost, assignment, status] = linsum(kNumLeftNodes, kNumRightNodes, kCost);
	//   cost
	//   assignment
	//   status
	//   
	//   Authors
	//   Souvik Das
	
	[lhs, rhs] = argn();
	Checklhs("linsum", lhs, [2, 3]);
	Checkrhs("linsum", rhs, 3);

	kNumLeftNodes = varargin(1);
	kNumRightNodes = varargin(2);
	kCost = varargin(3);

	Checktype("linsum", kNumLeftNodes, "kNumLeftNodes", 1, "constant");
	Checktype("linsum", kNumRightNodes, "kNumRightNodes", 2, "constant");

	Checkdims("linsum", kNumLeftNodes, "kNumLeftNodes", 1, [1 1]);
	Checkdims("linsum", kNumRightNodes, "kNumRightNodes", 2, [1 1]);

	if(kNumLeftNodes <= 0) then
	    errmsg = msprintf(gettext("%s: Number of Left Nodes should be > 0. Check input #1\n"), "linsum");
	    error(errmsg);
	end

	if(kNumRightNodes <= 0) then
	    errmsg = msprintf(gettext("%s: Number of Right Nodes should be > 0. Check input #2\n"), "linsum");
	    error(errmsg);
	end

	if(kNumLeftNodes <> kNumRightNodes) then
	    errmsg = msprintf(gettext("%s: Number of Left Nodes should be EQUAL to Number of Right Nodes\n"), "linsum");
	    error(errmsg);
	end

	Checktype("linsum", kCost, "kCost", 3, "constant");
	Checkdims("linsum", kCost, "kCost", 3, [kNumLeftNodes kNumRightNodes]);

	[cost, assignment, status] = solve_linsumassignment(kNumLeftNodes, kNumRightNodes, kCost);
	
	select status
	case 0 then
		printf("\nOptimal Solution not Found\n");
	case 1 then
		printf("\nOptimal Solution Found.\n");
    else
        printf("\nSomething went wrong. Retry later or Notify the Toolbox author(s)\n");
        break;
    end
endfunction
