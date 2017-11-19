//Check if the dimension of 'time_limit' , if provided, are correct (Expected - Singular, integral, positive value)
machines = 3; 
jobs = 3;

jssp_mode = 0;

tasks=[	1 1 3;
	1 2 2;
	1 3 2;
	2 1 2;
	2 3 1;
	2 2 4;
	3 2 4;
	3 3 3;
	];
	
time_limit = [1 3];

//Error
// !--error 10000 
//jssp : Wrong dimensions for input argument #5('time_limit'). Single integral value [1x1] or an empty matrix expected.
//at line     229 of function jssp called by :  
//[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, time_limit);


[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, time_limit);
