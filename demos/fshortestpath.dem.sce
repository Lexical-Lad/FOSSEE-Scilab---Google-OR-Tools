mode(1)
//
// Demo of fshortestpath.sci
//

start_nodes = [0, 0, 0, 1, 1, 2, 2, 3, 3]
end_nodes = [1, 2, 3, 2, 4, 3, 4, 2, 4]
weights = [20, 30, 10, 40, 30, 10, 20, 5, 20]
st=[0,4]
[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)
//Press Enter to continue
//Output :
//Shortest path from start-node:0 to end-node:4 is :
//0 -> 3 -> 4
//Minumum cost (using the said path) :- 30.000000
halt()   // Press return to continue
 
halt()   // Press return to continue
 
specifying disconnected-distance
start_nodes = [0, 0, 0, 1, 1, 2, 2, 3, 3]
end_nodes = [1, 2, 3, 2, 4, 3, 4, 2, 4]
weights = [20, 30, 10, 10, 30, 10, 20, 5, 30]
st=[0,4]
disconnected_distance=30
[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)
//Press Enter to continue
//Output
//Shortest path from start-node:0 to end-node:4 is :
//0 -> 3 -> 2 -> 4
//Minumum cost (using the said path) :- 35.000000
//Shortest/Lowest Cost Path found.
halt()   // Press return to continue
 
halt()   // Press return to continue
 
start_nodes = [1, 1, 2, 2, 3, 3, 0]
end_nodes = [2, 4, 3, 4, 2, 4, 5]
weights = [40, 30, 10, 20, 5, 20, 30]
st=[0,4]
[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)
//Press Enter to continue
//No path connecting start-node: 0 and end-node=: 4.
//No Solution![0 , 4]
halt()   // Press return to continue
 
halt()   // Press return to continue
 
start_nodes=[ 0 0 1 1 2 4 5 4];
end_nodes= [ 1 5 2 5 3 3 4 2];
weights=[10 8 5 2 7 10 10 8];
st=[0,3]
[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)
//Press Enter to continue
//Output
//Shortest path from start-node:0 to end-node:3 is :
//0 -> 1 -> 2 -> 3
//Minumum cost (using the said path) :- 22.000000
// Shortest/Lowest Cost Path found.
halt()   // Press return to continue
 
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
