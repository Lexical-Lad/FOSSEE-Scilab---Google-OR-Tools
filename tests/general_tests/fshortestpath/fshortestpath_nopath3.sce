//Check to see if there is indeed a path between the specified source and target nodes in the given graph ( Here, a 'disconnected_distance' value is specified by the user, yet there is actually no path possible ie. the path ain't obscured due to thresholding by the 'disconnected_distance' value(double checks with max possible distance value and throws a pertinent error about the blockade of a path, if there was one)

start_nodes=[0 0 2 1 2 4 4 4]
end_nodes=[1 5 1 5 3 3 5 2]
weights=[10 8 5 2 7 10 10 8]
st=[0,3]




[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st,50)
