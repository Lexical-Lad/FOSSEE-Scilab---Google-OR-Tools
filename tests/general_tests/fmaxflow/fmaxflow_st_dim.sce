//Check for the dimensions of the row matrix/vector 'st'(representing the 2 values for source node and target node respectively)- expected dimensions - 1x2

start_nodes = [0, 0, 0, 1, 1, 2, 2, 3, 3];
end_nodes = [1, 2, 3, 2, 4, 3, 4, 2, 4];
capacities = [20, 30, 10, 40, 30, 10, 20, 5, 20];
st=[0,4,5];

//Error
//fmaxflow: Expected size [1 2] for input argument st at input #4, but got [1 3] instead.
//at line      49 of function Checkdims called by :  
//at line     206 of function fmaxflow called by :  
//[maxflow,arcflows,status]=fmaxflow(start_nodes,end_nodes,capacities,st);


[maxflow,arcflows,status]=fmaxflow(start_nodes,end_nodes,capacities,st);

