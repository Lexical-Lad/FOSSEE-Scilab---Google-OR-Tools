//Check if start node and target node values are integral(however, 'tis not mandatory to store them in a matrix integer type)

start_nodes = [0, 0, 0, 1, 1, 2, 2, 3, 3];
end_nodes = [1, 2, 3, 2, 4, 3, 4, 2, 4];		
weights = [20, 30, 10, 40, 30, 10, 20, 5, 20];

st=[0.4, 5.5]


//Error
//fshortestpath : The source and target node value(s)(input argument #4) are expected to be integral.
//at line     171 of function fshortestpath called by :  
//[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)


[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)
