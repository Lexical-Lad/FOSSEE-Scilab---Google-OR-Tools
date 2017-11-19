#include "ortools/base/callback.h"
#include "ortools/base/commandlineflags.h"
#include "ortools/base/commandlineflags.h"
#include "ortools/base/integral_types.h"
#include "ortools/base/logging.h"
#include "ortools/constraint_solver/routing.h"
#include "ortools/constraint_solver/routing_enums.pb.h"
#include "ortools/constraint_solver/routing_flags.h"



extern "C"{
#include <vector>
#include <stdlib.h>
#include <limits.h>
#include <memory>
#include <localization.h>
#include <Scierror.h>
#include <api_scilab.h>
#include <sciprint.h>

using namespace operations_research;


//THIS MODEL TENDS TO MINIMIZE THE TOTAL DISTANCE COVERED BY ALL THE VEHICLES COMBINED WHILE ALSO MINIMIZING THE TOTAL TIME TAKEN FOR ALL THE TRIPS


/* (Note- for the sake of explanation, let the number of nodes be represented by 'n' and the number of vedicles in the fleet, by 'v')
Naming suffixes(also, the respective order) for inputs :- 
1-> "adj_matrix" - The given Adjacency matrix representing the intended graph([nxn]). The cell values represent the distance between 2 nodes(cities/locations to be serviced), ie. (adj_matrix[i][j]) represents the disatnce between cities 'i' and 'j'. The solver also supports asymmetrix distances i.e. cases where the distance from node'i' to node'j' is not the same as distance from node'j' to node'i'. Also, negative distance values indicate the absence of an edge/path. ie. if adj[i][j]<0, then there's no path between nodes 'i' and 'j'.
2-> "vehicles" - The number of vehicles/routes in the given Vehicle Routing Problem
3->	"mode_flag"- Indicates the solver mode for the given problem. 3 modes possible : 0-> Single depot node- All vehicles start and end their routes at this node ; 1-> The vehicles can start and end their routes anywhere( modelling a taxi-service scenario) ; 2-> The start and end nodes are specified for all the vehicles by the user )
4-> "start" - Matrix containing info about the start/depot node(s), depending on the mode in the current instance. [1x1] matrix(single numerical value) for mode '0'. Empty matrix(0x0 or []) for mode '1'. [vx2] matrix for mode '2'.
5-> "demands" - Matrix containing the demands of the different nodes that have to be met, in the capacitated VRP.[1xn] expected, but could be NULL([]) in case the problem is not a capacitated VRP(simple visitation problem).
6->	"max_vehicle_capacity" -  In case of capacitated VRP, it is the maximum capacity of a vehicle(capacity and demands are to be of the same unit). It is the maximum total demand a vehicle can fulfil in it's route.
7-> "service_time_per_demand_unit" - It is the time required to satisfy a unit demand, i.e. if the node has a demand of 'x', then it will take a vehicle (servtime_per_demand*x) units of time to serve that node. It is '0' if the serive times of nodes are to be ignored in the time-constraint(time minimization)
8-> "time_windows" - A matrix ([nx2]) indicating the time windows for each node such that the node can only be serviced during that window. (can be NULL , if no time windows needed). If provided, then for any node that does not have a time-window constraint, this will have values, '0' and 'INT_MAX' for the row corresponding to that node.
9->	"speeds" - A matrix indicating the vehicle speeds. Options - 1.[1x1] matrix indicating a single avg. speed for all vehicles on all arcs. 2.NULL, if the transit times between the nodes are to be ignored, in the time minimization. 3.[nxn] matrix when the avg. speed of the vehicles is different between different nodes(different on differnt arcs). 
10->	"waiting_time" - Matrix indicating the waiting times, if any, at the nodes. Either NULL, if no waiting times(or they are ot be ignored during time minimization) or a [1xn] matrix.
11->	"refuel_flag" - flag indicating if fuel constraint is to be considered for the given VRP; 0-> NO fuel constraints ; 1-> fuel constraints to be considered( fuel consumption is minimized with vehicles having a fixed fuel capacity and certain specified refueling nodes only. Each transit costs fuel(here, equal to the distance covered as fuel is assumed to be specified in terms of the units of distance(mileage, is you will)
12->	"fuel_capacity_per_vehicle" - If fuel constraint is considered, this indicates the fuel capacity of a vehicle(same for all vehicles). Initially, the amount of fuel in each vehicle is equal to this value. Each transit deducts a corresponding amount of fuel from this value, unless the current node is a refuel node, in which case the fuel supply is replenished.
13->	"fuel_nodes" - Matrix specifying the refuel node indices(if fuel constraint is to be considered i.e. refuel_flag==1). Expected -vector [1xA] where A is the number of fuel nodes. Could also be an empty matrix(or NULL) even when fuel constraints are considered, indicating a situation where the fuel is limited but there are no refueling nodes.
14->	"skip_penalties" - an [Ax2] matrix specifying the node index(first column) and the corresponding cost penalty associated if that node were to be skipped( It basically marks that node as optional, albeit with a monetary penalty. This could be NULL if no penalty constraints are specified i.e. ALL NODES ARE MANDATORY!
15->	"groups" - Matrix specifying node groups such that nodes in the same group have to be serviced by the same vehicle i.e. they must lie on the same route.( [AxB] matrix where A is the number of groups and B is the number of nodes in the largest group. Smaller group rows are padded with 0's on the right end(as Scilab does not support variable length rows in matrices)
16->	"same_vehicle_penalty" - single numerical value specifying the cost penalty if a certain node in a predefined group(see above) is unable to be serviced by the same vehicle(or it ain't optimal to do so). If =-1, it indicates that all groups are strictly imposed ie. we cannot optionally skip a node from a group as a tradeoff to optimize distance and time.
17-> 	"time_limit" -  Time limit for the solver in milliseconds. It may or may not find a solution within the limit. If it does, it may not be the most optimal, but as optimal as the engine could optimize it within the limit given.( As it first finds a naive solution through a greedy strategy and then iteratively optimizes it heuristically toward an optimal solution)

NOTE:- All indices specified in the inputs(eg. in 'start' matrices are actually Scilab indices, i.e. starting with '1'. Pertinent adjustments to be made.


*/


/*
Naming suffixes(also, the respective order) for outputs :- 
1->Total Distance- single numeric value
2->Total Time - single numeric value
3->Distance Matrix- [1xv]
4->Time Matrix -[1xv]
5->Vehicle routes - [vxn] matrix. As route will always be less than or equal to 'n', the routes will be padded with 0's on the right end(node indices returned are Scilab Indices(start with 1) so, 0's are not a problem for padding)
6->status flag -The OR-Tools solution status (enum defined in 'routing.h')
*/




double *vrp_piVar1=NULL,*vrp_piVar2=NULL,*vrp_piVar3=NULL,*vrp_piVar4=NULL,*vrp_piVar5=NULL,*vrp_piVar6=NULL,*vrp_piVar7=NULL,*vrp_piVar8=NULL,*vrp_piVar9=NULL,*vrp_piVar10=NULL,*vrp_piVar11=NULL,*vrp_piVar12=NULL,*vrp_piVar13=NULL,*vrp_piVar14=NULL,*vrp_piVar15=NULL,*vrp_piVar16=NULL,*vrp_piVar17=NULL;
int nodes; //stores the number of nodes in the given graph(VRP)
int vehicles; //stores the number of vehicles/routes in the given VRP(input argument #2)
int mode_flag; //stores the mode flag value (input argument #3)

int **start=NULL;


int **adj_matrix=NULL;
int *demands=NULL;


long long max_vehicle_capacity;

long long service_time_per_demand_unit; 

const long long time_ub=INT_MAX;  //upper bound on the total time a route can take(INT_MAX and not int64-max as 'tis the max that we can receive from scilab). Also, taken max possible to actually forego imposing any such limiation as we are also minimizing the total time taken by the route apart from the distance(Adding variable moinimized by the finalizer), thus rendering it pointless


int **time_windows=NULL;   // [nx2] matrix, specifying the time windows for each node. If a node does not need a constraint of time windows, this has '0' for start time and 'INT_MAX' for end times(was input as '-1' but converted to INT_MAX before being fed to this gateway)

int *waiting_times=NULL;

int *fuel_nodes=NULL; //Depot nodes are NOT inehrently considered refuel nodes. THEY HAVE TO BE SPECIFIED IN THIS ARRAY IN ORDER TO BE CONSIDERED! [1xA] Vector expected(A-> number of refuel nodes)
int refuel_flag=0;  //0->No refuelling constraints; 1->Refuelling to be considered; This could be '1' and the fuel_nodes array could still be empty(NULL) indicating that there will be fuel constraints but NO REFUELLING NODES!!!!.
int fuel_capacity_per_vehicle; // Only specified when refuelling is to be considered.


int **penalty=NULL; // Ax2 matrix( A-> no. of optional nodes with some penalties for skipping them);  First column-> index of the optional node; Second column-> the corresponding penalty)

 // The speed variable is either a 1x1 matrix holding a single int value(avg.speed for all arcs) or an nxn matrix(double int pointer) when different speeds are speicified for different arcs
int **speeds=NULL;


int speeds_flag=0;  //0-> No speed specified 1-> single avg speed;  2-> different speeds for different arcs

int **groups=NULL;  //AxB matrix, where each row indicated a new group of nodes that need to be on the same vehicle route. Each element of this matrix needs to be unique and the total number of elements(A*B) cannot exceed the total number of node('nodes)

long long kSameVehiclePenalty=-1; //user input value- a penalty imposed if the nodes in a specified group cannot be put on the same route

int time_limit;

const char* kkTime = "Time";
const char* kkCapacity = "Capacity";
const char* kkFuel = "Fuel";


//distance callback 

long long distancecallback(RoutingModel::NodeIndex from,RoutingModel::NodeIndex to)
{

	return adj_matrix[from.value()][to.value()];
	
}


//negative distance callback(for refuelling mode)
long long negdistance(RoutingModel::NodeIndex from, RoutingModel::NodeIndex to)
{
	
	return adj_matrix[from.value()][to.value()]<0?adj_matrix[from.value()][to.value()]:-adj_matrix[from.value()][to.value()];  // return negative if the value is initially negative(indicating no edge)
	
}



int isRefuelNode(int n,int size)  //size-> number of values in the refuel_nodes array;   
{
	// This method returns 1(true) if the node with index 'n' if a refuel node
	
	for(int i=0;i<size;i++)
		if(n==vrp_piVar13[i])
			return 1;
	
	return 0;
}



//demand callback

long long demandscallback(RoutingModel::NodeIndex from, RoutingModel::NodeIndex to)
{
	return demands[from.value()];
}




//Time Callback  (gives us the service time plus the transition times); 3 cases tackled -> 1) When no speed is specified; 2)A single avg. speed is specified for all the edges/arcs ; 3) Separate avg. speeds are speeds are specified for each arc/edge of the given graph

long long timecallback(RoutingModel::NodeIndex from, RoutingModel::NodeIndex to)
{
	long long temp=0;
	
	if(demands!=NULL && service_time_per_demand_unit!=0)
		temp+=(service_time_per_demand_unit*demandscallback(from,to));
	
	
	if(speeds!=NULL)
	{
		if(speeds_flag==1)
			temp+=(distancecallback(from,to)/ (speeds[0][0]));
		else if(speeds_flag==2)
		{
			if(mode_flag==1)
				temp+=(distancecallback(from,to)/speeds[from.value()-1][to.value()-1]);  //accounting for the dummy node in mode '1'
			else
				temp+=(distancecallback(from,to)/speeds[from.value()][to.value()]);
		}
	}
	
	return temp;
}





int sci_vrp(char *fname)
{
	
	SciErr scierror;
	
	int iType1=0,iType2=0,iType3=0,iType4=0,iType5=0,iType6=0,iType7=0,iType8=0,iType9=0,iType10=0,iType11=0,iType12=0,iType13=0,iType14=0,iType15=0,iType16=0,iType17=0;
	
	int *piAddressVar1=NULL,*piAddressVar2=NULL,*piAddressVar3=NULL,*piAddressVar4=NULL,*piAddressVar5=NULL,*piAddressVar6=NULL,*piAddressVar7=NULL,*piAddressVar8=NULL,*piAddressVar9=NULL,*piAddressVar10=NULL,*piAddressVar11=NULL,*piAddressVar12=NULL,*piAddressVar13=NULL,*piAddressVar14=NULL,*piAddressVar15=NULL,*piAddressVar16=NULL,*piAddressVar17=NULL;
	
	int m1=0,m2=0,m3=0,m4=0,m5=0,m6=0,m7=0,m8=0,m9=0,m10=0,m11=0,m12=0,m13=0,m14=0,m15=0,m16=0,m17=0;
	int n1=0,n2=0,n3=0,n4=0,n5=0,n6=0,n7=0,n8=0,n9=0,n10=0,n11=0,n12=0,n13=0,n14=0,n15=0,n16=0,n17=0;
	
	int status;     //output #6
	
	CheckInputArgument(pvApiCtx,17,17);
	CheckOutputArgument(pvApiCtx,6,6);
	
	
	
	//GETTING THE ADDRESSES OF THE INPUT MATRICES
	
	
	
	
	
	
	scierror=getVarAddressFromPosition(pvApiCtx,1,&piAddressVar1);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarAddressFromPosition(pvApiCtx,2,&piAddressVar2);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarAddressFromPosition(pvApiCtx,3,&piAddressVar3);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarAddressFromPosition(pvApiCtx,4,&piAddressVar4);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarAddressFromPosition(pvApiCtx,5,&piAddressVar5);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarAddressFromPosition(pvApiCtx,6,&piAddressVar6);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarAddressFromPosition(pvApiCtx,7,&piAddressVar7);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarAddressFromPosition(pvApiCtx,8,&piAddressVar8);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarAddressFromPosition(pvApiCtx,9,&piAddressVar9);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarAddressFromPosition(pvApiCtx,10,&piAddressVar10);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarAddressFromPosition(pvApiCtx,11,&piAddressVar11);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarAddressFromPosition(pvApiCtx,12,&piAddressVar12);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarAddressFromPosition(pvApiCtx,13,&piAddressVar13);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarAddressFromPosition(pvApiCtx,14,&piAddressVar14);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarAddressFromPosition(pvApiCtx,15,&piAddressVar15);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarAddressFromPosition(pvApiCtx,16,&piAddressVar16);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarAddressFromPosition(pvApiCtx,17,&piAddressVar17);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	
	
	
	
	//RETRIEVING AND CHECKING THE TYPES OF THE INPUTS
	
	
	
	scierror=getVarType(pvApiCtx,piAddressVar1,&iType1);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarType(pvApiCtx,piAddressVar2,&iType2);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarType(pvApiCtx,piAddressVar3,&iType3);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarType(pvApiCtx,piAddressVar4,&iType4);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarType(pvApiCtx,piAddressVar5,&iType5);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarType(pvApiCtx,piAddressVar6,&iType6);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarType(pvApiCtx,piAddressVar7,&iType7);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarType(pvApiCtx,piAddressVar8,&iType8);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarType(pvApiCtx,piAddressVar9,&iType9);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarType(pvApiCtx,piAddressVar10,&iType10);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarType(pvApiCtx,piAddressVar11,&iType11);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarType(pvApiCtx,piAddressVar12,&iType12);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarType(pvApiCtx,piAddressVar13,&iType13);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarType(pvApiCtx,piAddressVar14,&iType14);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarType(pvApiCtx,piAddressVar15,&iType15);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarType(pvApiCtx,piAddressVar16,&iType16);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarType(pvApiCtx,piAddressVar17,&iType17);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	
	
	if(iType1!=sci_matrix || iType2!=sci_matrix || iType3!=sci_matrix || iType4!=sci_matrix || iType5!=sci_matrix || iType6!=sci_matrix || iType7!=sci_matrix || iType8!=sci_matrix || iType9!=sci_matrix || iType10!=sci_matrix || iType11!=sci_matrix || iType12!=sci_matrix || iType13!=sci_matrix || iType14!=sci_matrix || iType15!=sci_matrix || iType16!=sci_matrix|| iType17!=sci_matrix)
	{
		if(iType1!=sci_matrix)
			Scierror(999,"Wrong Input Type for Argument #1. Matrix Expected! \n");
		
		if(iType2!=sci_matrix)
			Scierror(999,"Wrong Input Type for Argument #2. Matrix Expected! \n");
		
		if(iType3!=sci_matrix)
			Scierror(999,"Wrong Input Type for Argument #3. Matrix Expected! \n");
		
		if(iType4!=sci_matrix)
			Scierror(999,"Wrong Input Type for Argument #4. Matrix Expected! \n");
		
		if(iType5!=sci_matrix)
			Scierror(999,"Wrong Input Type for Argument #5. Matrix Expected! \n");
		
		if(iType6!=sci_matrix)
			Scierror(999,"Wrong Input Type for Argument #6. Matrix Expected! \n");
		
		if(iType7!=sci_matrix)
			Scierror(999,"Wrong Input Type for Argument #7. Matrix Expected! \n");
		
		if(iType8!=sci_matrix)
			Scierror(999,"Wrong Input Type for Argument #8. Matrix Expected! \n");
		
		if(iType9!=sci_matrix)
			Scierror(999,"Wrong Input Type for Argument #9. Matrix Expected! \n");
		
		if(iType10!=sci_matrix)
			Scierror(999,"Wrong Input Type for Argument #10. Matrix Expected! \n");
		
		if(iType11!=sci_matrix)
			Scierror(999,"Wrong Input Type for Argument #11. Matrix Expected! \n");
		
		if(iType12!=sci_matrix)
			Scierror(999,"Wrong Input Type for Argument #12. Matrix Expected! \n");
		
		if(iType13!=sci_matrix)
			Scierror(999,"Wrong Input Type for Argument #13. Matrix Expected! \n");
		
		if(iType14!=sci_matrix)
			Scierror(999,"Wrong Input Type for Argument #14. Matrix Expected! \n");
		
		if(iType15!=sci_matrix)
			Scierror(999,"Wrong Input Type for Argument #15. Matrix Expected! \n");
		
		if(iType16!=sci_matrix)
			Scierror(999,"Wrong Input Type for Argument #16. Matrix Expected! \n");
		
		if(iType17!=sci_matrix)
			Scierror(999,"Wrong Input Type for Argument #16. Matrix Expected! \n");
		
		return 0;

	}
	
	
	
	//GETTING THE ACTUAL INPUT MATRICES
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar1,&m1,&n1,&vrp_piVar1);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar2,&m2,&n2,&vrp_piVar2);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar3,&m3,&n3,&vrp_piVar3);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar4,&m4,&n4,&vrp_piVar4);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar5,&m5,&n5,&vrp_piVar5);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar6,&m6,&n6,&vrp_piVar6);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar7,&m7,&n7,&vrp_piVar7);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar8,&m8,&n8,&vrp_piVar8);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar9,&m9,&n9,&vrp_piVar9);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar10,&m10,&n10,&vrp_piVar10);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar11,&m11,&n11,&vrp_piVar11);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar12,&m12,&n12,&vrp_piVar12);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar13,&m13,&n13,&vrp_piVar13);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar14,&m14,&n14,&vrp_piVar14);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar15,&m15,&n15,&vrp_piVar15);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar16,&m16,&n16,&vrp_piVar16);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar17,&m17,&n17,&vrp_piVar17);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	
	
	
	
	//////--------------------------LOGIC-------------------------------/////////
	
	
	
	//assignments
	
	RoutingModel *routing; //Will store the RoutingModel Object later
	
	vehicles=vrp_piVar2[0];
	mode_flag=vrp_piVar3[0];
	nodes=m1;
	
	if(mode_flag!=1)
	{
		start=(int **)malloc(sizeof(int *)*m4);

		for(int i=0;i<m4;i++)
			start[i]=(int *)malloc(sizeof(int)*n4);

		for(int i=0;i<m4;i++)
			for(int j=0;j<n4;j++)
				start[i][j]=vrp_piVar4[j*m4+i];
	}
	
	max_vehicle_capacity=vrp_piVar6[0];
	
	
	if(m7!=0)
	service_time_per_demand_unit=vrp_piVar7[0];
	
	
	if(m8!=0)
	{
		time_windows=(int **)malloc(sizeof(int *)*m8);
		
		for(int i=0;i<m8;i++)
		{
			time_windows[i]=(int *)malloc(sizeof(int)*2);
			time_windows[i][0]=vrp_piVar8[i];
			time_windows[i][1]=vrp_piVar8[m8+i];
		}
		
	}
	
	
	if(m9!=0)
	{
		speeds=(int **)malloc(sizeof(int *)*m9);
		
		for(int i=0;i<m9;i++)
			speeds[i]=(int *)malloc(sizeof(int)*n9); 
		
		for(int i=0;i<m9;i++)
			for(int j=0;j<n9;j++)
				speeds[i][j]=vrp_piVar9[j*m9+i];
		
	}
	
	if(m10!=0)
	{
		
		waiting_times=(int *)malloc(sizeof(int)*n10); //n10 will be equal to the number of nodes
		
		for(int i=0;i<n10;i++)
			waiting_times[i]=vrp_piVar10[i];
		
	}
	

	if(m11!=0)
	refuel_flag=vrp_piVar11[0];
	
		
		
	fuel_capacity_per_vehicle=vrp_piVar12[0];
	
	
	
	if(refuel_flag)
	{
		
		if(m13!=0)
		{
			fuel_nodes=(int *)malloc(sizeof(int)*n13);
			
			for(int i=0;i<n13;i++)
				fuel_nodes[i]=vrp_piVar13[i];
		}
		
	}
	
	if(m14!=0)
	{
		penalty=(int **)malloc(sizeof(int *)*m14);
		
		for(int i=0;i<m14;i++)
		{
			penalty[i]=(int *)malloc(sizeof(int)*2);
			
			penalty[i][0]=vrp_piVar14[i];
			penalty[i][1]=vrp_piVar14[m14+i];
		}
		
	}
	
	
	
	if(m15!=0)
	{
		groups=(int **)malloc(sizeof(int *)*m15);
		
		for(int i=0;i<m15;i++)
			groups[i]=(int *)malloc(sizeof(int)*n15);
		
		
		for(int i=0;i<m15;i++)
			for(int j=0;j<n15;j++)
				groups[i][j]=vrp_piVar15[j*m15+i];
		
	}
	
	kSameVehiclePenalty=vrp_piVar16[0];
	
	time_limit=vrp_piVar17[0];
	
	
	
	
	int total_distance=0;   // will be needed if penalties are provided
	
	for(int i=0;i<(m1*n1);i++)
		if(vrp_piVar5[i]>0)  // as it could be negative as well- to be ignored
		total_distance+=vrp_piVar5[i];
	
	
	
	
	
	std::vector< std::pair<RoutingModel::NodeIndex,RoutingModel::NodeIndex> > start_end;  // needed for mode '2'
	
	
	
	if(mode_flag==0)
	{
		
		const RoutingModel::NodeIndex kDepot(start[0][0]-1); // subtract 1 to get the C++ index from the Scilab index
		
		
		adj_matrix=(int **)malloc(sizeof(int *)*nodes);
		
		if(m5!=0)
		demands=(int *)malloc(sizeof(int)*nodes);

		
		
		for(int i=0;i<nodes;i++)
		{
			adj_matrix[i]=(int *)malloc(sizeof(int)*nodes);
			if(m5!=0)
				demands[i]=vrp_piVar5[i];
		}
		
		
		for(int i=0;i<nodes;i++)
			for(int j=0;j<nodes;j++)
				adj_matrix[i][j]=vrp_piVar1[j*m1+i];
			
		routing = new RoutingModel(nodes,vehicles,kDepot);
		
		
		
		

		
	}
	else if(mode_flag==1)  //taxi mode; Dummy node to be added
	{
		adj_matrix=(int **)malloc(sizeof(int *)*(nodes+1));
		
		for(int i=0;i<=nodes;i++)
		{
			adj_matrix[i]=(int *)malloc(sizeof(int)*(nodes+1));
			
			for(int j=0;j<=nodes;j++)
			{
				if(i==0 || j==0)
					adj_matrix[i][j]=0;
				else
					adj_matrix[i][j]=vrp_piVar1[(j-1)*m1+(i-1)];

			}
			
		}
					
		//demand matrix also needs to be adjusted, if specified
		
		if(m5!=0)
		{
			demands=(int *)malloc(sizeof(int)*(nodes+1));

			demands[0]=0;

			for(int i=1;i<=nodes;i++)
			demands[i]=vrp_piVar5[i-1];

		}
		
		
		const RoutingModel::NodeIndex kDepot(0);
		
		routing = new RoutingModel(nodes+1,vehicles,kDepot);	
		
		
	}
	else  //fixed start and end nodes for routes
	{
		//start matrix is of size [vx2]
		
		
		adj_matrix=(int **)malloc(sizeof(int *)*nodes);
		
		if(m5!=0)
		demands=(int *)malloc(sizeof(int)*nodes);

		
		
		for(int i=0;i<nodes;i++)
		{
			adj_matrix[i]=(int *)malloc(sizeof(int)*nodes);
			if(m5!=0)
				demands[i]=vrp_piVar5[i];
		}
		
		
		for(int i=0;i<nodes;i++)
			for(int j=0;j<nodes;j++)
				adj_matrix[i][j]=vrp_piVar1[j*m1+i];
		
		
		
		for(int i=0;i<vehicles;i++)
			start_end.push_back(std::pair<RoutingModel::NodeIndex,RoutingModel::NodeIndex>(RoutingModel::NodeIndex(start[i][0]-1),RoutingModel::NodeIndex(start[i][1]-1)));
		
		
		routing= new RoutingModel(nodes,vehicles,start_end);	
		
		
	}
	
	
	RoutingSearchParameters parameters=BuildSearchParametersFromFlags();
		
	parameters.set_first_solution_strategy(FirstSolutionStrategy::PATH_CHEAPEST_ARC);
	parameters.mutable_local_search_operators()->set_use_path_lns(false);
	
	if(m17!=0)
		parameters.set_time_limit_ms(time_limit);
	
	

	
	//Setting the distance function
	
	routing->SetArcCostEvaluatorOfAllVehicles(NewPermanentCallback(distancecallback));
	

	//Adding group constraints for sets of nodes to be on the same route(servicesd by the same vehicle)
	
	
	if(groups!=NULL)
	{
		//indices given in the groups array are scvilab indices(start with 0). Pertinent Adjustment to be made if mode<>2
		
		int x=sizeof(groups)/sizeof(groups[0]);  //no. of rows i.e. the no. of groups
		int y= sizeof(groups[0])/sizeof(int);  // no. of columns. (different groups can be different sizes, but all padded with zeroes to equalize the number of columns)
		
		//normalizing and converting the given SameVehiclePenalty into a relative distance penalty value to be congrous with the 'distance interpretation' of our minimization model
		
		int count;
		
		
		for(int i=0;i<x;i++)
			for(int j=0;j<y;j++)
				if(groups[i][j]!=0)
					count++;
		
		if(kSameVehiclePenalty!=0)
			kSameVehiclePenalty=(kSameVehiclePenalty/(count*kSameVehiclePenalty))*total_distance;
		
		
		
		for(int i=0;i<x;i++)
		{
			std::vector<RoutingModel::NodeIndex> group;
			for(int j=0;j<y;j++)
				if(groups[i][j]!=0)
				{
					const RoutingModel::NodeIndex temp(mode_flag==1?groups[i][j]:(groups[i][j]-1));
					group.push_back(temp);
				}
					
			
			if(kSameVehiclePenalty == 0)
				routing->AddSoftSameVehicleConstraint(group,0);
			else if(kSameVehiclePenalty > 0)
				routing->AddSoftSameVehicleConstraint(group,kSameVehiclePenalty);
					
					
					
		}
		
	}
	
	
	//setting the speed flag
	
	if(speeds!=NULL)
	{
		//if(sizeof(speeds)==sizeof(int))  //single avg. speed case
		if(m9==1 && n9==1) 
			speeds_flag=1;
		else speeds_flag=2;
	}
	
	
	
	//Adding the capacity dimension constraints
	if(demands!=NULL)
	{
		const long long kNullCapacitySlack=0;

		routing->AddDimension(NewPermanentCallback(demandscallback),kNullCapacitySlack, max_vehicle_capacity, /* fix_start_cumul_to_zero */ true, kkCapacity);

		const RoutingDimension& capacity_dimension = routing->GetDimensionOrDie(kkCapacity);
	}
	
	
	
	//Adding Time Dimension constraints
	
	routing->AddDimension(NewPermanentCallback(timecallback),time_ub,time_ub,true, kkTime);
	
	const RoutingDimension& time_dimension=routing->GetDimensionOrDie(kkTime);
	
	
	
	//Adding time windows
	
	if(time_windows!=NULL)
	{
		if(mode_flag==1)
		{
			time_dimension.CumulVar(0)->SetRange(0,INT_MAX);
			for(int i=1;i<=nodes;i++)
				time_dimension.CumulVar(i)->SetRange(time_windows[i-1][0],time_windows[i-1][1]);
		}
		else
		{
			for(int i=1;i<nodes;i++)
				time_dimension.CumulVar(i)->SetRange(time_windows[i][0],time_windows[i][1]);
		}
			
		
		
	}


	//Adding Waiting Times
	
	if(waiting_times!=NULL)
	{
		if(mode_flag==1)
		{
			
			time_dimension.SlackVar(0)->SetValue(0);
			for(int i=1;i<=nodes;i++)
				time_dimension.SlackVar(i)->SetValue(waiting_times[i-1]);
		}
		else
		{
			for(int i=0;i<nodes;i++)
				time_dimension.SlackVar(i)->SetValue(waiting_times[i]);
		}
		
	}
	
	
	
	
	int num_penalty=m14;
	
	//converting the penalty values into relative distance values to be germane to the interpretation of our model that minimizes distance
	
	if(penalty!=NULL)
	{
		
		int total_penalty=0;
		
		for(int i=0;i<num_penalty;i++)
			total_penalty+=penalty[i][1];
		
		if(total_penalty != 0)
		for(int i=0;i<num_penalty;i++)
			penalty[i][1]=penalty[i][1]*total_distance/total_penalty;
		
		
	
	
	
		//Adding penalty values to allow skipping of orders

		for(int i=0;i<num_penalty;i++)
		{
			RoutingModel::NodeIndex temp(mode_flag==1?penalty[i][0]:(penalty[i][0]-1));
			std::vector<RoutingModel::NodeIndex> optnode(1,temp);
			routing->AddDisjunction(optnode,penalty[i][1]);
		}
		
	}
	
	
	
	
	//Adding Refuelling parameters
	//Depots are NOT assumed to be fuel nodes by default.
	
	if(refuel_flag)
	{
		int fsize=0; //number of refuel nodes
		
		if(fuel_nodes!=NULL)
			fsize=n13;
		
		
		routing->AddDimension(NewPermanentCallback(negdistance),fuel_capacity_per_vehicle,fuel_capacity_per_vehicle, /*fix_start_cumul_to_zero*/false,kkFuel);
		
		const RoutingDimension& fuel_dimension=routing->GetDimensionOrDie(kkFuel);
		
		for(int i=1;i<=nodes;i++)  // As the 'fuel_nodes' array contains the SCILAB INDICES for the nodes
		{
			if(mode_flag==1)
			{
				if(!isRefuelNode(i,fsize))
					fuel_dimension.SlackVar(i)->SetValue(0);

				routing->AddVariableMinimizedByFinalizer(fuel_dimension.CumulVar(i));
			}
			else
			{
				if(!isRefuelNode(i,fsize))
					fuel_dimension.SlackVar(i-1)->SetValue(0);
				
				routing->AddVariableMinimizedByFinalizer(fuel_dimension.CumulVar(i-1));
			}
														
			
		}
		
		//sciprint("Slack - %d\n",fuel_dimension.SlackVar(1));
		//sciprint("Cumul - %d\n",fuel_dimension.CumulVar(1));
	
							 
							 
	}
	
	
	
	//Solving the Model
	
	//status=routing->status();
	//sciprint("Status - %d\n",status);
	
	const Assignment * solution= routing->SolveWithParameters(parameters);
	
	
	status=routing->status();
	
	
	if(solution==nullptr) // portends one of 3 situations viz. status(enum) values -> ROUTING_FAIL(no solution possible/found) ,  ROUTING_FAIL_TIMEOUT or ROUTING_INVALID(not possible in TSP as default parameters used for initialization)
	{
		scierror=createMatrixOfInteger32(pvApiCtx, nbInputArgument(pvApiCtx)+1,0,0,NULL);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		scierror=createMatrixOfInteger32(pvApiCtx, nbInputArgument(pvApiCtx)+2,0,0,NULL);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		scierror=createMatrixOfInteger32(pvApiCtx, nbInputArgument(pvApiCtx)+3,0,0,NULL);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;scierror=createMatrixOfInteger32(pvApiCtx, nbInputArgument(pvApiCtx)+1,0,0,NULL);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		}
		
		scierror=createMatrixOfInteger32(pvApiCtx, nbInputArgument(pvApiCtx)+4,0,0,NULL);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		scierror=createMatrixOfInteger32(pvApiCtx, nbInputArgument(pvApiCtx)+5,0,0,NULL);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		
		scierror=createMatrixOfInteger32(pvApiCtx,nbInputArgument(pvApiCtx)+6,1,1,&status);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		
	}
	else  //solution found!
	{
		int total_time=0;  //output #2
		
		int total_distance=solution->ObjectiveValue();  //output #1
		
		int *distances=(int *)malloc(sizeof(int)*vehicles); //output #3
		int *times=(int *)malloc(sizeof(int)*vehicles); //output #4
		
		std::fill(distances,distances+sizeof(distances),0);
		std::fill(times,times+sizeof(times),0);
		
		
		int **routes=(int **)malloc(sizeof(int *)*vehicles);  //[vxn] matrix   ; output #5 ; Will have to converted to single dimensional array before mapping
		
		
		
		for(int i=0;i<vehicles;i++)
		{
			
			routes[i]=(int *)malloc(sizeof(int)*nodes);
			 
			
			
			if(mode_flag==1)
			{
				int j=0;
				
				for(int node=solution->Value(routing->NextVar(routing->Start(i)));!routing->IsEnd(node);node=solution->Value(routing->NextVar(node)),j++)  //skipping the first node(dummy)
				{
					routes[i][j]=routing->IndexToNode(node).value();  // Scilab indices(start with '1') as dummy node '0' was added
					if(j!=0)
					{
						distances[i]+=distancecallback(RoutingModel::NodeIndex(routes[i][j-1]),RoutingModel::NodeIndex(routes[i][j]));
						times[i]+=timecallback(RoutingModel::NodeIndex(routes[i][j-1]),RoutingModel::NodeIndex(routes[i][j]));
					}
					
				}
				
				//padding with zeroes
				for(int k=j;k<nodes;k++)
					routes[i][k]=0;
				
				//std::fill causes memory issues with scilab, hence not used
					
				
				//also skipping the last node(dummy)

				
				
			}
			
			else
			{
				int j=0;
				
				for(int node=routing->Start(i);!routing->IsEnd(node);node=solution->Value(routing->NextVar(node)),j++)
				{
					routes[i][j]=(routing->IndexToNode(node).value()) +1;  // '1' to be added to convert to the Scilab index convention(starting with '1')
					
					if(j!=0)
					{
						distances[i]+=distancecallback(RoutingModel::NodeIndex(routes[i][j-1]-1),RoutingModel::NodeIndex(routes[i][j]-1));
						times[i]+=timecallback(RoutingModel::NodeIndex(routes[i][j-1]-1),RoutingModel::NodeIndex(routes[i][j]-1));
					}

				
					
				}
							
				//mapping the last node
				routes[i][j]=(routing->IndexToNode(routing->End(i)).value()) +1;
				
				//sciprint("\n\n\n Last :- %d\n\n\n",routes[i][j]);
				
				
				//padding with zeroes
				for(int k=j+1;k<nodes;k++)
					routes[i][k]=0;
				
				//std::fill causes memory issues with scilab, hence not used
				
				
				distances[i]+=distancecallback(RoutingModel::NodeIndex(routes[i][j-1]-1),RoutingModel::NodeIndex(routes[i][j]-1));
				times[i]+=timecallback(RoutingModel::NodeIndex(routes[i][j-1]-1),RoutingModel::NodeIndex(routes[i][j]-1));
							
				
			}
			
			total_time+=times[i];
			
		}

		

		/*
		for(int i=0;i<vehicles;i++)
		{
			for(int j=0;j<nodes;j++)
				sciprint("%d ",routes[i][j]);
			
			sciprint("\n");
			
		}
		*/
			
		//converting the 'routes' matrix to a linear array/vector(column major)
			
		int *sciroutes=(int *)malloc(sizeof(int)*vehicles*nodes);
		
		for(int i=0;i<vehicles;i++)
			for(int j=0;j<nodes;j++)
				sciroutes[j*vehicles+i]=routes[i][j];
		
		
		
		scierror=createMatrixOfInteger32(pvApiCtx,nbInputArgument(pvApiCtx)+1,1,1,&total_distance);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		scierror=createMatrixOfInteger32(pvApiCtx,nbInputArgument(pvApiCtx)+2,vehicles,nodes,sciroutes);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		
		scierror=createMatrixOfInteger32(pvApiCtx,nbInputArgument(pvApiCtx)+3,1,vehicles,distances);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		scierror=createMatrixOfInteger32(pvApiCtx,nbInputArgument(pvApiCtx)+4,1,1,&total_time);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		
		
		scierror=createMatrixOfInteger32(pvApiCtx,nbInputArgument(pvApiCtx)+5,1,vehicles,times);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		
		
		
		scierror=createMatrixOfInteger32(pvApiCtx,nbInputArgument(pvApiCtx)+6,1,1,&status);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
			
		
		
	}
	
	
		AssignOutputVariable(pvApiCtx,1)=nbInputArgument(pvApiCtx)+1;
		AssignOutputVariable(pvApiCtx,2)=nbInputArgument(pvApiCtx)+2;
		AssignOutputVariable(pvApiCtx,3)=nbInputArgument(pvApiCtx)+3;
		AssignOutputVariable(pvApiCtx,4)=nbInputArgument(pvApiCtx)+4;
		AssignOutputVariable(pvApiCtx,5)=nbInputArgument(pvApiCtx)+5;
		AssignOutputVariable(pvApiCtx,6)=nbInputArgument(pvApiCtx)+6;
	

	

	delete routing;
	
	
	return 0;
}
	
}