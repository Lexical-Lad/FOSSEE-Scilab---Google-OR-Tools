#include "ortools/base/commandlineflags.h"
#include "ortools/base/commandlineflags.h"
#include "ortools/base/integral_types.h"
#include "ortools/base/logging.h"
#include "ortools/base/join.h"
#include "ortools/base/stringprintf.h"
#include "ortools/constraint_solver/constraint_solver.h"

extern "C" {

#include <stdlib.h>
#include <vector>
#include <limits.h>
#include <memory>
#include <localization.h>
#include <Scierror.h>
#include <api_scilab.h>
#include <sciprint.h>


using namespace operations_research;



/*
Naming suffixes(also, the respective order) for inputs :- 

1->	"machines" -> Number of machines in the problem, on which the various tasks in the given jobs are to be scheduled.
2->	"jobs" ->Number of jobs in the problem. Each job consists of one or more tasks that are to be scheduled on the various machines. The tasks have certain ordering constraints that they have to follow(if mode is '0', all tasks follow a sequetial order, ie. task 1 must occur before task '2' can start adn so on. For mode '1', however, order ain't linear by default. Each task is given 2 task indices, first corresponding to the task only after whose completion, the task in question can start and the second idnex corresponding to the task which cannot start before the task in question ends.
3-> "mode" -> 0/1 values; 0-> sequential mode-  All taks must occur in sequence, i.e. task 1 must end before task 2 can start and so on for all tasks WITHIN THE JOB in question. 1-> parallel mode - Some tasks can occur parallelly, or completely independent of each other. 2 additional constrains need to be specified for each task in this mode viz.(say, the task in question is 'x') one being the task after whose end 'x' can start and the other being the task which can only occur after 'x' has ended.('-1' if the corresponding restriction is not imposed, i.e. if the task can start whenever, the we give '-1' for the first argument.
4-> "tasks" -> The matrix containing details of all the tasks. Say, the number of tasks is 'A'. For mode '0' 'tis a [Ax3] matrix and for mode '1' 'tis a [Ax5] matrix. The first 3 columns are common to both cases. The 5 columns are - 'job_index' , 'machine_index', 'task_duration', 'start_after','end_before', in that ORDER. The last 2 are only applicable for mode '1'.
5->	"time_limit" -> The user-specified upper bound in milliseconds for which the solver will run. Solution obviously ain't guaranteed. Default value is 10000(10s). This value has to be greater than 0.

*/

/*
Naming suffixes(also, the respective order) for outputs :- 
1->"makespan" -> The total time taken to complete all the tasks, in the optimal solution, should one exist
2->"schedule" -> A schedule matrix [Ax5] (A- number of tasks). The first 3 columns are the same as in 'tasks' matrix in the inputs. The last two indicate the start and end times for the respective tasks, in the optimal solution, should one be found.
3->"status" -> 0->Solved. 1-> timed out. 2->problem infeasible.

*/



struct TTask {
    TTask(int j, int m, int d) : job_id(j), machine_id(m), duration(d) {}
    int job_id;
    int machine_id;
    int duration;
  };


int **tasks=NULL;

int machines;
int jobs;
int mode;







int sci_jssp(char *fname)	
{
	
	
	int time_limit= 10000; //default - 10s
	
	SciErr scierror;
	
	int iType1=0, iType2=0, iType3=0, iType4=0, iType5=0;
	
	int *piAddressVar1=NULL, *piAddressVar2=NULL, *piAddressVar3=NULL, *piAddressVar4=NULL, *piAddressVar5=NULL;
	
	double *jssp_piVar1=NULL, *jssp_piVar2=NULL, *jssp_piVar3=NULL, *jssp_piVar4=NULL, *jssp_piVar5=NULL;
	
	int m1=0,n1=0,m2=0,n2=0,m3=0,n3=0,m4=0,n4=0,m5=0,n5=0;
	
	int status;   //output #3
	
	
	int num_tasks;

	
	CheckInputArgument(pvApiCtx,5,5);
	CheckOutputArgument(pvApiCtx,3,3);
	
	
	//GETTING THE ADDRESSES OF THE INPUT MATRICES
	
	
	scierror = getVarAddressFromPosition(pvApiCtx,1,&piAddressVar1);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror = getVarAddressFromPosition(pvApiCtx,2,&piAddressVar2);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror = getVarAddressFromPosition(pvApiCtx,3,&piAddressVar3);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror = getVarAddressFromPosition(pvApiCtx,4,&piAddressVar4);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror = getVarAddressFromPosition(pvApiCtx,5,&piAddressVar5);
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
	
	
	
	
	if(iType1!=sci_matrix || iType2!=sci_matrix || iType3!=sci_matrix || iType4!=sci_matrix || iType5!=sci_matrix)
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
		
		return 0;
		
	}
	
	
	
	
	
	//GETTING THE ACTUAL INPUT MATRICES
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar1,&m1,&n1,&jssp_piVar1);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar2,&m2,&n2,&jssp_piVar2);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar3,&m3,&n3,&jssp_piVar3);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar4,&m4,&n4,&jssp_piVar4);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	scierror=getMatrixOfDouble(pvApiCtx,piAddressVar5,&m5,&n5,&jssp_piVar5);
	if(scierror.iErr)
	{
		printError(&scierror,0);
		return 0;
	}
	
	
	
	//////--------------------------LOGIC-------------------------------/////////
	
	
	
	//assignments
	
	num_tasks = m4;
	
	machines = jssp_piVar1[0];
	jobs = jssp_piVar2[0];
	
	mode = jssp_piVar3[0];
	
	if( m5!=0)
		time_limit = jssp_piVar5[0];
	
	
	
	// constructing the 'tasks' matrix
	
	tasks=(int **)malloc(sizeof(int*)*num_tasks);
	
	if( mode==0)
	{
		
		for(int i=0;i<num_tasks;i++)
		{
			tasks[i]=(int *) malloc(sizeof(int)*3);
			
			tasks[i][0]= jssp_piVar4[i] -1;   //Subtracting '1' to convert the scilab indices(starting from '1') to C++ indices(starting from '0')
			tasks[i][1]= jssp_piVar4[num_tasks+i] -1; //Subtracting '1' to convert the scilab indices(starting from '1') to C++ indices(starting from '0')
			tasks[i][2]= jssp_piVar4[num_tasks*2 + i];
		}
		
	}
	else
	{
		
		for(int i=0;i<num_tasks;i++)
		{
			tasks[i]=(int *)malloc(sizeof(int)*5);
			
			tasks[i][0]= jssp_piVar4[i]-1;   //Subtracting '1' to convert the scilab indices(starting from '1') to C++ indices(starting from '0')
			tasks[i][1]= jssp_piVar4[num_tasks+i]-1; //Subtracting '1' to convert the scilab indices(starting from '1') to C++ indices(starting from '0')
			tasks[i][2]= jssp_piVar4[num_tasks*2 + i];
			tasks[i][3]= jssp_piVar4[num_tasks*3 + i]-1; //Subtracting '1' to convert the scilab indices(starting from '1') to C++ indices(starting from '0')
			tasks[i][4]= jssp_piVar4[num_tasks*4 + i]-1; //Subtracting '1' to convert the scilab indices(starting from '1') to C++ indices(starting from '0')
			
		}
		
	}
	
	int horizon=0; //Will store the sum of durations for all the tasks ( consequently acting as a trivial upper bound for the makespan; also used to define the upper bound for the scheduling range for each interval variable)
	
	std::vector<std::vector<TTask> > alltasks(jobs);
	
	for(int i=0;i<num_tasks;i++)
	{
		alltasks[tasks[i][0]].push_back(TTask(tasks[i][0], tasks[i][1], tasks[i][2]));
		
		horizon+=tasks[i][2];
	}
	
	
	
	std::vector< std::vector<IntervalVar*> > jobs_to_tasks(jobs);
	std::vector< std::vector<IntervalVar*> > machines_to_tasks(machines);
	
	
	
	
	//Creating the solver
	
	Solver solver("Job-Shop");
	
	
	
	//Creating the interval variables
	
	int absindex=-1;
	
	for(int i=0;i<jobs;i++)
	{
		int task_index=-1;
		
		for(int j=0;j<alltasks[i].size();j++)
		{
			const TTask& task = alltasks[i][j];
			
			const std::string name = StringPrintf("%d;%d;%d",++absindex, task.job_id, ++task_index);
			
			IntervalVar* const intervalVar = solver.MakeFixedDurationIntervalVar( 0 , horizon, task.duration, false, name);
			
			jobs_to_tasks[task.job_id].push_back(intervalVar);
			machines_to_tasks[task.machine_id].push_back(intervalVar);
			
		}
		
	}
	
	
	
	//Creating precedence among the tasks within each job (Conjunctive Constraints)
	
	if(mode == 0)
	{
		
		for(int i=0; i<jobs; i++)
		{
			int temp=jobs_to_tasks[i].size();
			
			for(int j=0;j<temp-1;j++)
			{
				IntervalVar* const t1= jobs_to_tasks[i][j];
				IntervalVar* const t2= jobs_to_tasks[i][j+1];

				Constraint* const precedence = solver.MakeIntervalVarRelation(t2, Solver::STARTS_AFTER_END, t1);

				solver.AddConstraint(precedence);

			}
		
		}
		
	}
	else
	{
		
		for(int i=0;i<jobs;i++)
		{
			
			int temp=jobs_to_tasks[i].size();
			
			for(int j=0;j<temp;j++)
			{
				
				IntervalVar* const t1 = jobs_to_tasks[i][j];
				
				
				std::istringstream ss(t1->name());
				std::string token;
				
				std::getline(ss, token, ';');
				
				int ind = std::stoi(token);  //This is the index corresponding to the task (row) in the 'tasks' matrix
				

				if(tasks[ind][3] !=-1)
				{
					IntervalVar* const t2 = jobs_to_tasks[i][tasks[ind][3]];
					
					Constraint* const precedence = solver.MakeIntervalVarRelation(t1, Solver::STARTS_AFTER_END, t2);
					
					solver.AddConstraint(precedence);
				}
				
				if(tasks[ind][4]!=-1)
				{
					IntervalVar* const t2 = jobs_to_tasks[i][tasks[ind][4]];
					
					Constraint* const precedence  =solver.MakeIntervalVarRelation( t2, Solver::STARTS_AFTER_END, t1);
				
					solver.AddConstraint(precedence);
					
				}
				
			}
		}
		
	}
	
	
	
	//Creating the disjunctive constrains(NO tasks on the same machine can overlap)
	//These constraints are stored in Sequence Variables - a separate sequence variable to be defined for each sequence constraint. So, in our model, no. of sequence variables = No. of Machines.
	
	std::vector <SequenceVar*> sequences;
	
	for(int i=0;i<machines;i++)
	{
		const std::string name = StringPrintf("machine_%d",i);
		
		DisjunctiveConstraint* const dc= solver.MakeDisjunctiveConstraint(machines_to_tasks[i],name);
		
		solver.AddConstraint(dc);
		
		sequences.push_back(dc->MakeSequenceVar());
		
	}
	
	
	//Creating a vector of End-time expressions(and casting them into Interval Variables) for the various jobs( only the logically last tasks in each job are needed to generate this expression(to minimize) as the various tasks within the same job are already constrained by precendence.
	//This vector is then fed to the solver
	
	std::vector <IntVar*> ends;
	
	for(int i=0; i<jobs; i++)
	{
		int temp = jobs_to_tasks[i].size();
		
		
		if(mode ==0)
		{
			IntervalVar* const task = jobs_to_tasks[i][temp-1];  // here, the logically last task in a job will obviously be the one with the latest end_time
			
			ends.push_back(task->EndExpr()->Var());		
			
		}
		else   //in this case, we cannot be sure which will be  last job in the job. So, we simply add all the potential tasks(those with 'end_before' values equal to '-1') to the 'ends' vector. Later on, the solver will pick the one with the latest end-time among these to minimize the same, for that particular solution
		{
			
			for(int j=0;j<temp;j++)
			{
				IntervalVar* const task = jobs_to_tasks[i][j];
				
				std::istringstream ss(task->name());
				
				std::string token;
				
				std::getline(ss,token, ';');
				
				int ind = std::stoi(token);
				
				if( tasks[ind][4]==-1)
					ends.push_back(task->EndExpr()->Var());
				
			}
					
			
			
		}
		
	}
	
	
	
	//Setting the objective for the solver
	
	IntVar* const objective_var = solver.MakeMax(ends)->Var();  //Basically, we single out the Maximum of all the end times for the jobs, for each solution - this is actually equal to the makespan for that solution and then feed THIS as the objective variable to be minimized across all the solutions.
	
	OptimizeVar* const objective_monitor = solver.MakeMinimize(objective_var, 1);
	
	
	//Creating the Decision builder. Two decision builders, one to rank the tasks and one to minimize the objective variable, will be created. Then, one Min decion builder will be made to "compose" the decision builder tree, over these 2 decision builders
	
	DecisionBuilder* const sequence_phase = solver.MakePhase(sequences, Solver::SEQUENCE_DEFAULT);
	
	DecisionBuilder* const obj_phase = solver.MakePhase(objective_var, Solver::CHOOSE_FIRST_UNBOUND, Solver::ASSIGN_MIN_VALUE);
	
	// The main decision builder (ranks all tasks, then fixes the objective_variable)
	
	DecisionBuilder* const main_phase = solver.Compose( sequence_phase, obj_phase);
	
	
	
	
	//Setting the time limit
	
	SearchLimit* limit = nullptr;
	
	limit = solver.MakeTimeLimit(time_limit);
	
	
	
	
	//Defining the solution collectors
	
	SolutionCollector* const collector = solver.MakeLastSolutionCollector();
	
	collector->Add(sequences);
	
	collector->AddObjective(objective_var);
	
	
	
	//adding the start and end times for each task( machine-wise) to the solution collector
	
	for(int i=0; i<machines; i++)
	{
		
		int temp = sequences[i]->size();
		
		for(int j=0; j<temp; j++)
		{
			IntervalVar* const ss = sequences[i]->Interval(j);
			
			collector->Add(ss->StartExpr()->Var());
			collector->Add(ss->EndExpr()->Var());
			
		}
		
	}
	
	
	
	//Solving and returning values
	
	
	//the solve() function returns true if a solution is obtained. It returns false if our model times out before we obtain a soluion.
	
	if(solver.Solve(main_phase, objective_monitor, limit, collector))   
	{
		//solution found
		
		int status = 0 ; //output #3
		
		int makespan = collector->objective_value(0);
		
		int **schedule = (int **) malloc(sizeof(int*)*num_tasks);
		
		sciprint("Optimal Solution Found!\n");
		
		sciprint("Optimal Makespan : %d\n", makespan);
		
		
		
		for(int i=0; i<num_tasks; i++)
		{
			schedule[i]=(int *)malloc(sizeof(int)*5);
			
			//populating the first 3 columns as they are identical to the input 'tasks' matrix
			
			schedule[i][0] = tasks[i][0] + 1; //converting back to scilab indices
			schedule[i][1] = tasks[i][1] + 1;
			schedule[i][2] = tasks[i][2];
			
		}
		
		//displaying the machine-wise schedule and populating the remaining 2 columns of the output 'schedule' matrix
		
		sciprint("Optimal Schedule(machine-wise)  :- \n");
		
		
		
		for(int i=0; i<machines; i++)
		{
			SequenceVar* const seq = sequences[i];
			
			
			sciprint(seq->name().c_str());
			sciprint(":\t");
			
			std::vector<int> sequence = collector ->ForwardSequence(0,seq);
			
			
			for(int j=0; j<sequence.size()-1; j++)
			{
				IntervalVar* const temp = seq->Interval(sequence[j]); //the integral representation of 'temp->name()' will give us the index of the task in the respective job(ie. if a job has 4 tasks, indexing for it will go from 0 to 3)
				
				std::istringstream ss(temp->name());
				
				std::string token; 
				
				std::getline(ss,token,';');
				
				
				int ind = std::stoi(token);
				
				schedule[ind][3]= collector->Value(0, temp->StartExpr()->Var());
				schedule[ind][4]= collector->Value(0, temp->EndExpr()->Var());
				
				
				std::getline(ss,token,';');	
				sciprint("Job- %d, ",std::stoi(token) +1);
				
				std::getline(ss,token,';');
				sciprint("Task- %d",std::stoi(token) +1);
				
				sciprint("[%d, %d]\t",schedule[ind][3],schedule[ind][4]);
				
				
			}
			
			IntervalVar* const temp = seq->Interval(sequence.back());
			
			
			std::istringstream ss (temp->name());
			
			std::string token;
			
			std::getline(ss,token, ';');
			
			int ind = std::stoi(token);
			
			schedule[ind][3] = collector->Value(0, temp->StartExpr()->Var());
			schedule[ind][4] = collector->Value(0, temp->EndExpr()->Var());
			
			std::getline(ss, token, ';');
			sciprint("Job- %d, ",std::stoi(token) +1);
			
			std::getline(ss, token, ';');
			sciprint("Task- %d",std::stoi(token) +1);
			
			
			sciprint("[%d, %d]\n",schedule[ind][3],schedule[ind][4]);
			
		}
			
		
		//converting 'schedule' to a linear array (column major)
		
		int *scischedule = (int *)malloc(sizeof(int)*num_tasks*5);
		
		for(int i=0;i<num_tasks;i++)
		{
			for(int j=0;j<5;j++)
				scischedule[j*num_tasks + i] = schedule[i][j];
		}
		
		
		//creating the outputs
		
		scierror = createMatrixOfInteger32(pvApiCtx, nbInputArgument(pvApiCtx)+1,1,1,&makespan);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		
		scierror = createMatrixOfInteger32(pvApiCtx, nbInputArgument(pvApiCtx)+2,num_tasks, 5, scischedule);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		scierror = createMatrixOfInteger32(pvApiCtx, nbInputArgument(pvApiCtx)+3, 1,1, &status);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		
		sciprint("\n");
		
		for(int i=0; i<num_tasks;i++)
		free(schedule[i]);
	

		free(schedule);



		for(int i=0; i<num_tasks; i++)
			free(tasks[i]);

		free(tasks);

		free(scischedule);
		
	}
	else  //no solution found
	{
		
		
		status = solver.state();
		
		if(status == Solver::PROBLEM_INFEASIBLE)
		{
			status = 2;
			sciprint("PROBLEM_INFEASIBLE - No solution could be found for the given problem!\n");
			
		}
		else 
		{
			status = 1;
			sciprint("TIMED_OUT - The time limit for the model was reached. Try providing a higher value for the limit, if the problem allows.\n");

		}
		
		
		
		scierror = createMatrixOfInteger32(pvApiCtx, nbInputArgument(pvApiCtx)+1,0,0, NULL);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;

		}
		
		
		scierror = createMatrixOfInteger32(pvApiCtx, nbInputArgument(pvApiCtx)+2, 0,0,NULL);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		
		scierror = createMatrixOfInteger32(pvApiCtx, nbInputArgument(pvApiCtx)+3,1,1,&status);
		if(scierror.iErr)
		{
			printError(&scierror,0);
			return 0;
		}
		
		
	}
	
	
	
	
	AssignOutputVariable(pvApiCtx,1) = nbInputArgument(pvApiCtx)+1;
	AssignOutputVariable(pvApiCtx,2) = nbInputArgument(pvApiCtx)+2;
	AssignOutputVariable(pvApiCtx,3) = nbInputArgument(pvApiCtx)+3;
	
	
	
	
	return 0;
	
}
	
}