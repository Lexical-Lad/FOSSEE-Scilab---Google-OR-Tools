function [maxflow,arcflows,status] = fmaxflow(varargin)
	//Solves the graph max-flow problem(a linear optimization problem) using an implementation of the push-relabel algorithm
	//	
	//Calling Sequence
	//[maxflow,arcflows]=fmaxflow(start_nodes,end_nodes,capacities,st)
	//[maxflow,arcflows,status]=fmaxflow(start_nodes,end_nodes,capacities,st)
	//
	//Parameters
	//start_nodes : a [1xn] vector (if the graph has 'n' arcs, for instance) of integral values which stores the numerical label of the start-nodes (tail-nodes) for each arc of the graph.
	//end_nodes : a [1xn] vector of integral values which stores the value (numerical label) of the end-nodes(head-nodes) for each arc of the graph.
	//capacities : a [1xn] vector of integral values which stores the capacities (max amount possible over a particular arc) of the respective arcs. Eg. The capacity at index 'i' of this matrix means the maximum amount possible over the arc defined by start_node[i]->end_node[i].
	//st : a [1x2] vector which stores the numerical-label (value) of the source node and the target node, respectively.
	//maxflow : a double representing the Maximum total Flow possible(i.e. Solution) through the system in the optimal solution, should there be one.
	//arcflows : a [1xn] vector of double (if the graph has 'n' arcs, for instance) which represents the actual flow through the respective arcs in the optimal solution of the problem, should one exist.
	//status : status flag returned by the Google OR-tools MaxFlow Solver function (details below)
	//
	//Description
	//<latex>
	//\text{The \textbf{`Maximum-Flow' Problem } is a classic (linear) optimization problem for Flow Networks}^{*}\text{. Essentially a part of the class of \textbf{`Circulation Problems'}, it involves finding the maximum amount of flow possible from a specified (source) node to another (sink) node, in a given network.}\\
	//\text{}\\
	//^{*}\text{\underline{\textbf{Flow Network}} - A flow network (also called a `transportation network'), in graph theory, is essentially a directed graph with one (or more) \textbf{source} node(s) and one (or more) \textbf{sink} node(s) and several other standard nodes, connected by edges called \textbf{`arcs'}.}\\
	//\text{\textbf{`Flow'} is any entity that circulates through the network, from the source to the sink. Eg. electric current in a printed circuit, water in a plumbing network, etc.}\\
	//\text{}\\\\
	//\text{}\\\\
	//\text{\textbf{\underline{MATHEMATICAL STATEMENT} :}}\\
	//\text{}\\
	//\text{}\\
	//</latex>
	//<latex>
	//\begin{math}
	//\text{Let } N= \left(V,E\right) \text{ be a network with } s,t \in V \text{ denoting the source and sink nodes in } N\text{, respectively.}\\\\
	//\text{Let } c_{uv} \text{ or } c\left(u,v\right) \text{ denote the capacity of the arc between node } u \text{ and  } v.\\
	//\text{capacity is a mapping } c:V\to R^{+} \\\\
	//\text{Let } f_{uv} \text{ or } f\left(u,v)\right) \text{ denotes the flow between node } u \text{ and } v, \text{such that :}\\
	//\text{  1. } f_{uv} \leq c_{uv} \quad \forall \quad (u,v) \in E.\\
	//\text{  2. } \sum_{u:(u,v)\in E} f_{uv} = \sum_{u:(v,u) \in E} f_{vu}\quad \forall \quad v \in V \backslash \{s,t\}\quad\text{; conservation of flow}\\\\\\
	//\text{}\\
	//\text{}\\
	//\text{}\\
	//\textbf{\underline{Objective} :}
	//\text{}\qquad\qquad\qquad Maximize \quad |f| = \sum_{v:(s,v) \in E}f_{sv} \text{,where }s\text{ is the source vertex for } N.\\\\
	//\text{}\qquad\qquad\qquad\text{}\qquad\qquad\qquad |f| \text{  denotes the total amount of flow passing from the source to the sink}\\
	//\end{math}
	//\text{}\\
	//\text{}\\
	//\text{}\\
	//\text{}\\
	//</latex>
	//
	//status- the status of solution returned by the linked Google OR-Tools max-flow solver
	//<itemizedlist> 
	//<listitem>status=0	-	OPTIMAL(An optimal solution was found)</listitem>
	//<listitem>status=1	-	INT_OVERFLOW(There is a feasible flow > max possible flow)</listitem>
	//<listitem>status=2	-	BAD_INPUT(The input is inconsistent)</listitem>
	//<listitem>status=3	-	BAD_RESULT (There was an error)</listitem>
	//</itemizedlist>
	//
	//
	//Examples
	//
	//start_nodes = [0, 0, 0, 1, 1, 2, 2, 3, 3]
  	//end_nodes = [1, 2, 3, 2, 4, 3, 4, 2, 4]
 	//capacities = [20, 30, 10, 40, 30, 10, 20, 5, 20]
 	//st=[0,4]
 	//[maxflow,arcflows,status]=fmaxflow(start_nodes,end_nodes,capacities,st)
 	//// Press Enter to continue
	////Output
	////Max flow = 60
	////Arc	Flow	Capacity
	////0->1	20	20
	////0->2	30	30
	////0->3	10	10
	////1->2	0	40
	////1->4	20	30
	////2->3	10	10
	////2->4	20	20
	////3->2	0	5
	////3->4	20	20
	//
	////An optimal solution was found
	//// status  =
	//// 
	////  0  
	//// arcflows  =
	//// 
	////  20  30  10  0  20  10  20  0  20  
	//// maxflow  =
	//// 
	////  60  
 	//
 	//
 	//Examples
 	//
 	//start_nodes = [1, 1, 2, 2, 3, 3, 0]
  	//end_nodes = [2, 4, 3, 4, 2, 4, 5]
 	//capacities = [40, 30, 10, 20, 5, 20, 50]
 	//st=[0,4]
 	//[maxflow,arcflows,status]=fmaxflow(start_nodes,end_nodes,capacities,st)
 	////Press Enter to continue
	//// 	Output
	//// 	Max flow = 0
	////Arc	Flow	Capacity
	////1->2	0	40
	////1->4	0	30
	////2->3	0	10
	////2->4	0	20
	////3->2	0	5
	////3->4	0	20
	////0->5	0	50
	//
	////There is no path connecting the specified source node : 0  and the specified target node : 4
	//// status  =
	//// 
	////  0  
	//// arcflows  =
	//// 
	////     []
	//// maxflow  =
	//// 
	////  0  
 	//
 	//
 	//Authors
 	//Samuel Wilson
 	
 	
 	
 	//Checking the number of input and output arguments
 	
 	[lhs , rhs] = argn();
 	
 	 //Checking the number of  input arguments entered by the user
 	 
 	 if (rhs<>4) then
 	 errmsg=msprintf(gettext("%s : Wrong number of input arguments (%d). This function expects 4 arguments. Refer to help/FOT documentation for more details"),"fmaxflow",rhs);
 	 error(errmsg);
 	 end
 	 
 	 //Checking the number of output parameters specified by the user
 	 
 	 if(lhs<2 | lhs>3) then
 	 errmsg=msprintf(gettext("%s : Wrong number of output arguments(%d). This function can deliver 2/3 outputs. Refer to help/FOT documentation for further details"),"fmaxflow",lhs);
 	 error(errmsg);
 	 end
 	 
 	 
 	 //storing the input parameters
 	 
 	 start_nodes=varargin(1);
 	 end_nodes=varargin(2);
 	 capacities=varargin(3);
 	 st=varargin(4);
 	 
 	 
 	 //Checking the types of the input arguments
 	 
 	 Checktype("fmaxflow",start_nodes,"start_nodes",1,"constant");
 	 Checktype("fmaxflow",end_nodes,"end_nodes",2,"constant");
 	 Checktype("fmaxflow",capacities,"capacities",3,"constant");
 	 Checktype("fmaxflow",st,"st",4,"constant");
 	 
 	 //Checking the dimensions of the input arguments
 	 m1=size(start_nodes,"r");
 	 n1=size(start_nodes,"c");
 	 m2=size(end_nodes,"r");
 	 n2=size(end_nodes,"c");
 	 m3=size(capacities,"r");
 	 n3=size(capacities,"c");
 	 
 	 
 	 if (m1<>1) then
 	 errmsg=msprintf(gettext("%s : Wrong Input Size. The input argument #1 is expected to be a matrix of dimension of the form 1xn (%dx%d obtained instead)"),"fmaxflow",m1,n1);
 	 error(errmsg);
 	 end
 	 
 	 if (m2<>1) then
 	 errmsg=msprintf(gettext("%s : Wrong Input Size. The input argument #2 is expected to be a matrix of dimension of the form 1xn (%dx%d obtained instead)"),"fmaxflow",m2,n2);
 	 error(errmsg);
 	 end
 	 
 	 if (m3<>1) then
 	 errmsg=msprintf(gettext("%s : Wrong Input Size. The input argument #3 is expected to be a matrix of dimension of the form 1xn (%dx%d obtained instead)"),"fmaxflow",m3,n3);
 	 error(errmsg);
 	 end
 	 
 	 if ((n1<>n2)|(n2<>n3)) then
 	 errmsg=msprintf(gettext("%s : Unequal dimensions of the 3 input vectors (%d %d %d). The 3 are expected to be of equal lengths."),"fmaxflow",n1,n2,n3);
 	 error(errmsg);
 	 end
 	  
 	 Checkdims("fmaxflow",st,"st",4,[1 2]);
 	 
 	 clear ['n1' 'n2' 'n3' 'm1' 'm2' 'm3'];
 	 
 	 
 	 
 	 //checking if all the input values are indeed integral(no fractional part(or =0)) 
 	 //NOTE- x.0 is considered INTEGRAL!
 	 
 	 
 	 if (~(and(start_nodes==(int(start_nodes))))) then
 	 errmsg=msprintf(gettext("%s : The values in the ''start_nodes'' vector(input argument #%d) are expected to be integral.\n"),"fmaxflow",1);
 	 error(errmsg);
 	 end
 	 
 	 if (~(and(end_nodes==(int(end_nodes))))) then
 	 errmsg=msprintf(gettext("%s : The values in the ''end_nodes'' vector(input argument #%d) are expected to be integral.\n"),"fmaxflow",2);
 	 error(errmsg);
 	 end
 	 
 	 if (~(and(capacities==(int(capacities))))) then
 	 errmsg=msprintf(gettext("%s : The values in the ''capacities'' vector(input argument #%d) are expected to be integral.\n"),"fmaxflow",3);
 	 error(errmsg);
 	 end
 	 
 	 if (~(and(st==(int(st))))) then
 	 errmsg=msprintf(gettext("%s : The source and target node value(s)(input argument #%d) are expected to be integral.\n"),"fmaxflow",4);
 	 error(errmsg);
 	 end
 	 
 	 
 	 
 	 
 	 
 	 
 	 //Checking if the source and target node values are valid i.e. they are actual nodes in the specified graph or not
 	 
 	 if (~(or(st(1)==start_nodes))) then
 	 errmsg=msprintf(gettext("%s : Invalid source node(%d)- The specified source node does not exist in the given graph\n"),"fmaxflow",st(1));
 	 error(errmsg);
 	 end
 	 
 	 if (~(or(st(2)==end_nodes))) then
 	 errmsg=msprintf(gettext("%s : Invalid target node(%d)- The specified target node does not exist in the given graph\n"),"fmaxflow",st(2));
 	 error(errmsg);
 	 end
 	 
 	  
 	 
 	 //Solving the problem by invoking the gateway function
 	 
 	 [maxflow,arcflows,status]=MaxFlow(start_nodes,end_nodes,capacities,st);
 	 
 	 if (maxflow==0) then
 	 printf("\nThere is no path connecting the specified source node : %d  and the specified target node : %d\n",st(1),st(2));
 	 arcflows=[];
 	 else
 	 select status
 	 case 0 then
 	 	printf("\nAn optimal solution was found\n");
 	 case 1 then
 	 	printf("\nINT_OVERFLOW(There is a feasible flow > max possible flow)\n");
 	 case 2 then
 	 	printf("\nBAD_INPUT(The input is inconsistent)\n");
 	 case 3 then
 	 	printf("\nBAD_RESULT (There was an error)\n");
 	else
 	 printf("\nUnrecognized return status. Notify the toolox authors\n");
 	 break;
 	 
 	end
 	end
endfunction
 	 
 	 
 	 
 	 	
 	 
 	 

