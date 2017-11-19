//Checking if all the job-indices in the 'tasks' matrix (column 1) are valid

machines = 3; 
jobs = 3;

jssp_mode = 0;

tasks=[	1 1 3;
	1 2 2;
	1 3 2;
	2 1 2;
	2 3 1;
	2 2 4;
	4 2 4;
	3 3 3;
	];
	
time_limit = [];

//Error
// !--error 10000 
//jssp : One or more job-index values in the 'tasks' matrix (argument #4) are invalid. Job indices can only take values from '1' to '3'.
//at line     307 of function jssp called by :  
//[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, time_limit);


[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, time_limit);
