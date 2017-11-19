//Check if the value of 'machines' is integral( x.0 is considered INTEGRAL; any other fractional part throws an error)


machines = 3.1; 
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
	
time_limit = [];

//Error
// !--error 10000 
//jssp : Number of machines ( 'machines' ; argument #1) is expected to be an integral value.
//at line     244 of function jssp called by :  
//[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, time_limit);
// 


[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, time_limit);
