function [mincost,path,status] = tsp(varargin)
	//Solves the classic 'Travelling Salesman Problem' heuristically using the routing library from the Google-OR-tools framework. The algorithm first employs a cheapest path approach for an initial solution and then 'local search' heuristics to improve the initial solution toward an optimal one.
	//
	//Calling Sequence
	//[mincost,path]=tsp(adj_matrix,start_node)
	//[mincost,path]=tsp(adj_matrix,start_node,labels)
	//[mincost,path,status]=tsp(adj_matrix,start_node)
	//[mincost,path,status]=tsp(adj_matrix,start_node, labels)
	//
	//Parameters
	//adj_matrix : It is an [nxn] Adjacency Matrix of integral values, representing the graph (having 'n' nodes, for instance, numbered from '1' to 'n') for which the Travelling Saleman Problem is to be solved. Value adj_matrix(i,j) represents the cost of travelling from node 'i' to node 'j' of the given graph. Asymmetric graphs are also supported, where adj(i,j) <> adj(j,i). A negative value for cost (adj_matrix(i,j)) is simply interpreted as the absence of an edge from node 'i' to node 'j'.
	//start_node : It is the index of the starting node. The optimal path must start and end at this node.
	//labels : Optional functionality to provide string labels to the nodes of the graph. It is a [1xn] vector of strings. (labels(i) is the label given to the node 'i' of the graph
	//time_limit : It is the maximum time (in milliseconds; integral value) for which the optimizer is allowed to run. If by the end of this time, the engine is unable to find even an initial solution, a timeout error status is returned. If, however, an initial solution is found, but not fully optimized yet (in the process of heuristically improving it), it will return the current solution, albeit not optimal, as the final solution. This value cannot be zero. Default : 1 second.
	//mincost : It is an integral value denoting the minimum cost incurred by the "salesman" in traversing the optimal path according to the solution, should one exist.)
	//path :  It is a [1x(n+1)] vector containing indices of nodes in the order of the path to be followed in the optimal solution, should one exist. The first and the last values in this vector are equal to the 'start_node' index provided.
	//status : It is the enumerated "flag" value returned by the Google OR tools Routing Library, indicating the status of the solution.(Details in the description)
	//
	//Description
	//<latex>
	//\text{The \textbf{`Travelling Salesman Problem' } is a classic optimization problem which, given a graph (wherein each edge has some cost/distance associated with it), and an arbitrary `starting node' , vies to find such a path over the said graph so as to visit every vertex exactly once and ending back at the `start\_node' \textbf{(Hamiltonian path) }, while minimizing the total cost/distance of the journey.\\This is aptly explained by the namesake analogy of a `salesman' who needs to decide upon a path through various cities (nodes) while minimizing his travel distance, hence the travel expenditures.\\Travelling salesman problem is essentially a special case of the \textbf{Vehicle Routing Problem}.\\This routine utlizes the 'Routing Model' from the Google OR Tools framework to solve the problem. A \textbf{`cheapest addition' } heuristic is applied to find the initial solution and then \textbf{`local search' } is used to improve it toward an optimal solution.\\\textbf{Asymmetric Travelling Saleman Problem } is also supported, where the cost of travelling from city `i' to city `j' is not the same as cost of travelling from city `j' to city `i' (In this case, the input adjacency matrix is simply not a symmetric matrix)}\\
	//\text{}\\
	//\text{}\\
	//\text{}\\
	//\text{\textbf{\underline{MATHEMATICAL\textbf{ }STATEMENT} :}}\\
	//\text{}\\
	//\text{}\\
	//\text{}\\
	//</latex>
	//
	//<latex>
	//\begin{math}
	//\text{Let }x_{ij} = \begin{cases}
	//1 \quad \text{; if there exists a path from node i to j}\\
	//0 \quad \text{; otherwise}\\
	//\end{cases}\\\\
	//\text{Let their be `n' nodes in the problem}\\
	//\text{Let } c_{ij} \text{ be the distance from node i to node j}\\\\
	//\text{Let }u_{i} \text{ be a dummy variable for } i=1,2,...,n \text{ ;}\\\\
	//\textbf{\underline{Objective }:}\qquad Minimize \sum_{i=1}^{n} \sum_{j \neq i, j=1}^{n} c_{ij} x_{ij} \\\\
	//\text{ Subject to :}
	//\text{ }\qquad 0 \leq x_{ij} \leq 1 \text{ ;} \qquad i,j = 1,2,...,n \text{ ;}\qquad \hspace{3em} \qquad (1)\\\\
	//\text{ }\qquad \hspace{3em} \text{ } \qquad u_{i} \in Z \text{ ; }\qquad \qquad i = 1,2,...,n \text{ ; }\qquad \hspace{3em} \qquad  \text{ }(2)\\\\
	//\text{ }\qquad \hspace{3em} \text{ } \qquad \sum_{i=1,i\neq j}^{n} x_{ij}=1 \text{ ; } j=1,2,...,n \text{ ; } \qquad \hspace{3em} \qquad  (3)\\\\
	//\text{ }\qquad \hspace{3em} \text{ } \qquad \sum_{j=1,j\neq i}^{n} x_{ij}=1 \text{ ; } i=1,2,...,n \text{ ; } \qquad \hspace{3em} \qquad  (4)\\\\
	//\text{ }\qquad \hspace{3em} \text{ } \qquad u_{i} - u_{j} + n x_{ij} \leq n-1 \text{ ; }\qquad 2\leq i\neq j \leq n \text{ ; } \qquad (5)\\\\
	//\text{ (3),(4) enforce that each node can only be arrived from exactly one other node.}\\\\
	//\text{ (5) enforces that there's only a single tour connecting all the node ( Hamiltonian cycle) }
	//\end{math}
	//\text{}\\
	//\text{}\\
	//\text{}\\	
	//\text{}\\
	//</latex>
	//
	//Legend :
	//
	//status - Integral value returned by the Google OR Tools Routing library, indicating the status of the solution for the current TSP
	//<itemizedlist>
	//<listitem>status=0	-	ROUTING_NOT_SOLVED (Before the solver is invoked)			</listitem>
	//<listitem>status=1	-	ROUTING_SUCCESS	(TSP solved successfully(optimal solution found)	</listitem>
	//<listitem>status=2	-	ROUTING_FAIL(No solution found)						</listitem>
	//<listitem>status=3	-	ROUTING_FAIL_TIMEOUT	(solution was taking too much time; Timed out)	</listitem>
	//</itemizedlist>
	//
	// For more details, refer to  : 	https://en.wikipedia.org/wiki/Travelling_salesman_problem
	//
	// or to : 				https://developers.google.com/optimization/routing/tsp/tsp
	//
	// The problem is also related to the HAMILTONIAN PATH problem : https://en.wikipedia.org/wiki/Hamiltonian_path
	//
	//
	//Examples
	//
	//adj=[0 10 50 45;
	//10 0 25 25;
	//50 25 0 40;
	//45 25 40 0];
	// 
	//start_node=1;
	// 
	//[mincost,path,status]=tsp(adj,start_node);
	////Press ENTER to continue
	//
	////OUTPUT : 
	////'ROUTING_SUCCESS' ; An optimal solution was found
	////Minimum cost -> 120
	////Optimal Path :- 
	////1 ->2 ->3 ->4 ->1  
	//
	//Examples
	//
	//adj=[0 10 15 20;
	//10 0 35 25;
	//15 35 0 30;
	//20 25 30 0];
	// 
	//start_node=1;
	// 
	//labels=['A' 'B' 'C' 'D'];
	//[mincost,path,status]=tsp(adj,start_node,labels);
	////Press ENTER to continue
	////
	////OUTPUT :
	////'ROUTING_SUCCESS' ; An optimal solution was found
	////Minimum cost -> 80
	////Optimal Path :- 
	//// A (1) -> B (2) -> D (4) -> C (3) ->A (1) 
	//
	//Examples
	//
	//adj=[0 1 2 1 1;
	//1 0 1 2 1;
	//2 1 0 1 2;
	//1 2 1 0 2;
	//1 1 2 2 0];
	// 
	//start_node=1;
	// 
	//labels=['alpha' 'beta'  'gamma' 'theta' 'sigma'];
	// 
	//[mincost,path,status]=tsp(adj,start_node,labels);
	////Press ENTER to continue
	//
	////OUTPUT : 
	////'ROUTING_SUCCESS' ; An optimal solution was found
	////Minimum cost -> 5
	////Optimal Path :- 
	//// alpha (1) -> sigma (5) -> beta (2) -> gamma (3) -> theta (4) ->alpha (1) 
	//
	//Examples
	//
	//adj=[0 10 -1 -2;
	//10 0 35 25;
	//-1 35 0 30;
	//-1 25 30 0];
	// 
	//start_node=1;
	// 
	//[mincost,path,status]=tsp(adj,start_node);
	////Press ENTER to continue
	////
	////OUTPUT :
	////'ROUTING_FAIL' ; No optimal solution  was found. No path starting and ending at the specified 'start node'(1) found.
	//
	//Authors
	//Samuel Wilson
	
	
	
	
	
	
	//obtaining the number of inputs and outputs
	
	[lhs,rhs]=argn();
	
	
	
	//checking the number of input arguments
	
	if (rhs<2 | rhs>4) then
	errmsg=msprintf(gettext("%s : Number of input arguments is expected to be 2 - 4. Found %d. Refer to help/FOT documentation for more details.\n"),"tsp",rhs);
	error(errmsg);
	end
	
	//checking the number of output arguments
	
	if (lhs<2 | lhs>3) then
	errmsg=msprintf(gettext("%s : Number of output arguments is expected to be to 2 or 3. Found %d. Refer to the help/FOT documentation for more details.\n"),"tsp",lhs);
	error(errmsg);
	end
	
	
	//storing the input arguments
	
	adj_matrix=varargin(1);
	start_node=varargin(2);
	
	time_limit = 1000;
	labels = ""; //NOTE- the size of labels ( ie. "") is actually '1', not '0'
	
	if (rhs > 2) then
		if ( varargin(3)<>[] ) then
		labels = varargin(3);
		end
	end
	
	if ( rhs > 3 ) then
		if (varargin(4) <> []) then
		time_limit = varargin(4);
		end
	end
	
	
	
	//checking the types of the input arguments
	
	Checktype("tsp",adj_matrix,"adj_matrix",1,"constant");
	Checktype("tsp",start_node,"start_node",2,"constant");
	
	
	if (rhs > 2) then
	Checktype("tsp",labels,"labels",3,"string");
	end
	
	if ( rhs > 3) then
	Checktype("tsp",time_limit,"time_limit",4,"constant");
	end
	
	
	
	//getting the number of rows and columns in the given adjacency matrix
	m=size(adj_matrix,"r");
	n=size(adj_matrix,"c");
	
	
	//checking the dimensions of the adjacency matrix
	if (m <> n) then
	errmsg=msprintf(gettext("%s : The dimensions of the given adjacency matrix are erroneous [%d x %d]. Number of rows and columns has to be equal(square matrix) ( = no. of nodes in the graph).\n"),"tsp",m,n);
	error(errmsg);
	end
	
	
	//checking if all the diagonal elements of the given adjacency matrix are zero
	
	if (~(and(diag(adj_matrix)==0))) then
	errmsg=msprintf(gettext("%s : All leading diagonal elements of the adjacency matrix need to be 0\n"),"tsp");
	error(errmsg);
	end
	
	
	//checking if the 'start_node' value is a singular value(1 x 1 matrix)
	if ((size(start_node,"r")>1) | (size(start_node,"c")>1)) then
	errmsg=msprintf(gettext("%s : Invalid start_node index value. Singlular value indicating the index of the node from where the journey is to begin expected\n"),"tsp");
	error(errmsg);
	end
	
	
	
	//Checking if all the values in the adjacency matrix and the start node index are integral(no fractional part(or =0)) 
 	//NOTE- x.0 is considered INTEGRAL!
 	
 	if (~(and(adj_matrix==(int(adj_matrix))))) then
 	errmsg=msprintf(gettext("% s : All values in the adjacency matrix ( input argument #%d) are expected to be integral\n"),"tsp",1);
 	error(errmsg);
 	end
 	
 	if(~(and(start_node==(int(start_node))))) then
 	errmsg=msprintf(gettext("%s : The start_node index ( input argument #%d) is expected to be integral\n"),"tsp",2);
 	error(errmsg);
 	end
	
	
	
	
	//checking if the value of the given 'start_node' is valid(exists in the graph)
	if (start_node<=0 | start_node>m) then
	errmsg=msprintf(gettext("%s : Invalid ''start node'' index (%d). It is expected to be between ''1'' and ''%d''(no. of nodes in the given graph).\n"),"tsp",start_node,m);
	error(errmsg);
	end
	
	
 	
 	
 	//checking the dimensions of the 'labels' matrix, if 'tis specified
 	
 	if (labels <> "") then
 		if ((size(labels,"r")>1) | (size(labels, "c")<> m)) then
 			if ((size(labels,"r")>1) & (~(size(labels,"c")<>m))) then
 			errmsg=msprintf(gettext("%s : The ''labels'' matrix (input argument #%d) must have only one row, ie., it must be vector\n"),"tsp",3);
 			elseif ((~(size(labels,"r")>1)) & (size(labels, "c")<> m)) then
 			errmsg=msprintf(gettext("%s : The number of elements ''labels'' vector (input argument #%d) must be equal to the number of nodes in the graph.(found %d)\n"),"tsp",3,size(labels,"c"));
 			else
 			errmsg=msprintf(gettext("%s : Invalid dimensions for ''labels'' vector(input argument #%d). [1 x %d] vector expected. (Found [%d x %d]. \n"),"tsp",3,m,size(labels,"r"),size(labels,"c"));
 			
 			end
 			error(errmsg);
 		end
 	end
 	
 	//checking if all the 'label' values are unique
 	if (labels <>"") then
 		if (length(labels) <> length(unique(labels))) then
 		errmsg=msprintf(gettext("%s : The entries in the ''label'' matrix should be unique ( no 2 nodes can have the same label)\n"),"tsp");
 		error(errmsg);
 		end
 	end
 	
 	//Checking the dimensions of 'time_limit', if given
 	if ( rhs > 3 ) then
 		m = size(time_limit,"r");
 		n = size(time_limit, "c");
 		
 		if ( ~(m==1 & n==1) ) then
 		errmsg = msprintf(gettext("%s : Wrong dimensions for input argument #4(''time_limit''). A single, positive, integral value expected.\n"),"tsp");
 		error(errmsg);
 		end
 		
 		clear m;
 		clear n;
 	end
 	
 	
 	//Checking if the 'time-limit' value, if given, is valid(>0) and integral
 	
 	if ( rhs > 3) then
 		if( ~(and(time_limit ==(int(time_limit))))) then
		errmsg = msprintf(gettext("%s : The time limit value (argument #4) is expected to be integral.\n"),"vrp");
		error(errmsg);
		end
		
 		if ( ~(time_limit > 0) ) then
 		errmsg = msprintf(gettext("%s : The given time-limit is invalid. Positive Value expected.\n"),"tsp");
 		error(errmsg);
 		end
 	end
 
 	
 	//Solving the TSP by invoking the gateway function
 	
 	[mincost,path,status]=TSP(adj_matrix,(start_node-1), time_limit);  // 'path' contains the C++ indices(i.e. starting from 0)
 	
 	
 	select status
 	case 0 then
 		printf("\n''ROUTING_NOT_SOLVED'' ; The solver-module invocation failed. If the problem persists, notify the toolbox authors.\n");
 	case 1 then
 		printf("\n ''ROUTING_SUCCESS'' ; An optimal solution was found\n");
 		printf("Minimum cost -> %d\n\n",mincost);
 		printf("Optimal Path :- \n");
 		temp=size(path,"c");
 		
 		if ( length(labels)<>0 ) then  //labels were provided
 			for i = 1 : (temp-1)
 			printf(" %s (%d) ->",labels(path(i)+1),(path(i)+1));
 			end
 			printf("%s (%d)",labels(path(temp)+1),(path(temp)+1));
 		else
 			for i = 1 : (temp-1)
 			printf("%d ->",(path(i)+1));
 			end
 			printf("%d ",(path(temp)+1));
 		end
 		
 		clear 'temp';
 	
 	case 2 then
 		printf("\n ''ROUTING_FAIL'' ; No optimal solution  was found. No path starting and ending at the specified ''start node''(%d) found.\n", start_node);
 		
 	case 3 then
 		if ( path <> []) then
 		printf("\n''ROUTING_FAIL_TIMEOUT''\n ; The time limit was reached before the model converged to the optimal solution. The returned solution CAN be further optimized; Try increasing the time-limit for a better solution.\n");
 		else
 		printf("\n''ROUTING_FAIL_TIMEOUT''\n ; No solution was found within the stipulated the time-limit. Try increasing the time-limit.\n");
 		end
 	
 	else
 		printf("\nUnexpected return status. Notify the toolbox authors.\n");
 	break;
 	
 	end
 	
 endfunction
 			
 		
 	
	
	
	
	


