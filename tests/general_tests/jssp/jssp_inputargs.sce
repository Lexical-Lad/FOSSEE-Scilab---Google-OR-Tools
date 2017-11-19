//Check if the number of input arguments is correct/permissible

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
	
bleh = [1];

//Error
// !--error 10000 
//jssp : Unexpected number of input arguments. '4' or '5' expected. Refer to help/FOT Documentation for more details.
//at line     112 of function jssp called by :  
//[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, [], bleh);

[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, [], bleh);
