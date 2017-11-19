//Check if the number of output arguments is correct/permissible

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
	


//Error
//!--error 59 
//Wrong number of output arguments.

[makespan, schedule, status, redundancy] = jssp(machines, jobs, jssp_mode, tasks, []);
