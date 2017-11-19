//Check if the value of the start node index is valid ( can only be from 1 to 'n' ; n-> no. of nodes in the graph)

adj = 	[0 10 15 20;
	10 0 35 25;
	15 35 0 30;
	20 25 30 0];

start_node=5;

labels=['A' 'B' 'C' 'D'];


//Error
//tsp : Invalid 'start node' index (5). It is expected to be between '1' and '4'(no. of nodes in the given graph).
//at line     169 of function tsp called by :  
//[mincost,path,status]=tsp(adj,start_node,labels);



[mincost,path,status]=tsp(adj,start_node,labels);
