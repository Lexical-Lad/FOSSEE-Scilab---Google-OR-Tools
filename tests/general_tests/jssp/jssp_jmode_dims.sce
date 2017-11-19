//Check if the dimensions of 'jmode' are correct (Expected - Singular , 0/1 value)

machines = 3; 
jobs = 3;

jssp_mode = [0 1];

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
//jssp : Wrong dimensions for input argument #3 ('jmode'). Single integral value [1x1] expected.
//at line     186 of function jssp called by :  
//[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, []);


[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, []);
