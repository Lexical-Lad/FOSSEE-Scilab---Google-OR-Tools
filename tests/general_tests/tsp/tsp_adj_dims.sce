//Check if the dimensions of the adjacency matrix are corrent( [n x n] expected ; n-> number of nodes in the graph)

adj = 	[0 10 15 20;
	10 0 35 25;
	15 35 0 30;
	20 25 30 0;
	13 23 10 10];

start_node=1;

labels=['A' 'B' 'C' 'D'];

//Error
//tsp : The dimensions of the given adjacency matrix are erroneous [5 x 4]. Number of rows and columns has to be equal(square matrix) ( = no. of nodes in the graph).
//at line     130 of function tsp called by :  
//[mincost,path,status]=tsp(adj,start_node,labels);



[mincost,path,status]=tsp(adj,start_node,labels);
