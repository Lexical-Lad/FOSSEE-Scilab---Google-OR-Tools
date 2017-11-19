//Check for the admissible number of input arguments(4-5)

start_nodes = [0, 0, 0, 1, 1, 2, 2, 3, 3];
end_nodes = [1, 2, 3, 2, 4, 3, 4, 2, 4];
weights = [20, 30, 10, 40, 30, 10, 20, 5, 20];
st=[0,4];

//Error
//fshortestpath : Number of input arguments is expected to be 4 or 5. Found 6. Refer to help/FOT documentation for more details.
//at line      71 of function fshortestpath called by :  
//[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st,40,1)



[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st,40,1);
