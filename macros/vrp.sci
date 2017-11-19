function [total_distance,routes,distances,total_time,times,status] = vrp(varargin)
	//Solves the classic 'Vehicle Routing Problem' (VRP for short) heuristically to find the optimal set of routes for a fleet of vehicles delivering goods or services to various locations. The routine makes use of the routing library from the Google-OR-Tools framework. The algorithm first employs a cheapest path approach for an initial naive solution and then 'local search' heuristics to improve it toward an optimal solution.
	//
	//Calling Sequence
	//[total_distance,routes] = vrp(adj_matrix,vehicles,start)
	//[total_distance,routes] = vrp(adj_matrix,vehicles,start,labels)
	//[total_distance,routes] = vrp(adj_matrix,vehicles,start,labels,demands,max_vehicle_capacity)
	//[total_distance,routes] = vrp(adj_matrix, vehicles,start,labels,demands,max_vehicle_capacity,service_time_per_demand)
	//[total_distance,routes] = vrp(adj_matrix, vehicles,start,labels,demands,max_vehicle_capacity,service_time_per_demand,time_windows)
	//[total_distance,routes] = vrp(adj_matrix, vehicles,start,labels,demands,max_vehicle_capacity,service_time_per_demand,time_windows,speeds)
	//[total_distance,routes] = vrp(adj_matrix, vehicles,start,labels,demands,max_vehicle_capacity,service_time_per_demand,time_windows,speeds,waiting_times)
	//[total_distance,routes] = vrp(adj_matrix, vehicles,start,labels,demands,max_vehicle_capacity,service_time_per_demand,time_windows,speeds,waiting_times,refuel_flag,fuel_capacity,refuel_nodes)
	//[total_distance,routes] = vrp(adj_matrix, vehicles,start,labels,demands,max_vehicle_capacity,service_time_per_demand,time_windows,speeds,waiting_times,refuel_flag,fuel_capacity,refuel_nodes,penalty)
	//[total_distance,routes] = vrp(adj_matrix, vehicles,start,labels,demands,max_vehicle_capacity,service_time_per_demand,time_windows,speeds,waiting_times,refuel_flag,fuel_capacity,refuel_nodes,penalty,groups,group_penalty)
	//[total_distance,routes] = vrp(adj_matrix, vehicles,start,labels,demands,max_vehicle_capacity,service_time_per_demand,time_windows,speeds,waiting_times,refuel_flag,fuel_capacity,refuel_nodes,penalty,groups,group_penalty,time_limit)                
	//[total_distance,routes,distances] = vrp(...)
	//[total_distance,routes,distances,total_time] = vrp(...)
	//[total_distance,routes,distances,total_time,times] = vrp(...)
	//[total_distance,routes,distances,total_time,times,status] = vrp(...)
	//
	//Parameters
	// **NOTE : for the sake of simplicity, henceforth 'v' would denote the number of vehicles in the problem and 'n', the number of nodes in the graph
	//adj_matrix : It is an [nxn] matrix of integral values, representing the graph (nodes indexed from '1' to 'n') for which the given VRP is to be solved. adj_matrix[i][j] gives the distance from node 'i' to 'j'.(can be different from adj_matrix[j][i]; asymmetric VRP). A negative value indicates the absence of a path from 'i' to 'j'.
	//vehicles : It is an integral value representing the number of vehicles in the fleet, such that we need to find a optimum route for each vehicle, to minimize the total distance and total time.
	//start : It is a matrix of integral values, pertaining to the index of the starting node(s) or depot(s). The dimensions of this matrix is germane to the type of VRP given, hence determines the pertinent solution strategy. The variations are :-<itemizedlist><listitem>[1x1] - A single integral value - indicating a single depot. All vehicles start and end their journey at this node.</listitem><listitem>[ ] - Empty Matrix - indicating that the vehicle routes can start and end at any node, defining a taxi-service-like scenario.</listitem><listitem>[vx2] - An integral matrix specifying particular start and end nodes for each vehicle ( multiple depot case). start[x][0] -> Start node index for vehicle 'x' ; start[x][1] -> End node for vehicle 'x'.</listitem></itemizedlist>
	//labels : Optional functionality to provide string labels to the nodes of the graph. It is a [1xn] vector of strings. 
	//labels(i) is the label given to the node 'i' of the graph. Give an empty matrix  if labels are not to be provided.
	//demands : It is a [1xn] vector of integral values indicating the demands for the various nodes to be fulfiled by the vehicles. demands[x] denotes the demand of node 'x'. (Demands obviously cannot be negative).
	//If empty, it denotes a non-capacitated VRP, with no demand constraints.
	//max_vehicle_capacity : It is an integral value specifying the maximum capacity of each vehicle (same for all). If capacitated VRP (demands specified), this has to be provided and must be POSITIVE. Can be '0' or empty matrix for non-capacitated VRP.
	//service_time_per_demand : It a single integral value indicating the time required to service one unit of demand in capacitated VRP.
	//time_windows : It is an [nx2] matrix of integral values specifying particular windows of time only within which the different nodes can be serviced. time_windows[x][0]->start of service window for node x ; time_windows[x][1]->end of service window for node 'x'. Can be empty if no time-window constraints. If provided, for a node with no such restriction, provide '0' and '-1'. Time starts from '0' for the model.
	//speeds : It is a matrix of integral values specifying the speed of the vehicles. The variations are :-<itemizedlist><listitem> empty matrix - Indicates that transit times are to be ignored while minimizing total-time for the optimal route.</listitem><listitem> [1x1] - single value - Same avg. speed for all vehicles between any two nodes.</listitem><listitem> [nxn] - A matrix specifying different avg.speeds between different nodes. speed[x][y]-> Gives the average speed while going from node 'x' to node 'y'. (Asymmetric speeds supported)</listitem></itemizedlist>
	//waiting_times : a [1xn] vector of integral values containing the waiting times, if any, at the nodes. Could be empty if no waiting constraints.
	//refuel_flag : a single integral value indicating if fuel constraints are to be considered or not.(Default : '0')<itemizedlist><listitem>  '0'->No fuel constraints</listitem><listitem>  '1' ->Fuel constraints to be included in the model.</listitem></itemizedlist>
	//fuel_capacity : a single integral value specifying the fuel capacity of the vehicles under consideration (same for all). Need to be provided if refueling constraints active. Needs to be positive.
	//refuel_nodes : It is a [1xA] vector of integral values (A-> no. of refuel nodes), containing the indices of refueling nodes. Could be empty indicating the absence of refuel nodes.
	//penalty : It is an [Ax2] matrix containing the cost penalties for skipping certain optional nodes (A->no. of optional nodes). penalty[x][0]-> The index of the optional node ; penalty[x][1]-> The cost penalty associated with that node.
	//groups : It is an [AxB] matrix of integral values specifying groups of nodes that must lie on the same vehicle route. A-> No. of groups. B-> Size of the largest group. Each row contains the indices of a separate group. Smaller groups are padded with '0's on the right.
	//group_penalty : It is a single integral value specifying the cost penalty incurred if a node from a group is unable to be serviced by the same vehicle in the optimal solution. This value is mandatory if group constraints are included in the model. (The model tends to minimize total distance and total time, while amassing minimal cost penalties ( legible tradeoffs to minimize distance ). USE -1, if the groups are to be strictly imposed (cannot exclude a node from a group while vying to minimize distance). This value CAN be zero, indicating that grouping constraints are purely optional. Default value : -1.
	//time_limit : It is the maximum time (in milliseconds; integral value) for which the optimizer is allowed to run. If by the end of this time, the engine is unable to find even an initial solution, a timeout error status is returned. If, however, an initial solution is found, but not fully optimized yet (in the process of heuristically improving it), it will return the current solution, albeit not optimal, as the final solution. This value cannot be zero. Default : 10 seconds.
	//
	//total_distance : It is the summation of the total distance for all the routes in the optimal solution, if any.
	//routes :  It is a [vxn] matrix containing the routes for the vehicles in the optimal solution, if any. (padded with 0's on the right)
	//distances : It is a [1xv] vector containing the distances covered by the various routes in the optimal solution.
	//total_time : It is the summation of the times taken by the various vehicles to complete their journeys.
	//times : It is a [1xv] vector containing the individual times taken by the vehicles to complete their routes.
	//status : It is the enumerated "flag" value returned by the Google OR tools Routing Library, indicating the status of the solution.(Details in the description)
	//
	//Description
	//<latex>
	//\text{The \textbf{`Vehicle Routing Problem' } is a combinatorial optimization and linear integer programming problem in graph theory.\\A superset of the well-known \textbf{Travelling Salesman Problem}, it vies to find an optimal set of non-overlapping routes for a fleet of vehicles (the anecdotal ``salesmen"), passing through a given set of cities(nodes in the graph) starting from one or more starting nodes called the \textbf{`depot(s)'}.\\In the pursuit of optimality, it tends to minimize the \textbf{total distance } across all the routes and/or other parameters specified by the user, like \textbf{`time'}, \textbf{`cost'}, etc.}\\
	//\text{}\\
	//\text{}\\
	//\text{}\\
	//\text{\textbf{\underline{MATHEMATICAL\textbf{ }STATEMENT} :}}\\
	//\text{}\\
	//\text{}\\
	//\text{}\\
	//</latex>
	//<latex>
	//\begin{math}
	//\text{Let } N= \left(V,E\right) \text{denote the specified graph}\\
	//\text{Let } c_{ij} \text{ denote the distance from } i \to j.\\\\
	//\textbf{\underline{Objective} : }\quad Minimize \quad \sum_{i \in V} \sum_{j \in V} c_{ij} x_{ij} \\\\\\
	//\text{Subject to :} \qquad
	//\sum_{i\in V} x_{ij} = 1 \quad \forall \quad j \in V\backslash\{0\}\qquad (1) \\\\
	//\text{}\\
	//\text{}\qquad \hspace{3em} \qquad \sum_{j\in V} x_{ij} = 1 \quad \forall \quad i \in V\backslash\{0\}\qquad \text{ } (2) \\\\
	//\text{}\\
	//\text{}\qquad \hspace{3em} \qquad \sum_{i\in V} x_{i0} = K\quad \text{;} \qquad \hspace{3em} \qquad\text{ } (3)\\\\
	//\text{}\\
	//\text{}\qquad \hspace{3em} \qquad \sum_{j\in V} x_{0j} = K\quad \text{;} \qquad \hspace{3em} \qquad\text{ } (4)\\\\
	//\text{}\\
	//\text{}\qquad \hspace{3em} \qquad x_{ij} \in \{0,1\} \quad \forall \quad i,j \in  V \text{ ; } \hspace{3em} \text{ }  (5)\\\\
	//\text{}\\
	//\end{math}
	//\text{}\\
	//\text{}\\
	//</latex>
	//
	//<latex>
	//\text{}\\
	//\text{}\\
	//\text{(1), (2) specify that exactly one arc enters and one arc leaves each node in the solution.}\\
	//\text{}\\
	//\text{(3), (4) specify that the total number of leaving the depot is equal to the total number entering it(single depot mode).}
	//\text{}\\
	//\text{}\\
	//\text{}\\	
	//</latex>
	//
	//Legend :
	//
	//status - Integral value returned by the Google OR Tools Routing library, indicating the status of the solution for the current VRP
	//<itemizedlist>
	//<listitem>status=0	-	ROUTING_NOT_SOLVED (Before the solver is invoked)			</listitem>
	//<listitem>status=1	-	ROUTING_SUCCESS	(TSP solved successfully(optimal solution found)	</listitem>
	//<listitem>status=2	-	ROUTING_FAIL(No solution found)						</listitem>
	//<listitem>status=3	-	ROUTING_FAIL_TIMEOUT	(solution was taking too long; Timed out)	</listitem>
	//</itemizedlist>
	//
	// For more details, refer to  : 	https://en.wikipedia.org/wiki/Vehicle_routing_problem
	//
	// or to : 				https://developers.google.com/optimization/routing/tsp/vehicle_routing#cvrp
	//
	// The problem is also related to the HAMILTONIAN PATH problem : https://en.wikipedia.org/wiki/Hamiltonian_path
	//
	//
	//Examples
	// //INPUT:
	//adj_matrix = 	[0, 2451,  713, 1018, 1631, 1374, 2408,  213, 2571,  875, 1420, 2145, 1972; 
	//	2451,    0, 1745, 1524,  831, 1240,  959, 2596,  403, 1589, 1374,  357,  579; 
	//	713, 1745,    0,  355,  920,  803, 1737,  851, 1858,  262,  940, 1453, 1260; 
	//	1018, 1524,  355,    0,  700,  862, 1395, 1123, 1584,  466, 1056, 1280,  987; 
	//	1631,  831,  920,  700,    0,  663, 1021, 1769,  949,  796,  879,  586,  371; 
	//	1374, 1240,  803,  862,  663,    0, 1681, 1551, 1765,  547,  225,  887,  999; 
	//	2408,  959, 1737, 1395, 1021, 1681,    0, 2493,  678, 1724, 1891, 1114,  701; 
	//	213, 2596,  851, 1123, 1769, 1551, 2493,    0, 2699, 1038, 1605, 2300, 2099; 
	//	2571,  403, 1858, 1584,  949, 1765,  678, 2699,    0, 1744, 1645,  653,  600; 
	//	875, 1589,  262,  466,  796,  547, 1724, 1038, 1744,    0,  679, 1272, 1162; 
	//	1420, 1374,  940, 1056,  879,  225, 1891, 1605, 1645,  679,    0, 1017, 1200; 
	//	2145,  357, 1453, 1280,  586,  887, 1114, 2300,  653, 1272, 1017,    0,  504; 
	//	1972,  579, 1260,  987,  371,  999,  701, 2099,  600, 1162,  1200,  504,   0];
	//
	//labels = ["New York", "Los Angeles", "Chicago", "Minneapolis", "Denver", "Dallas", "Seattle", "Boston", "San Francisco", "St. Louis", "Houston", "Phoenix", "Salt Lake City"];
	//
	//start = 1;
	//
	//vehicles = 3;
	//
	//demands = [0, 19, 21, 6, 19, 7, 12, 16, 6, 16, 8, 14, 21 ];
	//
	//service_time_per_demand=3;
	//
	//max_vehicle_capacity = 60;
	//
	//[total_distance,routes] = vrp(adj_matrix, vehicles,start,labels,demands,max_vehicle_capacity,service_time_per_demand);
	//
	//Examples
	//adj_matrix = 	[0, 2451,  713, 1018, 1631, 1374, 2408,  213, 2571,  875, 1420, 2145, 1972; 
	//	2451,    0, 1745, 1524,  831, 1240,  959, 2596,  403, 1589, 1374,  357,  579; 
	//	713, 1745,    0,  355,  920,  803, 1737,  851, 1858,  262,  940, 1453, 1260; 
	//	1018, 1524,  355,    0,  700,  862, 1395, 1123, 1584,  466, 1056, 1280,  987; 
	//	1631,  831,  920,  700,    0,  663, 1021, 1769,  949,  796,  879,  586,  371; 
	//	1374, 1240,  803,  862,  663,    0, 1681, 1551, 1765,  547,  225,  887,  999; 
	//	2408,  959, 1737, 1395, 1021, 1681,    0, 2493,  678, 1724, 1891, 1114,  701; 
	//	213, 2596,  851, 1123, 1769, 1551, 2493,    0, 2699, 1038, 1605, 2300, 2099; 
	//	2571,  403, 1858, 1584,  949, 1765,  678, 2699,    0, 1744, 1645,  653,  600; 
	//	875, 1589,  262,  466,  796,  547, 1724, 1038, 1744,    0,  679, 1272, 1162; 
	//	1420, 1374,  940, 1056,  879,  225, 1891, 1605, 1645,  679,    0, 1017, 1200; 
	//	2145,  357, 1453, 1280,  586,  887, 1114, 2300,  653, 1272, 1017,    0,  504; 
	//	1972,  579, 1260,  987,  371,  999,  701, 2099,  600, 1162,  1200,  504,   0];
	//
	//labels = ["New York", "Los Angeles", "Chicago", "Minneapolis", "Denver", "Dallas", "Seattle", "Boston", "San Francisco", "St. Louis", "Houston", "Phoenix", "Salt Lake City"];
	//
	//start = [] ;
	//
	//vehicles = 3;
	//
	//demands = [0, 19, 21, 6, 19, 7, 12, 16, 6, 16, 8, 14, 21 ];
	//
	//service_time_per_demand=3;
	//
	//max_vehicle_capacity = 60;
	//
	//[total_distance,routes] = vrp(adj_matrix, vehicles,start,labels,demands,max_vehicle_capacity,service_time_per_demand);
	//
	//
	//Authors
	//Samuel Wilson
	
	
	
	
	
	
	//obtaining the number of inputs and outputs
	
	[lhs,rhs]=argn();
	
	
	//checking the number of output arguments
	
	if (lhs < 2 | lhs > 6) then
	errmsg = msprintf(gettext("%s : Number of output parameters is expected to be ''2'' to ''6''. Found %d. Refer to help/FOT Documentation for more details\n"),"vrp",lhs);
	error(errmsg);
	end
	
	
	
	
	//checking the number of input arguments
	
	if (rhs < 3 | rhs > 17) then
	errmsg = msprintf(gettext("%s : Number of input parameters is expected to be 3-16 (3,4,6,7,8,9,10,13,14, 16 or 17 only). Found %d. Refer to help/FOT Documentation for more details\n"),"vrp",rhs);
	errro(errmsg);
	end
	
	
	//storing and further checking the number of input arguments
	
	adj_matrix = varargin(1);
	vehicles = varargin(2);
	start = varargin(3);
	
	
	
	///////initializing all the optional parameters(before checking if corresponding input is provided)///////
	labels = "";  //NOTE- the size of labels ( ie. "") is actually '1', not '0'
	demands = [];
	max_vehicle_capacity = 0;
	service_time_per_demand = 0;  // default = 0, ie.service times to be ignored for time minimization
	time_windows = [];
	speeds = [];
	waiting_times = [];
	refuel_flag = 0;
	fuel_capacity = [];
	refuel_nodes = [];
	penalty = [];
	groups = [];
	group_penalty=-1; // default = -1, ie. Grouping is strictly imposed.
	time_limit = 10000; // default = empty, ie. No time limit imposed
	
	
	
	//Note, for an empty string a="", in scilab, 'length(a) returns 'zero' but the size if [1x1]
	
	
	if (rhs > 3) then
		if ( varargin(4)<>[] ) then
		labels = varargin(4);
		end
	end
	
	
	
	
	if (rhs > 4) then
		if (rhs == 5) then
		errmsg = msprintf(gettext("%s : Unexpected number of input arguments (5). ''Max Vehicle Capacity'' (argument #6) mandatory when ''demands'' (argument #5) specified.\n"),"vrp");
		error(errmsg);
		else
		demands = varargin(5);
		max_vehicle_capacity = varargin(6);
		end
	end
	
	
	if (rhs > 6) then
		if (length(varargin(7))<>0) then
		service_time_per_demand = varargin(7);
		end
	end
	
	
	if (rhs > 7) then
	time_windows = varargin(8);
	end
	
	if (rhs > 8) then
	speeds = varargin(9);
	end
	
	if (rhs > 9) then
	waiting_times = varargin(10);
	end
	
	
	if (rhs > 10) then
		if (length(varargin(11)<>0)) then
		refuel_flag = varargin(11);
		end
		
		if ( rhs < 13) then
			if ( refuel_flag == 1) then
			errmsg = msprintf(gettext("%s : Unexpected number of input arguments (%d). Number of input parameters can be 3,4,6,7,8,9,10,13,14, 16 or 17 only. ''fuel_capacity'' (argument #12) and ''fuel_nodes'' (argument #13)  are required to be given if ''refuel_flag'' (argument #10) is given. Refer to help/FOT Documentation for more details.\n"),"vrp",rhs);
			error(errmsg);
			end
		else
		fuel_capacity = varargin(12);
		refuel_nodes = varargin(13);
		
		end
	end
	
	if (rhs > 13) then
	penalty = varargin(14);
	end
	
	
	if (rhs > 14) then
	groups = varargin(15);
		if (rhs < 16) then
		errmsg = msprintf(gettext("%s : Unexpected number of input arguments (%d). Number of input parameters can only be 3,4,6,7,8,9,10,13,14, 16 or 17. ''group_penalty'' (argument #16) must be provided with ''groups'' (argument #15). Refer to help/FOT Documentation for more details.\n"),"vrp",rhs);
		error(errmsg);
		
		else
			if (length(varargin(16))<>0) then	
			group_penalty = varargin(16);
			end
		end
	end
	
	if (rhs > 16) then
		if (varargin(17) <> []) then
		time_limit = varargin(17);
		else
		time_limit = 1000;
		end
	end
	
	//All inputs stored; optional inputs which weren't provided, initialized
	
	
	
	////////Checking the type of all input arguments//////
	
	Checktype("vrp",adj_matrix,"adj_matrix",1,"constant");
	Checktype("vrp",vehicles,"vehicles",2,"constant");
	Checktype("vrp",start,"start",3,"constant");
	
	//empty matrix is also of type - "constant" so we can directly check without conditions if the optional parameter was actually provided

	Checktype("vrp",labels,"labels",4,"string");
	Checktype("vrp",demands,"demands",5,"constant");
	Checktype("vrp",max_vehicle_capacity,"max_vehicle_capacity",6,"constant");
	Checktype("vrp",service_time_per_demand,"service_time_per_demand",7,"constant");
	Checktype("vrp",time_windows,"time_windows",8,"constant");
	Checktype("vrp",speeds,"speeds",9,"constant");
	Checktype("vrp",waiting_times,"waiting_times",10,"constant");
	Checktype("vrp",refuel_flag,"refuel_flag",11,"constant");
	Checktype("vrp",fuel_capacity,"fuel_capacity",12,"constant");
	Checktype("vrp",refuel_nodes,"refuel_nodes",13,"constant");
	Checktype("vrp",penalty,"penalty",14,"constant");
	Checktype("vrp",groups,"groups",15,"constant");
	Checktype("vrp",group_penalty,"group_penalty",16,"constant");
	Checktype("vrp",time_limit,"time_limit",17,"constant");
	
	
	
	
	///////Checking the dimensions of all the inputs///////
	
	//checking 'adj_matrix'
	
	m=size(adj_matrix,"r");
	n=size(adj_matrix,"c");
	
	
	if (m <> n) then
	errmsg = msprintf(gettext("%s : The dimensions of the given adjacency matrix ''adj_matrix'' (argument #1) are erroneous [%d %d]. Number of rows and columns are to be equal (square matrix) (=no. of nodes of the graph). \n"),"vrp",m,n);
	error(errmsg);
	end
	
	nodes = m; //number of nodes in the graph
	
	
	//checking 'vehicles'
	
	mode_flag= [];
	
	m = size(vehicles,"r");
	n = size(vehicles,"c");
	 
	
	if ( ~(m==1 & n==1)) then
	errmsg = msprintf(gettext("%s : Wrong dimensions [%dx%d] for input argument #2 ( ''vehicles''). Single integral value expected (ie. [1x1]).\n"),"vrp",m,n);
	error(errmsg);
	end
	
	
	//checking 'start' and setting mode_flag accordingly
	
	m = size(start,"r");
	n = size(start,"c");
	
	if ( (m == 1) & (n == 1) ) then
	mode_flag = 0;
	elseif ( (m == 0) & (n == 0) ) then
	mode_flag = 1;
	elseif ( (m == vehicles) & (n == 2) ) then
	mode_flag = 2;
	else
	errmsg = msprintf(gettext("%s : Wrong dimensions for input argument #3 (''start''). Expected to be either [1x1], (empty matrix) or [vx2] ( v->number of vehicles). Refer to help/FOT Documentation for more details.\n"),"vrp");
	error(errmsg);
	end
	
	
	
	//checking 'demands'
	
	m=size(demands,"r");
	n=size(demands,"c");
	
	
	if ( ~((m==0 & n==0) | (m==1 & n==nodes)) ) then
	errmsg = msprintf(gettext("%s : Wrong dimensions for the input argument #5 (''demands''). Expected to be either an empty matrix or one with dimensions [1x%d]. \n"),"vrp",nodes);
	error(errmsg);
	end
	
	
	
	
	//checking labels
	
	m=size(labels,"r");
	n=size(labels,"c");
	
	
	if (  labels <> "") then
	if ( ~(m==1 & n==nodes) ) then
	errmsg = msprintf(gettext("%s : Wrong dimensions for the input argument #4 ( ''labels''). Expected to be an empty matrix or one with dimensions [1x%d]. \n"),"vrp",nodes);
	error(errmsg);
	end
	end
	
	
	
	//checking 'max_vehicle_capacity'
	
	m = size(max_vehicle_capacity,"r");
	n = size(max_vehicle_capacity,"c");
	
	if ( ~((m==0 & n==0) | (m==1 & n==1)) ) then
	errmsg = msprintf(gettext("%s : Wrong dimensions for the input argument #6 ( ''max_vehicle_capacity''). Expected to be either an empty matrix or a singular integral value[1x1].\n"),"vrp");
	error(errmsg);
	end
	
	
	
	
	//checking 'service_time_per_demand'
	
	m = size(service_time_per_demand,"r");
	n = size(service_time_per_demand,"c");
	
	
	if ( ~((m==1) & (n==1))) then
	errmsg = msprintf(gettext("%s : Wrong dimensions for the input argument #7 (''service_time_per_demand''). Expected to be either an empty matrix or a singular integral value[1x1].\n"),"vrp");
	error(errmsg);
	end
	
	
	
	//checking 'time_windows'
	
	m = size(time_windows,"r");
	n = size(time_windows,"c");
	
	if ( ~((m==0 & n==0) | (m==nodes & n==2))) then
	errmsg = msprintf(gettext("%s : Wrong dimensions for the input argument #8 (''time_windows''). Expected to be either an empty matrix or one with dimensions [%dx2].\n"),"vrp",nodes);
	error(errmsg);
	end
	
	
	
	
	//checking 'speeds'
	
	m = size(speeds,"r");
	n = size(speeds,"c");
	
	if ( ~((m==0 & n==0) | (m==1 & n==1) | (m==nodes & n==nodes))) then
	errmsg = msprintf(gettext("%s : Wrong dimensions for the input argument #9 ( ''speeds''). Expected to be either [1x1], [%dx%d] or an empty matrix.\n"),"vrp",nodes,nodes);
	error(errmsg);
	end
	
	
	//checking 'waiting_times'
	
	m = size(waiting_times,"r");
	n = size(waiting_times,"c");
	
	if ( ~((m==0 & n==0) | (m==1 & n==nodes)) ) then
	errmsg = msprintf(gettext("%s : Wrong dimensions for the input argument #10 (''waiting_times''). Expected to be either an empty matrix or one with dimensions [1x%d].\n"),"vrp",nodes);
	error(errmsg);
	end
	
	
	
	//checking 'refuel_flag'
	
	m = size(refuel_flag,"r");
	n = size(refuel_flag,"c");
	
	if ( ~(m==1 & n==1)) then
	errmsg = msprintf(gettext("%s : Wrong dimensions for the input argument #11 (''refuel_flag''). Expected either a singular 0/1 value or an empty matrix.\n"),"vrp");
	error(errmsg);
	end
	
	
	//checking 'fuel_capacity'
	
	m = size(fuel_capacity,"r");
	n = size(fuel_capacity,"c");
	
	if ( refuel_flag == 1) then
		if ( ~(m==1 & n==1)) then
		errmsg = msprintf(gettext("%s : Wrong dimensions for the input argument #12 (''fuel_capacity''). Expected a singular integral value.\n"),"vrp");
		error(errmsg);
		end
	else
		if ( ~(m == 0 & n == 0) ) then
		errmsg = msprintf(gettext("%s : Empty matrix expected for the input argument #12 (''fuel_capacity''), when ''refuel flag'' is 0.\n"),"vrp");
		error(errmsg);
		end
	end
	
	
	
	//checking 'refuel_nodes'
	
	m = size(refuel_nodes, "r");
	n = size(refuel_nodes,"c");
	
	if ( refuel_flag == 1)
		if ( ~((m==0 & n==0) | (m==1 & n<=nodes))) then
		errmsg = msprintf(gettext("%s : Wrong dimensions for the input argument #13 (''refuel_nodes''). Expected a vector or an empty matrix.\n"),"vrp");
		error(errmsg);
		end
	else
		if ( ~(m == 0 & n == 0) ) then
		errmsg = msprintf(gettext("%s : Empty matrix expected for the input argument #13 (''refuel_nodes''), when ''refuel flag'' is 0.\n"),"vrp");
		error(errmsg);
		end
	end
	
	
	//checking 'penalty'
	
	m = size(penalty,"r");
	n = size(penalty,"c");
	
	
	if ( ~((m==0 & n==0) | (m<=nodes & n==2)) ) then
	errmsg = msprintf(gettext("%s : Wrong dimensions for the input argument #14 (''penalty''). Expected an [Ax2] matrix (A->number of skippable nodes) or an empty matrix. \n"),"vrp");
	error(errmsg);
	end
	
	
	//checking 'groups'
	
	m = size(groups,"r");
	n = size(groups,"c");
	
	if ( ~((m==0 & n==0) | (m<=nodes & n<=nodes))) then
	errmsg = msprintf(gettext("%s : Wrong dimensions for the input argument #15 (''groups''). Expected an empty matrix or one whose size cannot exceed the number of nodes.\n"),"vrp");
	error(errmsg);
	end
	
	
	//checking 'group_penalty'
	
	m = size(group_penalty,"r");
	n = size(group_penalty,"c");
	
	if ( ~(m==1 & n==1)) then
	errmsg = msprintf(gettext("%s : Wrong dimensions for the input argument #16 (''group_penalty''). Expected a singular integral value or an empty matrix.\n"),"vrp");
	error(errmsg);
	end
	
	//checking 'time_limit'
	
	m = size(time_limit,"r");
	n = size(time_limit,"c");
	
	
	if ( ~((m==1 & n==1)))  then 
	errmsg = msprintf(gettext("%s : Wrong dimensions for the input argument #17 (''time_limit''). Expected a singular, integral, positive value.\n"),"vrp");
	error(errmsg);
	end
	
	
	
	/////Dimensions verified/////
	
	
	
	
	
	///////Checking if all the inputs are integral(ie. No fractional part)(NOTE -> x.0 is considered inherently integral as fractional part is '0'////////


	if ( ~(and(adj_matrix==(int(adj_matrix))))) then
	errmsg = msprintf(gettext("%s : All values in argument #1 (''adj_matrix'') are expected to be integral.\n"),"vrp");
	error(errmsg);
	end
	
	
	
	if( ~(and(vehicles ==(int(vehicles))))) then
	errmsg = msprintf(gettext("%s : Number of vehicles ( argument #2) is expected to be an integral value.\n"),"vrp");
	error(errmsg);
	end
	
	
	if( ~(and(start ==(int(start))))) then
	errmsg = msprintf(gettext("%s : The value(s) for argument #3 ( ''start'') is (are) expected to be integral.\n"),"vrp");
	error(errmsg);
	end
	
	
	if( ~(and( demands==(int(demands))))) then
	errmsg = msprintf(gettext("%s : All values in argument #5 (''demands'') are expected to be integral.\n"),"vrp");
	error(errmsg);
	end
	
	
	if( ~(and(max_vehicle_capacity == (int(max_vehicle_capacity))))) then
	errmsg = msprintf(gettext("%s : Max Vehicle Capacity value (argument #6) is expected to be integral.\n"),"vrp");
	error(errmsg);
	end
	
	if( ~(and(service_time_per_demand ==(int(service_time_per_demand))))) then
	errmsg = msprintf(gettext("%s : The value for servive-time-per-demand (argument #7) is expected to be integral.\n"),"vrp");
	error(errmsg);
	end
	
	if( ~(and( time_windows==(int(time_windows))))) then
	errmsg = msprintf(gettext("%s : All values in argument #8 (''time_windows'') are expected to be integral.\n"),"vrp");
	error(errmsg);
	end
	
	
	if( ~(and(speeds ==(int(speeds))))) then
	errmsg = msprintf(gettext("%s :  The value(s) for argument #9 (''speeds'') is (are) expected to be integral.\n"),"vrp");
	error(errmsg);
	end
	
	if( ~(and(waiting_times ==(int(waiting_times))))) then
	errmsg = msprintf(gettext("%s : The values in argument #10 (''waiting_times'') are expected to be integral.\n"),"vrp");
	error(errmsg);
	end
	
	
	if( ~(and(refuel_flag ==(int(refuel_flag))))) then
	errmsg = msprintf(gettext("%s : The Refuel Flag value (argument #11) is expected to be integral.\n"),"vrp");
	error(errmsg);
	end
	
	if( ~(and(fuel_capacity==(int(fuel_capacity))))) then
	errmsg = msprintf(gettext("%s : The fuel capacity value for the vehicles (argument #12) is expected to be integral.\n"),"vrp");
	error(errmsg);
	end
	
	if( ~(and(refuel_nodes ==(int(refuel_nodes))))) then
	errmsg = msprintf(gettext("%s : All values in argument #13 (''refuel_nodes'') are expected to be integral.\n"),"vrp");
	error(errmsg);
	end
	
	if( ~(and(penalty ==(int(penalty))))) then
	errmsg = msprintf(gettext("%s : All values in argument #14 (''penalty'') are expected to be integral.\n"),"vrp");
	error(errmsg);
	end
	
	if( ~(and(groups==(int(groups))))) then
	errmsg = msprintf(gettext("%s : All values in argument #15 (''groups'') are expected to be integral.\n"),"vrp");
	error(errmsg);
	end
	
	if( ~(and(group_penalty ==(int(group_penalty))))) then
	errmsg = msprintf(gettext("%s : The group-penalty value (argument #16) is exected to be integral.\n"),"vrp");
	error(errmsg);
	end
	
	if( ~(and(time_limit ==(int(time_limit))))) then
	errmsg = msprintf(gettext("%s : The time limit value (argument #17) is expected to be integral.\n"),"vrp");
	error(errmsg);
	end
	
	
	
	//-----------------------------------------------LOGICAL CHECKS---------------------------------------------------------//
	
	
	////////Checking 'adj_matrix' (argument #1) /////////
	
	
	//checking if all the diagonal values in adj_matrix are 0's
	
	if (~(and(diag(adj_matrix)==0))) then
	errmsg=msprintf(gettext("%s : All leading diagonal elements of the adjacency matrix need to be 0\n"),"tsp");
	error(errmsg);
	end
	
	
	
	////////// Checking 'vehicles'(argument #2) ////////// 
	
	//checking if the value of 'vehicles' is positive
	
	if ( ~(vehicles > 0) )  then
	errmsg = msprintf(gettext("%s :  The number of vehicles in the fleet must be a positive value.\n"),"vrp");
	error(errmsg);
	end
	
	
	////////// Checking 'start'(argument #3) ////////// 
	
	
	//if 'start' ain't null, checking if all the values are valid indices (indices go from '1' to 'nodes')
	if ( start<>[]) then
		if ( (or(start>nodes)) | (or(start<1)) ) then // one or more index values exceed 'nodes'
			if (length(start) <> 1) then
			errmsg = msprintf(gettext("%s : One or more index values in ''start'' are invalid. Indices can only go from ''1'' to ''%d'' for the given problem\n"),"vrp",nodes);
			else
			errmsg = msprintf(gettext("%s : The given ''start'' value is not a valid node index. Indices can only go from ''1'' to ''%d'' for the given problem\n"),"vrp",nodes);
			end
		error(errmsg);
		end
	end
	
	
	
	
	
	////////// Checking 'labels'(argument #4) ////////// 
	
	if ( length(labels) <> (length(unique(labels))) ) then
	errmsg = msprintf(gettext("%s : The entries in the ''label'' matrix need to be unique (no 2 nodes can have the same labels).\n"),"vrp");
	error(errmsg);
	end
	
	
	
	
	////////// Checking 'max_vehicle_capacity'(argument #6) ////////// (needs to be checked before the demands)
	
	
	//Checking if the max_vehicle_capacity value is specified(not empty matrix) is demands are given
	
	if (demands <> []) then
		if ( max_vehicle_capacity == []) then
		errmsg = msprintf(gettext("%s : For a capacitate VRP, the max_vehicle_capacity cannot be exclude(cannot be an empty matrix).\n"),"vrp");
		error(errmsg);
		end
	end
	
	
	
	//if the problem is a capacitated VRP(demands specified), checking if the value is positive
	
	
	if (demands <> []) then
		if ( max_vehicle_capacity<1) then
		errmsg = msprintf(gettext("%s : The maximum-vehicle-capacity value needs to be positive.\n"),"vrp");
		error(errmsg);
		end
	end
	
	
	
	
	
	
	
	
	
	////////// Checking 'demands'(argument #5) ////////// 
	
	if ( demands <>[]) then
	
		//checking if no values are negative
		
		if ( or(demands<0)) then
		errmsg = msprintf(gettext("%s : One or more values in the ''demands'' vector are negative.\n"),"vrp");
		error(errmsg);
		end
		
		//checking if no demand value exceeds the max_vehicle_capacity value
		
		if ( or(demands > max_vehicle_capacity) ) then
		errmsg = msprintf(gettext("%s : The demand values for one or more nodes exceed the maximum capacity for the vehicles in question, rendering them unserviceable.\n"),"vrp");
		error(errmsg);
		end
		
		//checking that the total demand doesn't exceed the total capacity
		
		if ( (sum(demands))>(vehicles*max_vehicle_capacity) ) then
		errmsg = msprintf(gettext("%s : The total demand exceeds the total capacity of the vehicles in the fleet. The scenario is inherently unserviceable.\n"),"vrp");
		error(errmsg);
		end 
		//we do not consider the case of skip-penalties here as that is only a tradeoff vying for optimality, not an inherent mechanism to conpensate for the handicap of demands exceeding the capacity. The model is essentially impractical in this situation.
		
		
		
		//checking if the demand values for the depot(s) is(are) zero.
		if (mode_flag == 0) then
			if ( demands(start) <> 0 ) then
			errmsg = msprintf(gettext("%s : The demand for the depot node has to be zero.\n"),"vrp");
			error(errmsg);
			end
		elseif (mode_flag == 2) then
			deps = start(:,1);
			for i = 1: length(deps)
				if ( demands(deps(i)) <> 0 )  then
				errmsg = msprintf(gettext("%s : The demand for all the depot (start) nodes must be zero.\n"),"vrp");
				end
			end
			clear deps;
		end
			
		
		
		
		
	end
	
	
	
	
	////////// Checking 'service_time_per_demand'(argument #7) ////////// 
	
	if ( service_time_per_demand < 0 ) then
	errmsg = msprintf(gettext("%s : The value for argument #7 (''service_time_per_demand'') cannot be negative.\n"),"vrp");
	error(errmsg);
	end
	 
	
	////////// Checking 'time_windows'(argument #8) ////////// 
	
	if ( time_windows<> []) then
		
		//converting all '-1's from the second column, if any, to INT_MAX
		temp = time_windows(:,2); //seconds column extracted
		
		for i=1:nodes
			if ( temp(i)=='-1' ) then
			time_windows(i,2) = 2147483647;
			end
		end
		
		
		//checking if all values are non-negative now
		
		if ( or(time_windows <0) ) then
		errmsg = msprintf(gettext("%s : Values in ''time_windows'' matrix cannot be negative (except ''-1'' for end times indicating no upper bound for the corresponding node).\n"),"vrp");
		error(errmsg);
		end
		
		
		//checking if all the end times are greater than or equal to the corresponding start times
		
		if ( ~(and(time_windows(:,1)<=time_windows(:,2))) ) then
		errmsg = msprintf(gettext("%s :  Invalid time-window values : The end-time for service window for one or more nodes in less than the corresponding start-time.\n"),"vrp");
		error(errmsg);
		end
		
		//checking if the windows are wide enough to be serviceable i.e. the window size if greater than or equal to the total service time. Service time is zero by default for when 'tis to be ignored in time minimization so we don't need to demarcate that case(0 will always be less than or equal to the window size(>=0)). This is only to be done is demands are given(ie.e 'tis a capacitated VRP)
		
