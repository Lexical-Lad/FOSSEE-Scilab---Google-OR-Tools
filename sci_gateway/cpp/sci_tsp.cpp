#include "ortools/base/callback.h"
#include "ortools/base/commandlineflags.h"
#include "ortools/base/commandlineflags.h"
#include "ortools/base/integral_types.h"
#include "ortools/base/join.h"
#include "ortools/base/join.h"
#include "ortools/constraint_solver/routing.h"
#include "ortools/constraint_solver/routing_enums.pb.h"
#include "ortools/constraint_solver/routing_flags.h"



extern "C"{
#include <memory>
#include <stdlib.h>
#include <localization.h>
#include <Scierror.h>
#include <api_scilab.h>
#include <sciprint.h>


using namespace operations_research;





/*
Naming suffixes(also, the respective order) for inputs :- 
1-> The adjacency matrix representing the graph(The cell values are the costs associated with the respective edge defined by  (row index)->(column index) )  cost values>=0. Negative cost values simply mean 'no edge' i.e. no edge connects node 'i' to node 'j'(u-> row index; j-> column index)
2-> The index of the start node i.e the node from which the travelling salesman starts his journey(and also where the journey is to end)
3-> The time_limit for the solver(in milliseconds).
*/


/*
Naming suffixes(also, the respective order) for outputs :- 
1-> The total path cost(for the optimal route) (integral)
2-> The actual optimal path( as a [1xn] integral matrix(vector) where n is the number of tsp_nodes+1(as the starting node is included twice, once at the start and once at the end.
3-> The OR-Tools solution status (enum defined in 'routing.h')
*/


double *tsp_piVar1=NULL,*tsp_piVar2=NULL,*tsp_piVar3=NULL;
int tsp_nodes; // stores the number of tsp_nodes in the specified graph




long long matrixIndex(RoutingModel::NodeIndex from, RoutingModel::NodeIndex to)
{
	return (to*tsp_nodes+from).value();  // As scilab stores matrices in Column-Major format
} 
	
	
long long distance(RoutingModel::NodeIndex from, RoutingModel::NodeIndex to)
{
	
	return tsp_piVar1[matrixIndex(from,to)];
	
	
}




int sci_tsp(char *fname)
{
	
	SciErr scierror;
	
	int iType1=0,iType2=0,iType3=0;
	
	int *piAddressVar1=NULL,*piAddressVar2=NULL,*piAddressVar3=NULL;
	int m1=0,n1=0,m2=0,n2=0,m3=0,n3=0;
	
	int *piReal1=NULL,*piReal2=NULL,*piReal3=NULL;
	int status;
	
	int time_limit;
	
	
	CheckInputArgument(pvApiCtx,3,3);
	CheckOutputArgument(pvApiCtx,3,3);
	
	
	//GETTING THE ADDRESSES OF THE INPUT MATRICES
	
	
	//first input matrix(adjacency matrix)
	
	scierror=getVarAddressFromPosition(pvApiCtx,1,&piAddressVar1);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	
	//second input matrix([1x1] containing the index of the start node("depot"))
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
	
	if(iType1!=sci_matrix||iType2!=sci_matrix||iType3!=sci_matrix)
	{
		if(iType1!=sci_matrix)
			Scierror(999,"Wrong Input Type for Argument #1. Matrix Expected! \n");
		
		if(iType2!=sci_matrix)
			Scierror(999,"Wrong Input Type for Argument #2. Matric Expected! \n");
		
		if(iType3!=sci_matrix)
			Scierror(999,"Wrong Input Type for Argument #3. Matric Expected! \n");
		
		return 0;
	}
	
	
	
	//GETTING THE ACTUAL INPUT MATRICES
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar1,&m1,&n1,&tsp_piVar1);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar2,&m2,&n2,&tsp_piVar2);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar3,&m3,&n3,&tsp_piVar3);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	
	//the adjacency matrix has to be a square matrix. Checking for the same
	
	if(m1!=n1)
	{
		Scierror(787,"Invalid/Erroneous Adjacency matrix size. Adjacency matrices need to be square matrices.\n");
		return 0;
	}
	
	
	
	//Checking if the second input argument is a singular value(1x1 matrix)
	
	if(m2!=1||n2!=1)
	{
		Scierror(789,"Wrong input #2! Required- A singlular value for the index of the start-node(the node where the salesman begins his journey) \n");
		return 0;
		
	}
	
	
	
	//Checking if the 'start-node' index value is valid(existent in the adjacency matrix)
	
	if(tsp_piVar2[0]>=m1)
	{
		Scierror(791,"Invalid input #2! The index value for the 'start-node' doesn't exist in the given graph(The tsp_nodes are indexed from '0' to 'n-1'(n->no. of tsp_nodes, say). (Start-node index) < n \n");
		return 0;
	}
	
	
	if(m3!=0)
		time_limit = tsp_piVar3[0];
	else
		time_limit = 1000;
	
	tsp_nodes=m1; //  no. of tsp_nodes in the graph
	
	
	
	//Initializing the Routing Model for TSP(default parameters and the specified starting node)
	
	RoutingModel routing(tsp_nodes,1,RoutingModel::NodeIndex(tsp_piVar2[0]));
	
	RoutingSearchParameters parameters=BuildSearchParametersFromFlags();
	parameters.set_first_solution_strategy(FirstSolutionStrategy::PATH_CHEAPEST_ARC);
	
	routing.SetArcCostEvaluatorOfAllVehicles(NewPermanentCallback(distance));
	
	
	parameters.set_time_limit_ms(time_limit);
	
	
	//checking for proper initialization of the model
	
	if((status=routing.status())!=0)
	{
		Scierror(801,"Error initializing the Routing model\n");
		
		scierror=createMatrixOfInteger32(pvApiCtx,nbInputArgument(pvApiCtx)+1,0,0,piReal1);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		scierror=createMatrixOfInteger32(pvApiCtx,nbInputArgument(pvApiCtx)+2,0,0,piReal2);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		scierror=createMatrixOfInteger32(pvApiCtx,nbInputArgument(pvApiCtx)+3,1,1,&status);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		AssignOutputVariable(pvApiCtx,1)=nbInputArgument(pvApiCtx)+1;
		AssignOutputVariable(pvApiCtx,2)=nbInputArgument(pvApiCtx)+2;
		AssignOutputVariable(pvApiCtx,3)=nbInputArgument(pvApiCtx)+3;
		
		
		return 0;
		
		
		
	}
	
	//Solving the model
	
	const Assignment* solution=routing.SolveWithParameters(parameters);
	
	status=routing.status();
	
	
	if(solution==nullptr) // portends one of 3 situations viz. status(enum) values -> ROUTING_FAIL(no solution possible/found) ,  ROUTING_FAIL_TIMEOUT or ROUTING_INVALID(not possible in TSP as default parameters used for initialization)
	{
		
		
		//piReal1=(int *)malloc(0);
		
		
		scierror=createMatrixOfInteger32(pvApiCtx,nbInputArgument(pvApiCtx)+1,0,0,piReal1);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		scierror=createMatrixOfInteger32(pvApiCtx,nbInputArgument(pvApiCtx)+2,0,0,piReal2);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		scierror=createMatrixOfInteger32(pvApiCtx,nbInputArgument(pvApiCtx)+3,1,1,&status);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		AssignOutputVariable(pvApiCtx,1)=nbInputArgument(pvApiCtx)+1;
		AssignOutputVariable(pvApiCtx,2)=nbInputArgument(pvApiCtx)+2;
		AssignOutputVariable(pvApiCtx,3)=nbInputArgument(pvApiCtx)+3;
		
		
		return 0;
		
		// pertinent errors and their messages will be handled by the macro based on the status value
	}
	else // solution found
	{
		
		
		piReal1=(int *)malloc(sizeof(int));
		piReal2=(int *)malloc(sizeof(int)*(m1+1));
		
		piReal1[0]=solution->ObjectiveValue();
		
		int i=0;
		
		
		for(int node=routing.Start(0);!routing.IsEnd(node);node=solution->Value(routing.NextVar(node)), i++)
			piReal2[i]=routing.IndexToNode(node).value();
		
		piReal2[i]=routing.IndexToNode(routing.End(0)).value();
		
		scierror=createMatrixOfInteger32(pvApiCtx,nbInputArgument(pvApiCtx)+1,1,1,piReal1);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		scierror=createMatrixOfInteger32(pvApiCtx,nbInputArgument(pvApiCtx)+2,1,(m1+1),piReal2);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		scierror=createMatrixOfInteger32(pvApiCtx,nbInputArgument(pvApiCtx)+3,1,1,&status);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		
		AssignOutputVariable(pvApiCtx,1)=nbInputArgument(pvApiCtx)+1;
		AssignOutputVariable(pvApiCtx,2)=nbInputArgument(pvApiCtx)+2;
		AssignOutputVariable(pvApiCtx,3)=nbInputArgument(pvApiCtx)+3;
		
		return 0;
	}
																		
		
	
	
}
}



