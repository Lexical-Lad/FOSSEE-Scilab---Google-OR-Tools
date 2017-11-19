//Check if all the diagonal elements of the given adjacency matrix are '0'
adj = 	[0 10 15 20;
	10 1 35 25;
	15 35 0 30;
	20 25 30 0;];

start_node=1;

labels=['A' 'B' 'C' 'D'];


//Error
//tsp : All leading diagonal elements of the adjacency matrix need to be 0
//at line     138 of function tsp called by :  
//[mincost,path,status]=tsp(adj,start_node,labels);



[mincost,path,status]=tsp(adj,start_node,labels);

