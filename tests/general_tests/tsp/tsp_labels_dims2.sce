//Check if the dimensions of the 'labels' vector are correct ( [1xn] expected ; n->no. of nodes in the given graph)

adj = 	[0 10 15 20;
	10 0 35 25;
	15 35 0 30;
	20 25 30 0];

start_node=1;

labels=['A' 'B' 'C' 'D';
	'E' 'F' 'G' 'H'	];
	
	

//Error
//tsp : The 'labels' matrix (input argument #3) must have only one row, ie., it must be vector
//at line     187 of function tsp called by :  
//[mincost,path,status]=tsp(adj,start_node,labels);
	
	
[mincost,path,status]=tsp(adj,start_node,labels);
