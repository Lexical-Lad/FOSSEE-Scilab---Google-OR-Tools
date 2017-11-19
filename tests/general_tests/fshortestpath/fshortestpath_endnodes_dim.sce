//Check the dimensions of the 'end_nodes' vector(expected - 1xn matrix)

start_nodes = [0, 0, 0, 1, 1, 2, 2, 3, 3];
end_nodes = [1, 2, 3, 2, 4, 3, 4, 2, 4;
		1, 1, 1, 1, 1, 1, 1, 1, 1;
		7, 5, 3, 2, 7, 2, 1, 3, 5;];
weights = [20, 30, 10, 40, 30, 10, 20, 5, 20];
st=[0,4];


//Error
//fshortestpath : Wrong Input Size. The input argument #2 is expected to be a matrix of dimensions of the form 1xn (3x9 obtained instead)
//at line     128 of function fshortestpath called by :  
//[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)


[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)
