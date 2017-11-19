//Check to see if there is indeed a path between the specified source and target nodes in the given graph(it can't be concluded that the graph is disconnected, only that there is no possible path in this DIGRAPH connecting the source node and the target node


start_nodes=[0 0 2 1 2 4 4 4]
end_nodes=[1  5 1 5 3 3 5 2]
capacities=[10 8 5 2 7 10 10 8]
st=[0,3]


//Error
//Max flow = 0
//Arc	Flow	Capacity
//0->1	0	10
//0->5	0	8
//2->1	0	5
//1->5	0	2
//2->3	0	7
//4->3	0	10
//4->5	0	10
//4->2	0	8

//There is no path connecting the specified source node : 0  and the specified target node : 3



[maxflow,arcflows,status] = fmaxflow(start_nodes,end_nodes,capacities,st);
