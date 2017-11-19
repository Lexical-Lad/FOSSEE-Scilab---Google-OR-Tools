//Check if the 'jmode' value is valid (Expected - only integral '0' or '1')

machines = 3; 
jobs = 3;

jssp_mode = 2;

tasks=[	1 1 3;
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
//jssp : Input argument #3('jmode') can only take the value '0' or '1' (details in help/FOT documentation).
//at line     193 of function jssp called by :  
//[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, time_limit);


[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, time_limit);
