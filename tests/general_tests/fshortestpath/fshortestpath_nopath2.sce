//Check to see if there is an actual path between the specified source and taget nodes. In this case, there IS a path but it is ignored due to the the weight value of one or more arcs being more than the threashold value('disconnected distance) specified by the user. The routine internally checks a second time without the restriction of the threashold to provide a pertinent error regarding the same.

start_nodes=[ 0 0 0 1 1 2 2 3 3 ];
end_nodes=[ 1 2 3 2 4 3 4 2 4 ];
weights= [ 20 30 10 40 30 10 20 5 20 ];
st= [ 0 4];
disconnected_distance=20;



[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st,disconnected_distance)
