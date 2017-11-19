function [makespan, schedule, status] = jssp(varargin)
	//Solves the popular 'Job-Shop Scheduling Problem' (JSSP for short), which aims to find an optimal plan to schedule a given number of jobs, each composed of one or more tasks to be performed in some specific logical order, on a given number of machines. The routine makes use of the 'constraint-solver' library from the Google OR-Tools framework.
	//
	//Calling Sequence
	//[makespan,schedule] = jssp(machines, jobs, jmode, tasks)
	//[makespan, schedule] = jssp(machines, jobs, jmode, tasks, time_limit)
	//[makespan, schedule, status] = jssp(machines, jobs, jmode, tasks)
	//[makespan, schedule, status] = jssp(machines, jobs, jmode, tasks, time_limit)
	//
	//Parameters
	//
	//machines : It is a single integral value specifying the total number of machines in the problem, on which the various tasks are to be scheduled.
	//jobs : It is a single integral value  specifying the total number of jobs in the problem. Each job is composed of one or more tasks which are to be scheduled on specific machines, in some logical order.
	//mode : It is a single intergral value (either '0' or '1' only). It specifies one of the two modes for the solver, which are :-<itemizedlist><listitem>0-> Sequential - In this mode, the various tasks within a job are considered to be sequentially constrained i.e. task_1 must occur before task_2, task_2 before task_3 and so on.</listitem><listitem>1-> Parallel - This mode allows the flexibility of some tasks being scheduled parallelly or independently of each other, if such a scenario is to be modelled. Eg. if a task 'x' can be performed any time after task_1 but must be performed before task_10. It requires 2 additional fields in the 'tasks' matrix, specifying 2 tasks (indices) between which the current task can be freely scheduled. One or both of these bounds can be done away with(no 'start_after' or 'end_before' constraints) by providing '-1' for the respective field.(These indices are the task indices WITHIN the job, ie.each job will have a task indexed '1', dor instance).</listitem></itemizedlist>
	//tasks : It is an [AxB] matrix( A- total number of tasks in the problem. B- 3 or 5 depending on the mode). Each row corresponds to a task. The two variations are :-<itemizedlist><listitem>mode '0' -> An [Ax3] matrix. The 3 fields/columns are 'Job-Index', 'Machine-Index' and 'Task-Duration'. (The tasks for each job are ordered internally in the order they appear in this matrix)</listitem><listitem>mode '1' -> An [Ax5] matrix. The 5 fields/columns are 'Job-Index, 'Machine-Index', 'Task-Duration', 'Start-After' and 'End-Before'. (order of the tasks doesn't matter in this case)</listitem></itemizedlist><latex>\text{}\\\text{}\\\\</latex>More on the columns (let the current task(row) be 'x')<itemizedlist><listitem>'job-index' -> It is the index of the job to which 'x' belongs.</listitem><listitem>'machine-index' -> It is the index of the machine on which 'x' is to be scheduled.</listitem><listitem>'task-duration' -> It is the time required to perform 'x'.</listitem><latex>\text{}\\\text{}\\\\</latex>Only for mode '1' -<listitem>'start-after' -> It is the index of the task, only after whose completion, 'x' can start.</listitem><listitem>'end-before' -> It is the index of the task that can only start once 'x' is completed.</listitem></itemizedlist>
	//time_limit : It is the  maximum time (in milliseconds; integral value) for which the solver is allowed to run. If a solution is not found by then, a pertinent 'timed-out' error occurs.(Default Value - 10 seconds). Provide an empty matrix or omit the parameter if explicit time-limit is not required.
	//makespan : It is the total duration of the schedule in the optimal solution, if one exists.
	//schedule : Is is an [Ax5] matrix (A- no. of tasks) that gives the final schedule for the various tasks in the optimal solution, if one exists. The 5 fields/columns are  'Job-index', 'machine-index', 'task-duration', 'start-time' and 'end-time'. 
	//status : Is is an integral value representing the status of the solution as:<itemizedlist><listitem> '0'-> 'Solution Found'</listitem><listitem> '1'-> 'Timed-out' - No solution was found within the specified/default time limit.</listitem><listitem> '2'-> 'Problem-Infeasible' - No solution exists for the given problem.</listitem></itemizedlist>
	//Description
	//<latex>
	//\text{The Job-Shop Scheduling Problem (also called the \textbf{Resource Scheduling Problem}) is a linear optimization problem in Computer Science and Operations Research which vies to schedule a number of jobs, each composed of one or more tasks, on a specific number of machines, minimizing the total time for the enite schedule, called the \textbf{makespan}.\\The order in which the various tasks in a job are performed and the machines on which they must be scheduled are received as inputs.\\This particular implementation supports two variations :}\\
	//\text{}\\
	//\text{1. \textbf{`Sequential Mode'}(mode 0) : In this mode, all the tasks in a job are considered to be sequentially constrained ie. task 2 cannot occur before task 1 finishes, and so on.}\\
	//\text{2. \textbf{`Parallel/Arbitrary Mode'}(mode 1) : In this mode, tasks within a job can occur parallelly ie. the order is arbitrary sans 2 \textbf{optional bounds}. \\These 2 ``bound'' values are specified for each task. They are :}\\
	//\qquad\text{ - \textbf{`start-after'} : This is the index of the task that must finish before the current task can start}\\
	//\qquad\text{ - \textbf{`end-before'} :  This is the index of the task that cannot start before the current task finishes}\\
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
	//\text{Let } M = \{M_{1}, M_{2},..., M_{m}\} \text{ and} \\
	//\text{Let } J = \{J_{1}, J_{2},..., J_{j}\} \quad \text{be 2 finite sites representing the machines and the jobs respectively. }\\\\
	//\end{math}
	//\text{(the tasks are abstracted for simplicity. So whenever a Job is scheduled on a machine, it is assumed, the next task to be performed is the one scheduled).}\\\\
	//\begin{math}
	//\text{Let } X \text{ denote the set of assignment of all jobs on the machines}\\\\
	//\text{Let } C \text{ be the \textbf{`cost function'} such that :}\\
	//\text{}\\
	//C:X \to [0, \infty^{+}] \quad \text{; which denotes the total processing time ie. makespan of schedule.}\\\\
	//\textbf{\underline{Objective} :}\qquad \text{ To find an assignment of jobs }x \in X \text{ for which } C(x) \text{ is minimum, ie.}\\\\
	//\text{ } \qquad \hspace{3em} \qquad \text{ } \text{ No }y \in X \text{ exists, such that } C(y) < C(x).\\
	//\end{math}
	//\text{}\\
	//\text{}\\
	//\text{}\\
	//</latex>
	//
	//Examples
	// //INPUT :
	//
	//machines = 3; 
	//
	//jobs = 3;
	//
	//jssp_mode = 0;
	//
	//tasks=[	1 1 3;
	//	1 2 2;
	//	1 3 2;
	//	2 1 2;
	//	2 3 1;
	//	2 2 4;
	//	3 2 4;
	//	3 3 3;
	//	];
	//	
	//[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, []);
	//
	//Examples
	// //INPUT: 
	//
	//machines = 2;
	//
	//jobs = 5;
	//
	//jssp_mode = 0;
	//
	//tasks = [1 1 13;
	//	1 2 3;
	//	2 1 2;
	//	2 2 5;
	//	3 1 1;
	//	3 2 3;
	//	4 1 4;
	//	4 2 6;
	//	5 1 5;
	//	5 2 7];
	//	
	//[makespan, schedule, status] = jssp (machines, jobs, jssp_mode, tasks, []);
	//Authors
	//Samuel Wilson

	
	
	
	//obtaining the number of inputs and outputs
	
	[lhs, rhs] = argn();
	
	//checking the number of input arguments
	
	if ( rhs<4 | rhs>5) then
	errmsg = msprintf(gettext("%s : Unexpected number of input arguments. ''4'' or ''5'' expected. Refer to help/FOT Documentation for more details.\n"),"jssp");
	error(errmsg);
	end
	
	
	//checking the number of output parameters
	
	if ( lhs<2 | lhs>3) then
	errmsg = msprintf( gettext("%s : Unexpected number of output parameters. ''2'' or ''3'' expected. Refer to help/FOT Documentation for more details.\n"),"jssp");
	error(errmsg);
	end
	
	
	
	//storing the input arguments
	
	machines = varargin(1);
	jobs = varargin(2);
	jmode = varargin(3);
	tasks = varargin(4);
	
	if (rhs  == 5) then
	time_limit = varargin(5);
	else
	time_limit = []; // the gateway automatically uses default value upon receiving an empty matrix
	end
	
	
	
	
	//Checking the type of all input arguments 
	
	Checktype("jssp",machines,"machines",1,"constant");
	Checktype("jssp",jobs,"jobs",2,"constant");
	Checktype("jssp",jmode,"jmode",3,"constant");
	Checktype("jssp",tasks,"tasks",4,"constant");
	Checktype("jssp",time_limit,"time_limit",5,"constant"); 
	
	
	
	
	///////////Checking the dimensions of all the inputs///////////
	
	
	//checking 'machines'
	
	m=size(machines,"r");
	n=size(machines,"c");
	
	if (m<>1 | n<>1) then 
	errmsg = msprintf(gettext("%s : Wrong dimensions for input argument #1 (''machines''). Single integral value [1x1] expected.\n"),"jssp");
	error(errmsg);
	end
	
	
	
	//checking 'jobs'
	
	
	m = size(jobs,"r");
	n = size(jobs, "c");
	
	if ( m<>1 | n<>1) then
	errmsg = msprintf(gettext("%s : Wrong dimensions for input argument #2 (''jobs''). Single integral value [1x1] expected.\n"),"jssp");
	error(errmsg);
	end
	
	
	//checking 'jmode'
	
	m = size(jmode, "r");
	n = size(jmode, "c");
	
	if ( m<>1 | n<>1 ) then
	errmsg = msprintf(gettext("%s : Wrong dimensions for input argument #3 (''jmode''). Single integral value [1x1] expected.\n"),"jssp");
	error(errmsg);
	end
	
	//checking jmode value as well(as 'twill be needed to check the dimensions of 'tasks'
	
	if ( jmode<>0 & jmode<>1) then
	errmsg = msprintf(gettext("%s : Input argument #3(''jmode'') can only take the value ''0'' or ''1'' (details in help/FOT documentation).\n"),"jssp");
	error(errmsg);
	end
	
	
	
	//checking 'tasks'
	
	m=size(tasks,"r");
	n=size(tasks,"c");
	
	num_tasks = m;
	
	
	if (jmode == 0) then
		if ( n<>3 )  then
		errmsg = msprintf(gettext("%s : Wrong dimensions for input argument #4( ''tasks''). [%dx3] expected.\n"),"jssp",num_tasks);
		error(errmsg);
		end
		
	else
		if ( n<>5 ) then
		errmsg = msprintf(gettext("%s : Wrong dimensions for input argument #4(''tasks''). [%dx5] expected.\n"),"jssp",num_tasks);
		error(errmsg);
		end
	end
	
	
	
	//checking 'time_limit'
	
	m = size(time_limit,"r");
	n = size(time_limit,"c");
	
	
	if ( ~((m==0 & n==0) | (m==1 & n==1)) ) then
	errmsg = msprintf(gettext("%s : Wrong dimensions for input argument #5(''time_limit''). Single integral value [1x1] or an empty matrix expected.\n"),"jssp");
	error(errmsg);
	end
	
	
	
	/////Dimensions verified/////
	
	
	
	////////// Checking if all the inputs are integral (ie. No fractional part)(NOTE -> x.0 is considered inherently integral as fractional part is '0'//////////////
	
	//checking 'machines'
	
	if ( ~(and(machines==(int(machines)))) ) then 
	errmsg = msprintf(gettext("%s : Number of machines ( ''machines'' ; argument #1) is expected to be an integral value.\n"),"jssp");
	error(errmsg);
	end
	
	
	//checking 'jobs'
	
	if ( ~(and(jobs == (int(jobs)))) ) then
	errmsg = msprintf(gettext("%s : Number of jobs ( ''jobs'' ; argument #2) is expected to be an integral value.\n"),"jssp");
	error(errmsg);
	end
	
	
	//jmode has already been checked for '0' or '1' value
	
	
	//checking 'tasks'
	
	if ( ~(and(tasks == (int(tasks)))) ) then
	errmsg = msprintf(gettext("%s : All the values in the ''tasks'' matrix (argument #4) are expected to be integral.\n"),"jssp");
	error(errmsg);
	end
	
	
	//checking 'time_limit'
	
	if ( ~(and(time_limit == (int(time_limit)))) ) then
	errmsg = msprintf(gettext("%s : Time Limit ( ''time_limit'' ; argument #5 ) is expected to be an integral value.\n"),"jssp");
	error(errmsg);
	end
	
	
	//-----------------------------------------------LOGICAL CHECKS---------------------------------------------------------//
	
	
	//checking if number of machines ('machines') is a valid(positive) value
	
	if ( machines < 1) then
	errmsg = msprintf(gettext("%s : Invalid value for arguement #1 (''machines''). A positive, integral value expected.\n"),"jssp");
	error(errmsg);
	end
	
	
	//checking if the number of jobs ('jobs') is a valid(positive) value
	
	if ( jobs < 1) then
	errmsg = msprintf(gettext("%s : Invalid value for argument #2 (''jobs''). A positive, integral value expected. \n"),"jssp");
	error(errmsg);
	end
	
	//checking if the time-limt ('time_limit') is a valid(positive) value, if 'tis provided
	
	if ( rhs == 5) then
		if ( time_limit <1) then
		errmsg = msprintf(gettext("%s : Invalid value for argument #5 (''time_limit''). A positive, integral value expected. \n"),"jssp");
		error(errmsg);
		end
	end
	
	
	//checking if no 'job' index values in the 'tasks' matrix are invalid
	
	if ( (or(tasks(:,1)< 1))  |  (or(tasks(:,1)>jobs)) ) then
	errmsg = msprintf(gettext("%s : One or more job-index values in the ''tasks'' matrix (argument #4) are invalid. Job indices can only take values from ''1'' to ''%d''.\n"),"jssp",jobs);
	error(errmsg);
	end
	
	
	//checking if no 'machine' index values in the 'tasks' matrix are invalid
	
	if ( (or(tasks(:,2) < 1)) | (or(tasks(:,2) > machines)) ) then 
	errmsg = msprintf(gettext("%s : One or more machine-index values in the ''tasks'' matrix (argument #4) are invalid. Machine indices can only take values from ''1'' to ''%d''.\n"),"jssp",machines);
	error(errmsg);
	end
	
	
	//checking if no 'duration' values in the 'tasks' matrix are invalid
	
	
	if ( or(tasks(:,3) < 0) ) then
	errmsg = msprintf(gettext("%s : One or more ''duration'' values in the ''tasks'' matrix (argument #4) are invalid. Duration values cannot be negative.\n"),"jssp");
	error(errmsg);
	end
	
	
	
	
	
	
	if ( jmode == 1) then
	
		for i = 1:size(tasks,"r")
		
			//checking if no 'start_after' values are invalid
			
			if ( ~((tasks(i,4) == -1 ) | ((tasks(i,4) > 0) & (tasks(i,4)<=(length(tasks(:,1) == i))))) ) then
			errmsg = msprintf(gettext("%s : One or more job-index values in the ''start-after'' column ( column 4) in the ''tasks'' matrix (argument #4) are invalid. Expected - either ''-1'' or a value from ''1'' to ''%d''.\n"),"jssp",jobs);
			error(errmsg);
			end
			
			
			//checking if no 'start_after' values are invalid
			
			if ( ~((tasks(i,5) == -1 ) | ((tasks(i,5) > 0) & (tasks(i,5)<=(length(tasks(:,1) == i))))) ) then
			errmsg = msprintf(gettext("%s : One or more job-index values in the ''end-before'' column (column 5) in the ''tasks'' matrix (argument #4) are invalid. Expected - either ''-1'' or a value from ''1'' to ''%d''.\n"),"jssp",jobs);
			error(errmsg);
			end	
	
		end
		
	end
	
	
	
	if ( jmode == 1) then
	
	for i = 1 : jobs
	
	 	// In case of mode '1', checking if each job has at least one task with no 'end-before' defined ie. open-ended(otherwise no task can be the last task in the schedule for that job, which is a logical fallacy. (Infeasible problem)
		if ( ~(or(tasks(find(tasks(:,1) == i),5) == -1)) ) then
		errmsg = msprintf(gettext("%s : At least one task in every job must be free from an ''end-before'' constraint ( = -1), to serve as a potential last task for that job. No such tasks found in job #%d.\n"),"jssp",i);
		error(errmsg);
		end
		
		
		// also checking if each job has at least one task with no 'start-after' defined (otherwise no task can be the first task in the schedule for that job, which is a logical fallacy. (Infeasible problem)
		if ( ~(or(tasks(find(tasks(:,1) == i),4) == -1)) ) then
		errmsg = msprintf(gettext("%s : At least one task in every job must be free from a ''start-after'' constraint ( = -1), to serve as a potential first task for that job. No such tasks found in job #%d.\n"),"jssp",i);
		error(errmsg);
		end
		
		//Also checking for the condition where there's only one task free from 'start-after' and 'end-before' constraints. The model is still wrong as the same task cannot be both the first and last task for the job.
		
		temp = tasks(find(tasks(:,1) == i),:)
		if ( (length(temp(:,4) == -1) == 1) & (length(temp(:,5 ) == -1) == 1) & ( length(find(temp(:,4)==-1 & temp(:,5)==-1)) ) ) then
		errmsg = msprintf(gettext("%s : Only one task in job %d free from ''start-after'' and ''end-before'' constraints. Each job must have at least one potential first and one potential last task for the problem to be feasible.\n"),"jssp",i);
		error(errmsg);
		end
		
		
	end
	end
	

	
	
	
	
	
	//-----------------------------------------SOLUTION--------------------------------------------------------//
	
	
	//solving the JSSP by calling the gateway function
	
	[makespan, schedule, status] = JSSP( machines, jobs, jmode, tasks, time_limit);
	
	
	
	select status
	
	case 0 then
	
	case 1 then
		if (time_limit <> []) then
		errmsg = msprintf(gettext("%s : ''TIMED_OUT'' :  The solver failed to find an optimal solution within the specified time limit (%d milliseconds). Try specifying a longer limit, if the problem allows.\n"),"jssp",time_limit);
		error(errmsg);
		else
		errmsg = msprintf(gettext("%s : ''TIMED_OUT'' : The solver failed to find an optimal solution within the default time limit (10 seconds). Try explicitly specifying a higher time-limit.\n"),"jssp");
		error(errmsg);
		end	
		
	case 2 then
		errmsg = msprintf(gettext("%s : ''PROBLEM_INFEASIBLE'' : No solution exists for the specified problem. If solution expected, please check the inputs.\n"),"jssp");
		error(errmsg);
		
	else
 		printf("\nUnexpected return status. Notify the toolbox authors.\n");
 	break;
 	
 	end
 	
endfunction
		
	
	
	
	
	
	
	
