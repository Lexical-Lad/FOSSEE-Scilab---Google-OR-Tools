//Check for the correct number of inputs

start_nodes = [0, 0, 0, 1, 1, 2, 2, 3, 3];
end_nodes = [1, 2, 3, 2, 4, 3, 4, 2, 4];
capacities = [20, 30, 10, 40, 30, 10, 20, 5, 20];

//Error
//fmaxflow : Wrong number of input arguments (3). This function expects 4 arguments. Refer to help/FOT documentation for more details
//at line     151 of function fmaxflow called by :  
//[maxflow,arcflows]=fmaxflow(start_nodes,end_nodes,capacities)


[maxflow,arcflows] = fmaxflow(start_nodes,end_nodes,capacities);
