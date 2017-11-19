//Check if all the end nodes' values are integral(however, 'tis not mandatory to store them in a matrix integer type)

start_nodes=[ 0 0 1 1.0 2.0 4 5 4]; //x.0 is considered integral, so 'start_nodes' doesn't throw any error
end_nodes= [ 1 5 2 5 3 3 4 2];
weights=[10.6 8.9 5 2 7.5 10 10 8];
st=[0,3];


//Error
//fshortestpath : The values in the 'weights' vector(input argument #3) are expected to be integral.
//at line     166 of function fshortestpath called by :  
//[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)


[mincost,shortestpath,flag]=fshortestpath(start_nodes,end_nodes,weights,st)
