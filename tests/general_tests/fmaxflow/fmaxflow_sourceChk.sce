//Check the existence of the specified source node in the given graph


start_nodes=[ 0 0 1 1 2 4 5 4];
end_nodes= [ 1 5 2 5 3 3 4 2];
capacities=[10 8 5 2 7 10 10 8];
st=[6,3];  // node 6 doesn't exist in the graph

//Error
//fshortestpath : Invalid source node(6)- The specified source node does not exist in the given graph
//at line     215 of function fmaxflow called by :  
//[maxflow,arcflows,status]=fmaxflow(start_nodes,end_nodes,capacities,st);

[maxflow,arcflows,status]=fmaxflow(start_nodes,end_nodes,capacities,st);
