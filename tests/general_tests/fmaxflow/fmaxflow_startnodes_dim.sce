//Check for the dimensions of the 'start_nodes' vector(expected - 1xn form matrix)

start_nodes = [0, 0, 0, 1, 1, 2, 2, 3, 3;
		0, 0, 0, 0, 0, 0, 0, 0, 0];
end_nodes = [1, 2, 3, 2, 4, 3, 4, 2, 4];
capacities = [20, 30, 10, 40, 30, 10, 20, 5, 20];
st=[0,4];
 
//Error
//fmaxflow : Wrong Input Size. The input argument #1 is expected to be a matrix of dimension of the form 1xn (2x9 obtained instead)
//at line     188 of function fmaxflow called by :  
//[maxflow,arcflows,status]=fmaxflow(start_nodes,end_nodes,capacities,st) 

  
[maxflow,arcflows,status]=fmaxflow(start_nodes,end_nodes,capacities,st);
