//Check if the value of 'disconnected_distance is a singular numerical value(1x1 matrix form)

start_nodes=[ 0 0 1 1 2 4 5 4];
end_nodes= [ 1 5 2 5 3 3 4 2];
weights=[10 8 5 2 7 10 10 8];
st=[0,3]

disconnected_distance=[0,4]

//Error
//fshortestpath: Expected size [1 1] for input argument disconnected_distance at input #5, but got [1 2] instead.
//at line      49 of function Checkdims called by :  
//at line     144 of function fshortestpath called by :  
//[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st,disconnected_distance)



[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st,disconnected_distance)
