//Check to ensure that the 3 input vectors viz. 'start_nodes', 'end_nodes' and 'weights' are of equal length(as they define the arcs of the graph- each index across the 3 representing one unique arc)

start_nodes=[ 0 0 1 1 2 4 5 4 6];
end_nodes= [ 1 5 2 5 3 3 4 2];
weights=[10 8 5 2 7 10 10 8 4];
st=[0,3]

//Error
//fshortestpath : Unequal dimensions of the 3 input vectors (9 8 9). The 3 are expected to be of equal lengths.
//at line     138 of function fshortestpath called by :  
//[mincost,shortestpath,flag] = fshortestpath(start_nodes,end_nodes,weights,st);


[mincost,shortestpath,flag] = fshortestpath(start_nodes,end_nodes,weights,st);
