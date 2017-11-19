//Check for the validity of the specified target node in the given graph

start_nodes=[ 0 0 1 1 2 4 5 4];
end_nodes= [ 1 5 2 5 3 3 4 2];
weights=[10 8 5 2 7 10 10 8];

st=[1,7]

//Error
//fshortestpath : Invalid target node(7)- The specified target node does not exist in the given graph
//at line     195 of function fshortestpath called by :  
//[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)

[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)
