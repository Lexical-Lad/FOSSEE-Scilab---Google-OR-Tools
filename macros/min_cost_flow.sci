function [cost, flow, status] = min_cost_flow(varargin)
	// Solves problem with finding minimum cost of flow
	//
	//	Calling Sequence
	//	[cost, flow] = min_cost_flow(kNumSources, kNumTargets, kCost, kCapacity, kSupply, kDemand)
	//	[cost, flow, status] = min_cost_flow(kNumSources, kNumTargets, kCost, kCapacity, kSupply, kDemand)
	//   
	//	Parameters
	//	kNumSources : a double, Number of Sources / Suppliers
	//	kNumTargets : a double, Number of Targets / Demanders
	//	kCost : a matrix of double, kNumSources x kNumTargets, represents Cost of flow from a Source to Target
	//	kCapacity : a matrix of double, kNumSources x kNumTargets, represents Capacity of flow from a Source to Target
	//	kSupply : a vector of double, length kNumSources, contains Supply Quantity of Suppliers
	//	kDemand : a vector of double, length kNumTargets, contains Demand Quantity of Demanders 
	//	cost : a double, Optimal (minimum) Cost
	//	flow : a matrix of double, kNumSources x kNumTargets, represents Optimal Flow for the Problem
	//	status : contains the exit flag of Solver. See below
	//
	//	Description
	//	Find the minimum cost and flow for a given set of sources and targets with limit on capacity per flow
	//   
	//	The routine uses Google ORtools for solving the quadratic problem, ORtools is a library written in C++.
	//
	//	<latex>
	//		\text{}\\
	//		\begin{align}
	//		& \text{minimize} && \texttt{kCost}\text{ . }\texttt{flow}\\
	//		& \text{subject to} && \texttt{flow}_{ij} \leq \texttt{kSupply}_i \\
	//		&&& \texttt{flow}_{ij} \geq \texttt{kDemand}_j \\
	//		&&& \texttt{flow}_{ij} \leq \texttt{kCapacity}_{ij} \\
	//		&&& \sum_{i=1}^{\texttt{kNumSources}} \texttt{kSupply}_i = \sum_{j=1}^{\texttt{kNumTargets}} \texttt{kDemand}_j
	//		\end{align}\\
	//		\text{}\\
	//		\text{}\\
	//		\text{}\\
	//	</latex>
	//
	//	The status allows to know the status of the optimization which is given back by ORtools.
	//	<itemizedlist>
	//		<listitem>status=0 : Not Solved</listitem>
	//		<listitem>status=1 : Optimal</listitem>
	//		<listitem>status=2 : Feasible</listitem>
	//		<listitem>status=3 : Infeasible</listitem>
	//		<listitem>status=4 : Unbalanced</listitem>
	//		<listitem>status=5 : Bad Result</listitem>
	//	</itemizedlist>
	//
	//	Examples
	//	//Ref : Example 2 : 
	//	//http://www.yourarticlelibrary.com/ergonomics/operation-research/checking-for-optimality-transportation-problem/34743/
	//
	//	// Before balancing (Infeasible):
	//	//	kNumSources = 4;
	//	//	kNumTargets = 4;
	//	//	kCost = [4, 6, 8, 13; 13, 11, 10, 8; 14, 4, 10, 13; 9, 11, 13, 8];
	//	//	kCapacity = [200, 200, 200, 200; 200, 200, 200, 200; 200, 200, 200, 200; 200, 200, 200, 200];
	//	//	kSupply = [50, 70, 30, 50];
	//	//	kDemand = [25, 35, 105, 20];
	//	//	[cost, flow, status] = min_cost_flow(kNumSources, kNumTargets, kCost, kCapacity, kSupply, kDemand);
	//
	//	// After balancing (Optimal):
	//	kNumSources = 4;
	//	kNumTargets = 5;
	//	kCost = [4, 6, 8, 13, 0; 13, 11, 10, 8, 0; 14, 4, 10, 13, 0; 9, 11, 13, 8, 0];
	//	kCapacity = [200, 200, 200, 200, 200; 200, 200, 200, 200, 200; 200, 200, 200, 200, 200; 200, 200, 200, 200, 200];
	//	kSupply = [50, 70, 30, 50];
	//	kDemand = [25, 35, 105, 20, 15];
	//	[cost, flow, status] = min_cost_flow(kNumSources, kNumTargets, kCost, kCapacity, kSupply, kDemand);
	//	cost
	//	flow
	//	status
	//    
	//	Authors
	//	Souvik Das
	
	[lhs, rhs] = argn();
	Checklhs("min_cost_flow", lhs, [2, 3]);
	Checkrhs("min_cost_flow", rhs, 6);

	kNumSources = varargin(1);
	kNumTargets = varargin(2);
	kCost = varargin(3);
	kCapacity = varargin(4);
	kSupply = varargin(5);
	kDemand = varargin(6);

	Checktype("min_cost_flow", kNumSources, "kNumSources", 1, "constant");
	Checktype("min_cost_flow", kNumTargets, "kNumTargets", 2, "constant");

	Checkdims("min_cost_flow", kNumSources, "kNumSources", 1, [1 1]);
	Checkdims("min_cost_flow", kNumTargets, "kNumTargets", 2, [1 1]);

	if(kNumSources <= 0) then
	    errmsg = msprintf(gettext("%s: Number of Sources should be > 0. Check input #1\n"), "min_cost_flow");
	    error(errmsg);
	end

	if(kNumTargets <= 0) then
	    errmsg = msprintf(gettext("%s: Number of Targets should be > 0. Check input #2\n"), "min_cost_flow");
	    error(errmsg);
	end

	Checktype("min_cost_flow", kCost, "kCost", 3, "constant");
	Checkdims("min_cost_flow", kCost, "kCost", 3, [kNumSources kNumTargets]);

	Checktype("min_cost_flow", kCapacity, "kCapacity", 4, "constant");
	Checkdims("min_cost_flow", kCapacity, "kCapacity", 4, [kNumSources kNumTargets]);

	if(or(kCapacity < 0) == %t) then
	    errmsg = msprintf(gettext("%s: Capacity should be >= 0. Check input #4\n"), "min_cost_flow");
	    error(errmsg);
	end

	Checktype("min_cost_flow", kSupply, "kSupply", 5, "constant");
	Checkdims("min_cost_flow", kSupply, "kSupply", 5, [1 kNumSources]);

	if(or(kSupply < 0) == %t) then
	    errmsg = msprintf(gettext("%s: Supply should be >= 0. Check input #5\n"), "min_cost_flow");
	    error(errmsg);
	end

	Checktype("min_cost_flow", kDemand, "kDemand", 6, "constant");
	Checkdims("min_cost_flow", kDemand, "kDemand", 6, [1 kNumTargets]);

	if(or(kDemand < 0) == %t) then
	    errmsg = msprintf(gettext("%s: Demand should be >= 0. Check input #6\n"), "min_cost_flow");
	    error(errmsg);
	end

	if(sum(kSupply) <> sum(kDemand)) then
	    errmsg = msprintf(gettext("%s: Unbalanced Supply and Demand\n"), "min_cost_flow");
	    error(errmsg);
	end

	[cost, flow, status] = solve_mincostflow(kNumSources, kNumTargets, kCost, kCapacity, kSupply, kDemand);
	
	select status
	case 0 then
		printf("\nProblem Not Solved.\n");
	case 1 then
		printf("\nOptimal Solution Found.\n");
	case 2 then
		printf("\nFeasible Solution Found.\n");
	case 3 then
		printf("\nProblem is Infeasible.\n");
	case 4 then
		printf("\nProblem is Unbalanced.\n");
	case 5 then
		printf("\nBad Result. Retry later or Notify the Toolbox author(s)\n");
    else
        printf("\nSomething went wrong. Retry later or Notify the Toolbox author(s)\n");
        break;
    end
endfunction
