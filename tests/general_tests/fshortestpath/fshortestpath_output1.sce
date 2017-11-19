//Check for the admissible number of output parameters( 2 or 3)


start_nodes = [0, 0, 0, 1, 1, 2, 2, 3, 3];
end_nodes = [1, 2, 3, 2, 4, 3, 4, 2, 4];
weights = [20, 30, 10, 40, 30, 10, 20, 5, 20];
st=[0,4];

//Error
//fshortestpath : Unexpected number of output parameters( Found 1). This routine expects 2 or 3  output parameters. Refer to help/FOT documentation for more details.
//at line      78 of function fshortestpath called by :  
//[mincost]=fshortestpath(start_nodes,end_nodes,weights,st);



[mincost]=fshortestpath(start_nodes,end_nodes,weights,st);
