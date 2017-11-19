//Check if the value of 'time_limit' is valid ( Expected- Positive integral value)



machines = 2;
jobs = 5;
jssp_mode = 0;

tasks = [1 1 13;
	1 2 3;
	2 1 2;
	2 2 5;
	3 1 1;
	3 2 3;
	4 1 4;
	4 2 6;
	5 1 5;
	5 2 7];
	
time_limit = 0;


//Error
// !--error 10000 
//jssp : Invalid value for argument #5 ('time_limit'). A positive, integral value expected. 
//at line     298 of function jssp called by :  
//[makespan, schedule, status] = jssp (machines, jobs, jssp_mode, tasks, time_limit);
	
[makespan, schedule, status] = jssp (machines, jobs, jssp_mode, tasks, time_limit);
