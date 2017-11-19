//Check if 'tasks' is of the correct type

machines = 3; 
jobs = 3;

jssp_mode = 0;

tasks=list([	1 1 3;
	1 2 2;
	1 3 2;
	2 1 2;
	2 3 1;
	2 2 4;
	3 2 4;
	3 3 3;
	]);
	
time_limit = [];

//Error
// !--error 10000 
//jssp: Expected type ["constant"] for input argument tasks at input #4, but got "list" instead.
//at line      56 of function Checktype called by :  
//at line     146 of function jssp called by :  
//[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, time_limit);


[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, time_limit);
