//Check for the admissible number of output parameters( 2 or 3)

start_nodes = [0, 0, 0, 1, 1, 2, 2, 3, 3];
end_nodes = [1, 2, 3, 2, 4, 3, 4, 2, 4];
capacities = [20, 30, 10, 40, 30, 10, 20, 5, 20];
st=[0,4];


//Error
//Wrong number of output arguments.


[maxflow,arcflows,status,bleh] = fmaxflow(start_nodes,end_nodes,capacities,st);
