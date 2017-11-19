//Check for the dimensions of the 'capacities' vector(expected - 1xn form matrix)
start_nodes = [0, 0, 0, 1, 1, 2, 2, 3, 3];
end_nodes = [1, 2, 3, 2, 4, 3, 4, 2, 4]
capacities = [20, 30, 10, 40, 30, 10, 20, 5, 20
		10, 20, 50, 5, 30 ,56, 40, 50, 100];
st=[0,4];

//Error
//fmaxflow : Wrong Input Size. The input argument #3 is expected to be a matrix of dimension of the form 1xn (2x9 obtained instead)
//at line     198 of function fmaxflow called by :  
//[maxflow,arcflows,status]=fmaxflow(start_nodes,end_nodes,capacities,st)



[maxflow,arcflows,status]=fmaxflow(start_nodes,end_nodes,capacities,st);
