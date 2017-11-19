//For mode '1', checking if there's one task eligible to be the very first task in the schedule

machines = 2;
jobs = 5;
jssp_mode = 1;

tasks = [1 1 13 1 -1;
	1 2 3 1 -1;
	2 1 2 1 -1;
	2 2 5 1 -1;
	3 1 1 1 -1;
	3 2 3 1 -1;
	4 1 4 1 -1;
	4 2 6 1 -1;
	5 1 5 1 -1;
	5 2 7 1 -1];
	
time_limit = [];

//Error
//jssp : At least one task in every job must be free from a 'start-after' constraint ( = -1), to serve as a potential first task for that job. No such tasks found in job #1.
//at line     371 of function jssp called by :  
//[makespan, schedule, status] = jssp (machines, jobs, jssp_mode, tasks, time_limit);
	
[makespan, schedule, status] = jssp (machines, jobs, jssp_mode, tasks, time_limit);
