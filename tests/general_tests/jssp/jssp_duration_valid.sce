//Check if all the duration values in the 'tasks' matrix are valid (Expected- nonnegative, integral values)

machines = 3; 
jobs = 3;

jssp_mode = 0;

tasks=[	1 1 -1;
	1 2 2;
	1 3 2;
	2 1 2;
	2 3 1;
	2 2 4;
	3 2 4;
	3 3 3;
	];
	
time_limit = [];

//Error
// !--error 10000 
//jssp : One or more 'duration' values in the 'tasks' matrix (argument #4) are invalid. Duration values cannot be negative.
//at line     324 of function jssp called by :  
//[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, time_limit);


[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, time_limit);
