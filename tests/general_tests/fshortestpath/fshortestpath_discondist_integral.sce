//Check if the value of 'disconnected_distance' is integral( x.0 is considered INTEGRAL; any other fractional part throws an error)

start_nodes=[ 0 0 1 1 2 4 5 4];
end_nodes= [ 1 5 2 5 3 3 4 2];
weights=[10 8 5 2 7 10 10 8];
st=[0,3]

disconnected_distance=5.3;

//Error
//fshortestpath : The 'disconnected distance' value(input argument #5) is expected to be integral.
//at line     178 of function fshortestpath called by :  
//[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st,disconnected_distance)


[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st,disconnected_distance)