//		if ( demands <> []) then
//			if ( or((time_windows(:,2)-time_windows(:,1)) >= (((demands*service_time_per_demand)') + waiting_times)) ) then
//			errmsg = msprintf(gettext("%s : The time-window for one or more nodes is not wide enough to be serviceable(i.e. the duration of the time-window is smaller than the time required to service that node.\n"),"vrp");
//			error(errmsg);
//			end
//			
//		end
	end
		
		
	
	
	////////// Checking 'speeds'(argument #9) ////////// 
	
	if ( speeds <> []) then
		if (length(speeds)==1) then
			if (speeds(1,1)<1) then
			errmsg = msprintf(gettext("%s : The avg.speeds value thus provided must be POSITIVE.\n"),"vrp");
			error(errmsg);
			end
		else  //[nxn] matrix given
		
		//first off, all the diagonal values need to be zero
		
			if ( ~(and(diag(speeds) == 0)) ) then
			errmsg = msprintf(gettext("%s : All the diagonal values in the given ''speeds'' matrix (argument #9) need to be ''0''.\n"),"vrp");
			error(errmsg);
			end
			
			
			for i = 1:nodes
				for j = 1:nodes
					if ( (speeds(i,j)<1) & (i<>j)) then
					errmsg = msprintf(gettext("%s : Speed values need to be POSITIVE. \n"),"vrp");
					error(errmsg);
					end
				end
			end
			
		end
		
	end
			
	
	
	
	
	
	
	////////// Checking 'waiting_times'(argument #10) ////////// 
	
	//checking if waiting times are non-negative	
	
	if ( waiting_times <>[]) then
		if ( or(waiting_times < 0) ) then
		errmsg = msprintf(gettext("%s : Waiting time values cannot be negative. \n"),"vrp");
		error(errmsg);
		end
		
	end
	
	
	 
	 
	 
	////////// Checking 'refuel_flag'(argument #11) ////////// 
	
	//checking if the value is only either '0' or '1'
	
	if ( (refuel_flag<>1) & (refuel_flag<>0) ) then
	errmsg= msprintf(gettext("%s :  The refuel flag can only take the value ''0'' or ''1''. Check the FOT documentation for details.\n"),"vrp");
	error(errmsg);
	end
	
	
	
	
	
	
	////////// Checking 'fuel_capacity'(argument #12) ////////// 
	
	
	//checking if the fuel_capacity value is positive
	
	if ( rhs > 10 ) then
		if ( fuel_capacity<1 ) then
		errmsg = msprintf(gettext("%s : Fuel Capacity value is expected to be positive.\n"),"vrp");
		error(errmsg);
		end
	end
	
	
	
	
	////////// Checking 'refuel_nodes'(argument #13) ////////// 
	
	
	//checking if all the indices are valid
	
	if ( refuel_nodes<>[]) then
		if ( (or(refuel_nodes<1))  | (or(refuel_nodes>nodes)) ) then
		errmsg = msprintf(gettext("%s : One or more fuel node index values are invalid. Valid indices for the current model - ''1'' to ''%d''. \n"),"vrp",nodes);
		error(errmsg);
		end
	end
	
	
	
	
	
	////////// Checking 'penalty'(argument #14) ////////// 
	
	if ( penalty <> [] ) then
		if ( (or(penalty(:,1)<1)) | (or(penalty(:,1)>nodes)) ) then
		errmsg = msprintf(gettext("%s : One or more node indices provided in the ''penalty'' matrix ( argument #14) are invalid. Valid indices for the current model- ''1'' to ''%d''. \n"),"vrp",nodes);
		error(errmsg);
		end
		
		if ( or(penalty(:,2)<0) ) then
		errmsg = msprintf(gettext("%s : Cost penalty values in the ''penalty'' matrix (argument #14) cannot be negative.\n"),"vrp");
		error(errmsg);
		end
		
		
		if ( start <> []) then
			if ( length(start)==1 ) then
				if ( or(penalty(:,1)==start) ) then
				errmsg = msprintf(gettext("%s : The depot cannot be provided as an optional node.\n"),"vrp");
				error(errmsg);
				end
			else
				for i= 1:(size(penalty,"r"))
					if ( (or(start(:,1) == penalty(i,1))) | (or(start(:,2) == penalty(i,1)))  ) then
					errmsg = msprintf(gettext("%s Node of the start/end nodes can be specified as optional in the ''penalty'' matrix.\n"),"vrp");
					error(errmsg);
					end
				end
			end
		end
	end
	
	
	
	
	
	////////// Checking 'groups'(argument #15) ////////// 
	
	if ( groups <>[] ) then
		if ( (or(groups < 0)) | (or(groups>nodes)) ) then 
		errmsg = msprintf(gettext("%s : One or more node index values in argument #15 ( ''groups'') is invalid. Valid indices for this model - ''1'' to ''%d''.\n"),"vrp",nodes);
		error(errmsg);
		end
		
		
		num_groups = size(groups,"r");
		groups_cols = size(groups,"c");
		
		num_zeroes=0;
		
		for i = 1:num_groups
			num_zeroes= num_zeroes + length(find(groups(i,:)==0));
			if ( ((min(find(groups(i,:)==0)))) <> [] ) then
				if ( (groups_cols-length(find(groups(i,:)==0))+1) <> ((min(find(groups(i,:)==0)))) ) then // indicates that there's a zero somewhere between the other indices in the current group, i.e. an index of '0' is specified
				errmsg = msprintf(gettext("%s : Index value for a node cannot be ''0''. Zero''s are only used for right-padding in the ''groups'' matrix. Check row %d.\n"),"vrp",i);
				error(errmsg);
				end
			end
		end
		

		 if ( num_zeroes == 0 ) then
		 	if ( (length(unique(groups)))<>length(groups) )  then
		 	errmsg = msprintf(gettext("%s : One or more node index values in the ''groups'' matrix (argument #15) are repeated. No index can occur twice in a group. Also, no node can be a part of 2 groups.\n"),"vrp");
		 	error(errmsg);
		 	end
		 else
		 	if ( (length(unique(groups)) + num_zeroes - 1) <> length(groups) ) then
		 	errmsg = msprintf(gettext("%s : One or more node index values in the ''groups'' matrix (argument #15) are repeated. No index can occur twice in a group. Also, no node can be a part of 2 groups.\n"),"vrp");
		 	error(errmsg);
		 	end
		 end
		 
		 clear num_zeroes;
		 clear num_groups;
		 clear groups_cols;
		 
	end
	
	////////// Checking 'group_penalty'(argument #16) ////////// 
	
	
	//checking if the value is permissible(-1,0, or positive)
	
	if ( group_penalty < -1 ) then
	errmsg = msprintf(gettext("%s : Forbidden value for ''group_penalty'' (argument #16). Expected- -1, 0, or any positive value.\n"),"vrp");
	error(errmsg);
	end
	
	
	
	////////// Checking 'time_limit'(argument #17) ////////// 
	
	
	//checking is time limit positive
	
	if ( time_limit < 1 ) then
	errmsg = msprintf(gettext("%s : Positive value expected for the ''time_limit'' (argument #17). \n"),"vrp");
	error(errmsg);
	end
	
	
	
	//---------------------------------END OF LOGICAL CHECKS---------------------------------------------------//
	
	
	
	
	
	//-----------------------------------------SOLUTION--------------------------------------------------------//
	
	
	//Solving the given VRP by calling the gateway function
	
	
	[total_distance, routes, distances, total_time, times, status] = VRP(adj_matrix, vehicles, mode_flag, start, demands, max_vehicle_capacity, service_time_per_demand, time_windows, speeds, waiting_times, refuel_flag, fuel_capacity, refuel_nodes, penalty, groups, group_penalty, time_limit);
	
	
	
	select status
	
	case 0 then
		printf("\n''ROUTING_NOT_SOLVED'' ; The solver-module invocation failed. If the problem persists, notify the toolbox authors.\n");
	case 1 then
	
		
		if ( lhs > 5) then
		printf( "Status :- %d\n",status);
		end	
		printf("\n ''ROUTING_SUCCESS'' ; An optimal solution was found for the given model!\n");
		printf("Total Distance -> %d\n",total_distance);
		
		if ( lhs>3) then
		printf("Total time -> %d\n",total_time);
		end
		
		printf("\n Optimal Routes :- \n");
		
		for i = 1:vehicles
			temp = routes(i,:);
			if ( find(temp==0)<>[]) then
			temp = temp(1:(min(find(temp==0))-1));  // returns the row sans the zero padding, if any
			end
			
			
			if ( temp(1)==temp(2) ) then
			printf("Vehicle #%d - Not Deployed!\n", i);
			else
			 
			printf("\n\n\nRoute for vehicle #%d : - \n",i);
			
			
			tt=1;
			
			if ( length(labels)<>0) then
				for j = 1 : (length(temp)-1)
				printf(" %s (%d) ->", labels(temp(j)),temp(j));
				tt=j+1;
				end
				
				if ( length(temp) == nodes ) then //when all nodes are mapped to a single route(or when no. of vehicles is '1')
					printf(" %s (%d) ->",labels(temp(tt)),temp(tt));
					printf(" %s (%d) \n",labels(temp(1)),temp(1));
				else
					printf(" %s (%d) \n",labels(temp(tt)),temp(tt));
				end
				
						
			else
				for j= 1 : (length(temp)-1)
				printf(" %d ->", temp(j));
				end
				if ( length(temp) == nodes ) then //when all nodes are mapped to a single route(or when no. of vehicles is '1')
					printf(" %d ->",temp($));
					printf(" %d \n",temp(1));
				else
					printf(" %d \n",temp($));
				end
				
			end
			
			
			if ( lhs > 2) then
				printf( "The total-distance for route #%d = %d\n",i,distances(i));
				
				if ( lhs > 4) then
				printf( " The time taken for route #%d = %d\n",i,times(i));
				end
					
			end
			
			end
				
		end
		
		clear 'temp';	
		clear 'tt';
		
		
	
	
	case 2 then
		printf("\n''ROUTING_FAIL''\n ; No optimal solution was found for the given model.\n");
	
	case 3 then
		if ( routes <> []) then
 		printf("\n''ROUTING_FAIL_TIMEOUT''\n ; The time limit was reached before the model converged to the optimal solution. The returned solution CAN be further optimized; Try increasing the time-limit for a better solution.\n");
 		else
 		printf("\n''ROUTING_FAIL_TIMEOUT''\n ; No solution was found within the stipulated the time-limit. Try increasing the time-limit.\n");
 		end
 	
 	else
 		printf("\nUnexpected return status. Notify the toolbox authors.\n");
 	break;
 	
 	end
 	
endfunction
	
	
	
	

