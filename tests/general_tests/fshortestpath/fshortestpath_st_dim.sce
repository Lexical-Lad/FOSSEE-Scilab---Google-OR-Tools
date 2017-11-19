//Check the dimensions of input matrix 'st'(expected- 1x2 ; representing the source and target nodes respectively)


start_nodes = [0, 0, 0, 1, 1, 2, 2, 3, 3];
end_nodes = [1, 2, 3, 2, 4, 3, 4, 2, 4];		
weights = [20, 30, 10, 40, 30, 10, 20, 5, 20];

st=[0,4,8];

//Error
//fshortestpath: Expected size [1 2] for input argument st at input #4, but got [1 3] instead.
//at line      49 of function Checkdims called by :  
//at line     141 of function fshortestpath called by :  
//[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)


[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)
