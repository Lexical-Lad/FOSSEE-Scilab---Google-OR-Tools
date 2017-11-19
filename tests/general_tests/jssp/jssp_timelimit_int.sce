//Check if the value of 'time_limit', if provided, is integral( x.0 is considered INTEGRAL; any other fractional part throws an error)

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
	
time_limit = 100.90;


//Error
// !--error 10000 
//jssp : Time Limit ( 'time_limit' ; argument #5 ) is expected to be an integral value.
//at line     271 of function jssp called by :  
//[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, time_limit);
// 

[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, time_limit);
