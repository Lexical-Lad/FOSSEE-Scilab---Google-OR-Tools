

function [mincost,shortestpath,flag]=fshortestpath(varargin)
	//Computes the shortest/minimum-cost path for a given graph using an implementation of the 'Bellman Ford' algorithm for weighted digraphs.
	//
	//Calling Sequence
	//[mincost,shortestpath]=fshortestpath(start_nodes,end_nodes,weights,st)
	//[mincost,shortestpath]=fshortestpath(start_nodes,end_nodes,weights,st,disconnected_distance)
	//[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)
	//[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st,disconnected_distance)
	//
	//Parameters
	//start_nodes : a [1xn] vector (if the graph has 'n' arcs, for instance) of integral values which stores the numerical label of the start-nodes (tail-nodes) for each arc of the graph.
	//end_nodes : a [1xn] vector of integral values which stores the numerical label of the end-nodes (head-nodes) for each arc of the graph.
	//weights : a [1xn] vector of integral values which stores the weights/traversal costs for each of the edges/arcs of the given graph. Eg.-The weight at index 'i' of this vector refers to the cost/weight of the arc defined by start_node[i]->end_node[i].
	//st : a [1x2] vector which stores the numerical-label of the source node and the target node respectively.
	//disconnected_distance : a singular integral value which indicates that all the weight values greater than or equal to itself essentially mean a non-existent arc/edge/path, i.e. those edges of the given graph will not be considered for the current test. (allows testing with different threshold values if need be)
	//mincost : an integral value denoting the minimum possible cost incurred in traversing from the source node to the target node (summation of weights/costs of all the edges/arcs included in the shortest path, if any)
	//shortestpath : Returns a vector containing the nodes(the numerical tags thereof) lying on the shortest path from source to target, if one exists.
	//flag : flag variable indicating if there exists a path between the given source and target nodes(0-> no path exists; 1-> path exists(ipso facto, a minimal-cost path exists)
	//
	//Description
	//<latex>\text{A staple of graph theory, the \textbf{`Shortest Path' problem } vies to find the least-cost, hence ``shortest" path between any two given nodes in a \textbf{weighted digraph}}^{*}\text{. Essentially a linear programming problem at its core, it is one of the most studied optimization problems.}
	//\text{}\\
	//\text{}\\
	//\text{The routine uses an implementation of the `Bellman Ford single-source shortest path algorithm for weighted digraphs'(negative weights supported)}
	//\text{}\\
	//\text{Bellman–Ford is based on the principle of relaxation, in which an approximation to the correct distance is gradually replaced by more accurate values until eventually reaching the optimum solution.\\The approximate distance to each vertex is always an overestimate of the true distance, and is replaced by the minimum of its old value with the length of a newly found path.\\Bellman–Ford algorithm, unlike the contemporary Dijkstra's shortest path algorithm, simply relaxes all the edges, and does this (|V|-1) times, where |V| is the number of vertices in the graph. In each of these repetitions, the number of vertices with correctly calculated distances grows, from which it follows that eventually all vertices will have their correct distances.\\This method allows the Bellman–Ford algorithm to be applied to a wider class of inputs than Dijkstra's algorithm(Dijkstra's doesn't support negative edges).\\
	//Bellman–Ford runs in O(|V|.|E|) time, where |V| and |E| are the number of vertices and edges respectively.}\\
	//\text{}\\
	//\text{}\\
	//\text{}\\
	//^{*}\text{\underline{\textbf{Weighted Digraph}} : A weighted digraph is a graph in which each edge has a ``weight" associated with it. The \textbf{``weight" } is any quantity of practical significance to the problem, like distance, electrical resistance, etc. Moreover, the edges of the graph are directionally constrained, i.e. an edge from node `a' to node `b' entails neither the existence of an edge from node `b' to node `a' nor the same weight.}\\
	//\text{}\\
	//\text{}\\
	//\text{}\\
	//\text{\textbf{\underline{MATHEMATICAL STATEMENT} :}}\\
	//\text{}\\
	//\text{}\\
	//\text{}\\
	//</latex>
	//<latex>
	//\begin{math}
	//\text{Let } N= \left(V,E\right) \text{be a network with } s,t \in V \text{denoting the source and target nodes in } N\text{, respectively.}\\
	//\text{Let } w_{ij} \text{ denote the cost for the edge } i \to j.\\\\
	//\textbf{\underline{Objective} :}
	//\text{}\quad Maximize \quad \sum_{i,j \in A} w_{ij}x_{ij} \text{ ;}\\\\
	//\text{ } \qquad \hspace{4em} \text{ Subject to } x \geq 0.\\
	//\text{ }\qquad \hspace{4em} \text{ Also, } \sum_{j}x_{ij} - \sum_{j} x_{ji} = \begin{cases}
	//1, \quad if\text{ }i=s\text{;}\\
	//-1, \quad if\text{ }i=t\text{;}\\
	//0, \quad \text{ otherwise;}\\
	//\end{cases} \quad \forall \quad i \text{ ;}\\
	//\end{math}
	//</latex>
	//
	//
	//Examples
	//start_nodes = [0, 0, 0, 1, 1, 2, 2, 3, 3]
  	//end_nodes = [1, 2, 3, 2, 4, 3, 4, 2, 4]
 	//weights = [20, 30, 10, 40, 30, 10, 20, 5, 20]
 	//st=[0,4]
 	//[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)
 	////Press Enter to continue
 	////Output :
 	////Shortest path from start-node:0 to end-node:4 is :
	////0 -> 3 -> 4
	////Minumum cost (using the said path) :- 30.000000
	//
	//
 	//Examples
 	//specifying disconnected-distance
 	//start_nodes = [0, 0, 0, 1, 1, 2, 2, 3, 3]
  	//end_nodes = [1, 2, 3, 2, 4, 3, 4, 2, 4]
 	//weights = [20, 30, 10, 10, 30, 10, 20, 5, 30]
 	//st=[0,4]
 	//disconnected_distance=30
 	//[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)
	////Press Enter to continue
	////Output
	////Shortest path from start-node:0 to end-node:4 is :
	////0 -> 3 -> 2 -> 4
	////Minumum cost (using the said path) :- 35.000000
	////Shortest/Lowest Cost Path found. 
	//
	//
	//Examples
	//start_nodes = [1, 1, 2, 2, 3, 3, 0]
  	//end_nodes = [2, 4, 3, 4, 2, 4, 5]
 	//weights = [40, 30, 10, 20, 5, 20, 30]
 	//st=[0,4]
 	//[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)
 	////Press Enter to continue
	////No path connecting start-node: 0 and end-node=: 4.
	////No Solution![0 , 4] 
	//
	//
 	//Examples
	//start_nodes=[ 0 0 1 1 2 4 5 4];
	//end_nodes= [ 1 5 2 5 3 3 4 2];
	//weights=[10 8 5 2 7 10 10 8];
	//st=[0,3]
	//[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)
	////Press Enter to continue
	////Output
	////Shortest path from start-node:0 to end-node:3 is :
	////0 -> 1 -> 2 -> 3
	////Minumum cost (using the said path) :- 22.000000
	//// Shortest/Lowest Cost Path found.
	// 
	//
 	//Authors
 	//Samuel Wilson
 	
 	
 	
 	//obtaining the number of input and output arguments
 	
 	[lhs,rhs]=argn();
 	
 	
 	//checking the number of input arguments
 	
 	if (rhs<4 | rhs>5) then
 	errmsg=msprintf(gettext("%s : Number of input arguments is expected to be 4 or 5. Found %d. Refer to help/FOT documentation for more details.\n"),"fshortestpath",rhs);
 	error(errmsg);
 	end
 	
 	
 	//checking the number of output arguments
 	if (lhs<2 | lhs >3) then
 	errmsg=msprintf(gettext("%s : Unexpected number of output parameters( Found %d). This routine expects 2 or 3  output parameters. Refer to help/FOT documentation for more details.\n"),"fshortestpath",lhs);
 	error(errmsg);
 	end
 	
 	
 	//storing the input arguments
 	
 	start_nodes=varargin(1);
 	end_nodes=varargin(2);
 	weights=varargin(3);
 	st=varargin(4);
 
 	
 	
 	// checking if the 'disconnected distance' is specified by the user and initilaizing it accordingly
 	if (rhs==5) then
 	disconnected_distance=varargin(5);
 	else
 	disconnected_distance=[2147483647];
 	end
 	
	
	//checking the types of the input arguments
	
	Checktype("fshortestpath",start_nodes,"start_nodes",1,"constant");
	Checktype("fshortestpath",end_nodes,"end_nodes",2,"constant");
	Checktype("fshortestpath",weights,"weights",3,"constant");
	Checktype("fshortestpath",st,"st",4,"constant");
	
	if (rhs == 5) then
	Checktype("fshortestpath",disconnected_distance,"disconnected_distance",5,"constant");
	end
	
	
	
	//Checking the dimensions of the input arguments
	
	m1=size(start_nodes,"r");
	n1=size(start_nodes,"c");
	m2=size(end_nodes,"r");
	n2=size(end_nodes,"c");
	m3=size(weights,"r");
	n3=size(weights,"c");
	
	if (m1<>1) then
 	 errmsg=msprintf(gettext("%s : Wrong Input Size. The input argument #1 is expected to be a matrix of dimensions of the form 1xn (%dx%d obtained instead)"),"fshortestpath",m1,n1);
 	 error(errmsg);
 	 end
 	 
 	 if (m2<>1) then
 	 errmsg=msprintf(gettext("%s : Wrong Input Size. The input argument #2 is expected to be a matrix of dimensions of the form 1xn (%dx%d obtained instead)"),"fshortestpath",m2,n2);
 	 error(errmsg);
 	 end
 	 
 	 if (m3<>1) then
 	 errmsg=msprintf(gettext("%s : Wrong Input Size. The input argument #3 is expected to be a matrix of dimensions of the form 1xn (%dx%d obtained instead)"),"fshortestpath",m3,n3);
 	 error(errmsg);
 	 end
 	 
 	 if ((n1<>n2)|(n2<>n3)) then
 	 errmsg=msprintf(gettext("%s : Unequal dimensions of the 3 input vectors (%d %d %d). The 3 are expected to be of equal lengths."),"fshortestpath",n1,n2,n3);
 	 error(errmsg);
 	 end
 	 
 	 Checkdims("fshortestpath",st,"st",4,[1 2]);
 	 
 	 if (rhs==5) then
 	 Checkdims("fshortestpath",disconnected_distance,"disconnected_distance",5,[1 1]);
 	 end
 	 
 	 clear ['n1' 'n2' 'n3' 'm1' 'm2' 'm3'];
 	 
 	 
 	 //checking if all the input values are indeed integral(no fractional part(or =0))
 	 //NOTE- x.0 is considered INTEGRAL!
 	 
 	 
 	 if (~(and(start_nodes==(int(start_nodes))))) then
 	 errmsg=msprintf(gettext("%s : The values in the ''start_nodes'' vector(input argument #%d) are expected to be integral.\n"),"fshortestpath",1);
 	 error(errmsg);
 	 end
 	 
 	 if (~(and(end_nodes==(int(end_nodes))))) then
 	 errmsg=msprintf(gettext("%s : The values in the ''end_nodes'' vector(input argument #%d) are expected to be integral.\n"),"fshortestpath",2);
 	 error(errmsg);
 	 end
 	 
 	 if (~(and(weights==(int(weights))))) then
 	 errmsg=msprintf(gettext("%s : The values in the ''weights'' vector(input argument #%d) are expected to be integral.\n"),"fshortestpath",3);
 	 error(errmsg);
 	 end
 	 
 	 if (~(and(st==(int(st))))) then
 	 errmsg=msprintf(gettext("%s : The source and target node value(s)(input argument #%d) are expected to be integral.\n"),"fshortestpath",4);
 	 error(errmsg);
 	 end
 	 
 	 
 	 if (rhs==5) then
 	 	if (disconnected_distance<>(int(disconnected_distance))) then
 	 	errmsg=msprintf(gettext("%s : The ''disconnected distance'' value(input argument #%d) is expected to be integral.\n"),"fshortestpath",5);
 	 	error(errmsg)
 	 	end
 	 	
 	 end
 	 
 	 
 	 
 	 
 	 //Checking if the source and target node values are valid i.e. they are actual nodes in the specified graph or not
 	 
 	 if (~(or(st(1)==start_nodes))) then
 	 errmsg=msprintf(gettext("%s : Invalid source node(%d)- The specified source node does not exist in the given graph\n"),"fshortestpath",st(1));
 	 error(errmsg);
 	 end
 	 
 	 if (~(or(st(2)==end_nodes))) then
 	 errmsg=msprintf(gettext("%s : Invalid target node(%d)- The specified target node does not exist in the given graph\n"),"fshortestpath",st(2));
 	 error(errmsg);
 	 end
 	 
 	 
 	 //Solving the problem by invoking the pertinent gateway function
 	 
 	 
 	 [mincost,shortestpath,flag]=BellmanFordShortestPath(start_nodes,end_nodes,weights,st,disconnected_distance,1);
 	 
 	 
 	 if (~exists('flag')) then
 	 flag=0;
 	 end
 	 
 	 if (rhs==5 & flag==0) then // disconnected_distance was specified by the user
 		[mincost2,shortestpath2,flag2]=BellmanFordShortestPath(start_nodes,end_nodes,weights,st,[2147483647],0);
 		flag=0;
 		if (~exists('flag2')) then
 			flag2=0;
 		end
 		clear 'mincost2'
 		clear 'shortestpath2'
 	 end
 	 
 	 
 	 select flag
 	 case 0 then
 	 	printf("\nNo Solution![%d , %d] \n", st(1),st(2));
 	 	mincost=[];
 	 	shortestpath=[];
 	 	if (rhs==5) then
 	 	
 	 		if (flag2==0) then
 	 		printf("No path exists(despite disregarding the specified ''disconnected_distance'' value. Please check the graph or the source/target\n");
 	 		else
 	 		printf("No effective path exists with weights within the specified ''disconnected_distance''(i.e. there is at least 1 path between the given source and target which is not considered due to given constraint on the weight(disconected_distance)). Try increasing the thresholing value, if the problem allows.\n");
 	 		end
 	 	end
 	 	
 	 case 1 then
 	 	printf("\n Shortest/Lowest Cost Path found. \n");
 	else
 	 printf("\nUnrecognized return status. Notify the toolox authors\n");
 	 break;
 	 
 	end
endfunction
 	 
 	 
 	 
 	 
	
	
	
