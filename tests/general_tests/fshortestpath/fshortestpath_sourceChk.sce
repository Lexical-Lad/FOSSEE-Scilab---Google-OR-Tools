//Check for the validity of the specified source node in the given graph

start_nodes=[ 0 0 1 1 2 4 5 4];
end_nodes= [ 1 5 2 5 3 3 4 2];
weights=[10 8 5 2 7 10 10 8];

st=[6,4]

//Error
//fshortestpath : Invalid source node(6)- The specified source node does not exist in the given graph
//at line     190 of function fshortestpath called by :  
//[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)



[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)
