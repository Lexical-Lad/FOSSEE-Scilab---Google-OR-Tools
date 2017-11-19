//Check if 'time_limit' is of the correct type

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
	
time_limit = "1000";


//Error
// !--error 10000 
//jssp: Expected type ["constant"] for input argument time_limit at input #5, but got "string" instead.
//at line      56 of function Checktype called by :  
//at line     147 of function jssp called by :  
//[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, time_limit);
// 


[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, time_limit);
