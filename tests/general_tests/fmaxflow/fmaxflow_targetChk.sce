//Check for the validity of the specified target node in the given graph


start_nodes=[ 0 0 1 1 2 4 5 4];
end_nodes= [ 1 5 2 5 3 3 4 2];
capacities=[10 8 5 2 7 10 10 8];
st=[0,9];  // node 9 doesn't exist in the graph

//Error
//fshortestpath : Invalid target node(9)- The specified target node does not exist in the given graph
//at line     220 of function fmaxflow called by :  
//[maxflow,arcflows,status]=fmaxflow(start_nodes,end_nodes,capacities,st);

[maxflow,arcflows,status]=fmaxflow(start_nodes,end_nodes,capacities,st);
