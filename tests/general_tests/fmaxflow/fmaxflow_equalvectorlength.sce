//Check to ensure the 3 vectors viz. 'start_nodes', 'end_nodes' and 'capacities' are of equal length(as they define the arcs of the graph- each index across the 3 representing one unique arc)


start_nodes=[ 0 0 1 1 2 4 5 4 6];
end_nodes= [ 1 5 2 5 3 3 4 2];
capacities=[10 8 5 2 7 10 10 8 4];

st=[0,3]

//Error
//fmaxflow : Unequal dimensions of the 3 input vectors (9 8 9). The 3 are expected to be of equal lengths.
//at line     203 of function fmaxflow called by :  
//[maxflow,arcflows,status]=fmaxflow(start_nodes,end_nodes,capacities,st);



[maxflow,arcflows,status]=fmaxflow(start_nodes,end_nodes,capacities,st);
