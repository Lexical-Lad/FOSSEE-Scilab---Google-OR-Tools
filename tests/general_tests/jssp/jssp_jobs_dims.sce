//Check if the dimensions of 'jobs' is correct( Expected- Singular, integral value)

machines = 3; 
jobs = [];

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
	


//Error
// !--error 10000 
//jssp : Wrong dimensions for input argument #2 ('jobs'). Single integral value [1x1] expected.
//at line     175 of function jssp called by :  
//[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, []);

[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, []);
