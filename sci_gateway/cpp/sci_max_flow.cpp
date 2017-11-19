#include "ortools/graph/max_flow.h"
extern "C" {
#include <stdlib.h>
#include <localization.h>
#include <Scierror.h>
#include <api_scilab.h>
#include <sciprint.h>

using namespace operations_research;

int sci_max_flow(char *fname) //error check to check if values exceed 32 bit ints, before passing ????
{
	SciErr scierror;
	
	int iType1=0;
	int iType2=0;
	int iType3=0;
	int iType4=0;
	
	int m1=0,n1=0,m2=0,n2=0,m3=0,n3=0,m4=0,n4=0;
	
	double *pdVarOne=NULL,*pdVarTwo=NULL,*pdVarThree=NULL,*pdVarFour=NULL;
	int *piAddressVarOne=NULL,*piAddressVarTwo=NULL,*piAddressVarThree=NULL,*piAddressVarFour=NULL;
	
	
	int *pdblReal1; //actually FlowQuantity(enum value for int64); int used owing to no 64-bit support in scilab yet
	int *pdblReal2; 
	
	//CheckRhs(4,4);
	//CheckLhs(0,2);
	
	CheckInputArgument(pvApiCtx,4,4);
	CheckOutputArgument(pvApiCtx,3,3);
	
	//Getting Addresses of the input matrices
	
	scierror=getVarAddressFromPosition(pvApiCtx,1,&piAddressVarOne);
	
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarAddressFromPosition(pvApiCtx,2,&piAddressVarTwo);
	
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarAddressFromPosition(pvApiCtx,3,&piAddressVarThree);
	
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getVarAddressFromPosition(pvApiCtx,4,&piAddressVarFour);
	
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	
	//Getting the input types and checking if they are matrices
	
	scierror=getVarType(pvApiCtx,piAddressVarOne,&iType1);
	
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
		
	}
	
	if(iType1!=sci_matrix)
	{
		
		Scierror(999,"%s : Wrong input argument type for argument #%d. Try Again!\n ",fname,1);
				 
		return 0;
	}
	
	scierror=getVarType(pvApiCtx,piAddressVarTwo,&iType2);
	
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	if(iType2!=sci_matrix)
	{
		Scierror(999,"%s : Wrong input argument type for argument #%d. Try Again!\n",fname,2);
		
		return 0;
	}
	
	scierror=getVarType(pvApiCtx,piAddressVarThree,&iType3);
	
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
		
	}
	
	if(iType1!=sci_matrix)
	{
		
		Scierror(999,"%s : Wrong input argument type for argument #%d. Try Again!\n ",fname,3);
				 
		return 0;
	}
	
	scierror=getVarType(pvApiCtx,piAddressVarFour,&iType4);
	
	if(scierror.iErr)
	{
		Scierror(999,"%s : Wrong input argument type for argument #%d. Try Again!\n",fname,4);
		return 0;
	}
	
	
	
	//Getting the actual matrices

	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVarOne,&m1,&n1,&pdVarOne);
	
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
		
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVarTwo,&m2,&n2,&pdVarTwo);
	
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return  0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVarThree,&m3,&n3,&pdVarThree);
	
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return  0;
	}
	
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVarFour,&m4,&n4,&pdVarFour);
	
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	
	
	if((m1!=1)||(m2!=1)||(m3!=1)||(n1!=n2)||(n1!=n3)) //The three matrices need to be vectors(only one row) and must have the same size
	{
		Scierror(787,"Invalid Input(s)\n");
		return 0;
	}
	
	
	
	
	//pdVarOne   ->array of start/tail nodes
	//pdVarTwo   ->array of end/head nodes
	//pdVarThree ->array of capacities(corresponding to the arc index
	//pdVarFour	 ->array(1x2) containing the indices of the source and destination nodes
	
	
	
	
	SimpleMaxFlow smf;
	SimpleMaxFlow::Status stat;
	ArcIndex arcIndex=0;
	
	for(int i=0;i<n1;i++)
		arcIndex=smf.AddArcWithCapacity(pdVarOne[i],pdVarTwo[i],pdVarThree[i]);
	
	
	/*if(pdVarFour[0]>=smf.NumNodes())
	{
		Scierror(788,"Invalid Source Index!\n");
		return 0;
	}
	
	if(pdVarFour[1]>=smf.NumNodes())
	{
		Scierror(788,"Invalid Destination Index!\n");
		return 0;
	}*/
	
	
	int eflag=0,sflag=0;
	
	for(int i=0;(i<smf.NumArcs()) && ((sflag==0)||(eflag==0));i++)
	{
		
		if((sflag==0)&&(pdVarOne[i]==pdVarFour[0]))
			sflag=1;
		
		if((eflag==0)&&(pdVarTwo[i]==pdVarFour[1]))
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
		
	
	
	stat=smf.Solve(pdVarFour[0],pdVarFour[1]);

	int status_=stat;
	
	
	//pdblReal1 ->stores the max flow(1x1 matrix)
	//pdblReal2 ->stores the flow for each arc in the optimal solution
	
	
	//scierror=allocMatrixOfDouble(pvApiCtx,nbInputArgument(pvApiCtx)+1,1,1,&pdblReal1);
	//scierror=allocMatrixOfDouble(pvApiCtx,nbInputArgument(pvApiCtx)+2,1,n1,&pdblReal2);
	
	pdblReal1=(int *)malloc(sizeof(int));
	
	*pdblReal1=smf.OptimalFlow();
	
	scierror=createMatrixOfInteger32(pvApiCtx,nbInputArgument(pvApiCtx)+1,1,1,pdblReal1);	
	
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	
	
	pdblReal2=(int *)malloc(sizeof(int)*smf.NumArcs());
	
	for(int i=0;i<smf.NumArcs();i++)
		pdblReal2[i]=smf.Flow(i);
	
	
	scierror=createMatrixOfInteger32(pvApiCtx,nbInputArgument(pvApiCtx)+2,1,n1,pdblReal2);
	
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	
	scierror=createMatrixOfInteger32(pvApiCtx,nbInputArgument(pvApiCtx)+3,1,1,&status_);
	
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	
	
	sciprint("Max flow = %d\n",smf.OptimalFlow());  //sciprint("Max flow = %lld\n",smf.OptimalFlow());
	sciprint("Arc\tFlow\tCapacity\n");
	
	for(int i=0;i<smf.NumArcs();i++)
		sciprint("%d->%d\t%d\t%d\n",smf.Tail(i),smf.Head(i),smf.Flow(i),smf.Capacity(i));  //sciprint("%d->%d\t%lld\t%lld\n",smf.Tail(i),smf.Head(i),smf.Flow(i),smf.Capacity(i));
	
	
	//LhsVar(1)=5;
	//LhsVar(2)=6;
	
	AssignOutputVariable(pvApiCtx,1)=nbInputArgument(pvApiCtx)+1;
	AssignOutputVariable(pvApiCtx,2)=nbInputArgument(pvApiCtx)+2;
	AssignOutputVariable(pvApiCtx,3)=nbInputArgument(pvApiCtx)+3;
	
	
	//ReturnArguments(pvApiCtx);
	
	
	
	return 0;
	
	
	
}
}

/*using namespace operations_research;
int main()
{
	int start_nodes[] = {0, 0, 0, 1, 1, 2, 2, 3, 3};
  	int end_nodes[] = {1, 2, 3, 2, 4, 3, 4, 2, 4};
 	int capacities []= {20, 30, 10, 40, 30, 10, 20, 5, 20};
	
	SimpleMaxFlow smf;
	SimpleMaxFlow::Status stat;
	ArcIndex arcIndex=0;
		
	int n=9;
	
	for(int i=0;i<n;i++)
	{
		arcIndex= smf.AddArcWithCapacity(start_nodes[i],end_nodes[i],capacities[i]);
		printf("%d\n",arcIndex);
	}
	
	stat=smf.Solve(0,4);
	
	printf("Max flow = %d\n",smf.OptimalFlow());
	
	printf("Arc\tFlow\tCapacity\n");
	
	for(int i=0;i<smf.NumArcs();i++)
		printf("%d->%d\t%d\t%d\n",smf.Tail(i),smf.Head(i),smf.Flow(i),smf.Capacity(i));
	
	return 0;
	
	
}*/
	
	
	