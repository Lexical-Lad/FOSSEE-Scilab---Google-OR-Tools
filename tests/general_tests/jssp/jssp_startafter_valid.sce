//Check if the index values in the 'start-after' column (column 4) in 'tasks' matrix (only for mode '1'), are valid

machines = 3; 
jobs = 3;

jssp_mode = 1;

tasks=[	1 1 3 -1 -1;
	1 2 2 -1 1;
	1 3 2 -1 -1;
	2 1 2 -1 -1;
	2 3 1 -1 -1;
	2 2 4 -1 -1;
	3 2 4 -100 -1;
	3 3 3 -1 -1;
	];
	
time_limit = [];


//Error
// !--error 10000 
//jssp : One or more job-index values in the 'start-after' column ( column 4) in the 'tasks' matrix (argument #4) are invalid. Expected - either '-1' or a value from '1' to '3'.
//at line     340 of function jssp called by :  
//[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, time_limit);

[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, time_limit);
