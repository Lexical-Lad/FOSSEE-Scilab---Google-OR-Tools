//Check if the dimensions of the 'tasks' matrix are correct ( Expected - a 3-column matrix for mode '0' and a 5-column matrix for mode '1')

machines = 3; 
jobs = 3;

jssp_mode = 0;

tasks=[	1 1 3 1;
	1 2 2 1;
	1 3 2 1;
	2 1 2 1;
	2 3 1 1;
	2 2 4 1;
	3 2 4 1;
	3 3 3 1;
	];
	
//Error
// !--error 10000 
//jssp : Wrong dimensions for input argument #4( 'tasks'). [8x3] expected.
//at line     209 of function jssp called by :  
//[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, []);
 


[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, []);
