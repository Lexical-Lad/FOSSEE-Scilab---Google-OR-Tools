//Check to see if there is indeed a path between the specified source and target nodes in the given graph ( Here, no 'disconnected_distance' value is specified)

start_nodes=[0 0 2 1 2 4 4 4]
end_nodes=[1 5 1 5 3 3 5 2]
weights=[10 8 5 2 7 10 10 8]
st=[0,3]


//Error
//No path connecting start-node: 0 and end-node=: 3.

// No Solution![0 , 3] 



[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)
