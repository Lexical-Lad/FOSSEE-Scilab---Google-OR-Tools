//Check for the admissible number of output parameters( 2 or 3)

start_nodes = [0, 0, 0, 1, 1, 2, 2, 3, 3];
end_nodes = [1, 2, 3, 2, 4, 3, 4, 2, 4];
capacities = [20, 30, 10, 40, 30, 10, 20, 5, 20];
st=[0,4];

//Error
//fmaxflow : Wrong number of output arguments(1). This function can deliver 2/3 outputs. Refer to help/FOT documentation for further details
//at line     158 of function fmaxflow called by :  
//[maxflow] = fmaxflow(start_nodes,end_nodes,capacities,st);



[maxflow] = fmaxflow(start_nodes,end_nodes,capacities,st);
