mode(1)
//
// Demo of jssp.sci
//

//INPUT :
halt()   // Press return to continue
 
machines = 3;
halt()   // Press return to continue
 
jobs = 3;
halt()   // Press return to continue
 
jssp_mode = 0;
halt()   // Press return to continue
 
tasks=[    1 1 3;
1 2 2;
1 3 2;
2 1 2;
2 3 1;
2 2 4;
3 2 4;
3 3 3;
];
halt()   // Press return to continue
 
[makespan, schedule, status] = jssp(machines, jobs, jssp_mode, tasks, []);
halt()   // Press return to continue
 
//INPUT:
halt()   // Press return to continue
 
machines = 2;
halt()   // Press return to continue
 
jobs = 5;
halt()   // Press return to continue
 
jssp_mode = 0;
halt()   // Press return to continue
 
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
halt()   // Press return to continue
 
[makespan, schedule, status] = jssp (machines, jobs, jssp_mode, tasks, []);
//========= E N D === O F === D E M O =========//
