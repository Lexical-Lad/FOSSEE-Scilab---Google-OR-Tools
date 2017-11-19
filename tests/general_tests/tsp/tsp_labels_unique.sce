//Check if all the values in the 'labels' vector are unique ( 2 nodes of the graph cannot have the same label)

adj = 	[0 10 15 20;
	10 0 35 25;
	15 35 0 30;
	20 25 30 0];

start_node=1;

labels=['A' 'B' 'C' 'B'];

//Error
//tsp : The entries in the 'label' matrix should be unique ( no 2 nodes can have the same label)
//at line     195 of function tsp called by :  
//[mincost,path,status]=tsp(adj,start_node,labels);



[mincost,path,status]=tsp(adj,start_node,labels);
