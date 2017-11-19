//Check if all the values of the adjacency matrix are integral( x.0 is considered INTEGRAL; any other fractional part throws an error)

adj = 	[0 10.3 15 20;
	10 0 35 25;
	15 35 0 30;
	20 25 30 0];

start_node=1;

labels=['A' 'B' 'C' 'D'];


//Error
//tsp : All values in the adjacency matrix ( input argument #1) are expected to be integral
//at line     155 of function tsp called by :  
//[mincost,path,status]=tsp(adj,start_node,labels);


[mincost,path,status]=tsp(adj,start_node,labels);



