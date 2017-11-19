//Check if the value of the start node index isintegral( x.0 is considered INTEGRAL; any other fractional part throws an error)

adj = 	[0 10 15 20;
	10 0 35 25;
	15 35 0 30;
	20 25 30 0];

start_node=1.9;

labels=['A' 'B' 'C' 'D'];


//Error
//tsp : The start_node index ( input argument #2) is expected to be integral
//at line     160 of function tsp called by :  
//[mincost,path,status]=tsp(adj,start_node,labels);


[mincost,path,status]=tsp(adj,start_node,labels);


