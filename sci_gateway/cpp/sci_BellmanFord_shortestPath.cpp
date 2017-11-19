#include "ortools/graph/shortestpaths.h"
extern "C"{
#include <stdlib.h>
#include <localization.h>
#include <Scierror.h>
#include <api_scilab.h>
#include <sciprint.h>
#include <limits.h>
#include <vector>

using namespace operations_research;

/*
Naming suffixes(also, the respective order) for inputs :-
1->tails/start_nodes
2->heads/end_nodes
3->weights(for the arc head[i]->tail[i]
4->[source,target]
5->user-defined value for disconnected-distance(default is INT_MAX)
6->0/1 value indicating if output(messages and shortest path, if it exists) is to be displayed or not, i.e. 0->internal test(obscured from the user); 1-> user test, pertinent outputs expected.
*/

/*

Naming suffixes(also, the respective order) for outputs :-
1->The minimun cost incurrred in reaching the end node(following the shortest path); NULL if the start and end nodes are not connection
2->The vector containing the shortest path from the start to the end node. empty vector if the start and end nodes are not connected

*/

double *sp_piVar1=NULL,*sp_piVar2=NULL,*sp_piVar3=NULL,*sp_piVar4=NULL,*sp_piVar5=NULL, *sp_piVar6=NULL;
int sp_num_arcs;
int disconnected_distance=INT_MAX;


long long retrieve(int u, int v) // Returns the weight corresponding to the arc going from node u(tail) to node v(head). IF MORE THAN ONE ARCS JOINING THE SAME 2 NODES, THIS FUNCTION RETURNS THE SMALLER OF THE 2 WEIGHTS
{
	int temp=INT_MIN;
	int flag=0;
	
	for(int i=0;i<sp_num_arcs;i++)
		if((sp_piVar1[i]==u) && (sp_piVar2[i]==v) && (sp_piVar3[i]>temp))
		{
			temp=sp_piVar3[i];
			flag=1;
		}
		
	if(flag)
		return temp;
	else
		return disconnected_distance;
	
}


int sci_BellmanFord_shortestPath(char *fname)
{
	
	SciErr scierror;
	
	int iType1=0,iType2=0,iType3=0,iType4=0,iType5=0,iType6=0;
	
	int m1=0,n1=0,m2=0,n2=0,m3=0,n3=0,m4=0,n4=0,m5=0,n5=0,m6=0,n6=0;
	
	
	int *piAddressVar1=NULL,*piAddressVar2=NULL,*piAddressVar3=NULL,*piAddressVar4=NULL,*piAddressVar5=NULL,*piAddressVar6=NULL;
	
	double *piReal1=NULL;
	int *piReal2=NULL;
	int flag;
	
	
	int start_node;
	int end_node;
	
	
	std::vector<int> nodes;
	
	
	CheckInputArgument(pvApiCtx,6,6);
	CheckOutputArgument(pvApiCtx,3,3);
	
	
	
	//	GETTING ADDRESSES OF THE INPUT MATRICES

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
	
		
	
	
	//GETTING AND CHECKING THE TYPES OF THE INPUT MATRICES
	
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
	
	
	if(iType1!=sci_matrix ||iType2!=sci_matrix ||iType3!=sci_matrix ||iType4!=sci_matrix ||iType5!=sci_matrix||iType6!=sci_matrix)
	{
		
		if(iType1!=sci_matrix)
		Scierror(999,"Wrong Input Type for Argument #1. Matrix Expected.\n");
		
		if(iType2!=sci_matrix)
		Scierror(999,"Wrong Input Type for Argument #2. Matrix Expected.\n");
		
		if(iType3!=sci_matrix)
		Scierror(999,"Wrong Input Type for Argument #3. Matrix Expected.\n");
		
		
		if(iType4!=sci_matrix)
		Scierror(999,"Wrong Input Type for Argument #4. Matrix Expected.\n");
		
		if(iType5!=sci_matrix)
		Scierror(999,"Wrong Input Type for Argument #5. Matrix Expected.\n");
		
		if(iType6!=sci_matrix)
		Scierror(999,"Wrong Input Type for Argument #6. Matrix Expected.\n");
		
		return 0;
	}
	
		
	//GETTING ACTUAL MATRICES
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar1,&m1,&n1,&sp_piVar1);
	
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar2,&m2,&n2,&sp_piVar2);
	
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar3,&m3,&n3,&sp_piVar3);
	
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar4,&m4,&n4,&sp_piVar4);
	
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar5,&m5,&n5,&sp_piVar5);
	
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar6,&m6,&n6,&sp_piVar6);
	
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	
	//checking if the first 3 inputs are indeed 1-d arrays(in 1xn matrix form)
	
	if((m1!=1)||(m2!=1)||(m3!=1))
	{
		Scierror(787,"Invalid Input(s)! The graph needs to be in the form of 3 arrays(1xn Matrices), viz tail[],head[],weight[]\n");
		return 0;
	}
	
	//checking if the size of the 3 matrices describing the graph is equal
	
	if(n1!=n2||n1!=n3)
	{
		Scierror(788,"Wrong Input(s)! The input graph is erroneous. The three matrcies describing the graph aren't of the same size\n");
		return 0;
	}
	
	//checking if the start node and end node values are of the correct form(1x2 matrix)
	
	if(m4!=1||n4!=2)
	{
		
		Scierror(789,"Wrong Input #4! Required- a 1x2 matrix containing 2 values viz. the source and target nodes, in that order\n");		
		return 0;
		
	}
	
	
	//checking if the specified value for disconnected-distance is a 1x1 matrix(singular value)
	if(m5!=1||n5!=1)
	{
		Scierror(789,"Wrong Input #5! Required - a singular value(integral) for the 'disconnected-distance'(i.e. any arcs/edges with weigths >=disconnected-distance are ignored i.e. no path. \n");
		return 0;
	}
	
	
	
	//no check needed for argument 6 as it ain't a user provided value
	
	
	sp_num_arcs=n1;
	start_node=sp_piVar4[0];
	end_node=sp_piVar4[1];
	disconnected_distance=sp_piVar5[0];
	
	int abstraction=sp_piVar6[0];
	
	
	
	int sflag=0;
	int eflag=0;
	
	//checking if the start node and end node values are valid(i.e. nodes corresponding to these values do indeed exist in the given graph or not)
	
	for(int i=0;(i<sp_num_arcs) && ((sflag==0) || (eflag==0));i++)
	{
		if((sflag==0)&&(sp_piVar1[i]==start_node))
			sflag=1;
		
		if((eflag==0)&&(sp_piVar2[i]==end_node))
		   eflag=1;
		
	}
	
	if(!sflag)
	{
		Scierror(790,"Invalid start node value.(specified node doesn't exist in the given graph)\n");
		return 0;
	}
	
	if(!eflag)
	{
		Scierror(790,"Invalid end node value.(specified node doesn't exist in the given graph)\n");
		return 0;
	}
		  
		
	
	flag=BellmanFordShortestPath(sp_num_arcs,start_node,end_node,retrieve,disconnected_distance, &nodes);
	
	if(!flag)
	{
		if(abstraction)
		sciprint("No path connecting start-node: %d and end-node=: %d.\n",start_node,end_node);		
	
		return 1;
	}
	
	if(abstraction)
	sciprint("\nShortest path from start-node:%d to end-node:%d is :\n",start_node,end_node);
	
	
	piReal1=(double *)malloc(sizeof(double));
	piReal2=(int *)malloc(sizeof(int)*nodes.size());
	
	double cost=0.0;
	
	
	if(abstraction)  // Skipping over the path and cost display for internal tests(only to produce more specific outputs when 'disconnected_distance' obscures some paths
	sciprint("%d",nodes.back());
	
	piReal2[0]=nodes.at(nodes.size()-1);
	
	if(abstraction)
	{
		for(int i=nodes.size()-2;i>=0;i--)
		{
			sciprint(" -> %d", nodes.at(i));
			cost+=retrieve(nodes.at(i+1),nodes.at(i));
			piReal2[nodes.size()-i-1]=nodes.at(i);
		}

		sciprint("\n");

		sciprint("Minumum cost (using the said path) :- %f\n",(piReal1[0]=cost));
	}
	
	
	
	scierror=createMatrixOfDouble(pvApiCtx,nbInputArgument(pvApiCtx)+1,1,1,piReal1);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=createMatrixOfInteger32(pvApiCtx,nbInputArgument(pvApiCtx)+2,1,nodes.size(),piReal2);
	
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=createMatrixOfInteger32(pvApiCtx,nbInputArgument(pvApiCtx)+3,1,1,&flag);
	
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	
	
	
	AssignOutputVariable(pvApiCtx,1)=nbInputArgument(pvApiCtx)+1;
	AssignOutputVariable(pvApiCtx,2)=nbInputArgument(pvApiCtx)+2;
	AssignOutputVariable(pvApiCtx,3)=nbInputArgument(pvApiCtx)+3;
	
}
	
}
	
	
	
	
	