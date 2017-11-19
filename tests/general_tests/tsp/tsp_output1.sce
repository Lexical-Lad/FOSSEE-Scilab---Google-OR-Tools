//Check for the admissible number of output parameters( 2 or 3)

adj = 	[0 10 15 20;
	10 0 35 25;
	15 35 0 30;
	20 25 30 0];

start_node=1;

labels=['A' 'B' 'C' 'D'];


//Error
//tsp : Number of output arguments is expected to be to 2 or 3. Found 1. Refer to the help/FOT documentation for more details.
//at line      96 of function tsp called by :  
//[mincost]=tsp(adj,start_node,labels);


[mincost]=tsp(adj,start_node,labels);
