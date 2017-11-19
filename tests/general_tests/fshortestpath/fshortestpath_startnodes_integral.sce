//Check if all the start nodes' values are integral(however, 'tis not mandatory to store them in a matrix integer type)

start_nodes=[ 0.8 0.3 1.5 1 2 4 5 4];
end_nodes= [ 1 5 2 5 3 3 4 2];
weights=[10 8 5 2 7 10 10 8];
st=[0,3];

//Error
//fshortestpath : The values in the 'start_nodes' vector(input argument #1) are expected to be integral.
//at line     156 of function fshortestpath called by :  
//[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)



[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)
