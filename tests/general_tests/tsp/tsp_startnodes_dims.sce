//Check if the dimensions of the 'start_node' argument are correct(singular numeric value expected)

adj = 	[0 10 15 20;
	10 0 35 25;
	15 35 0 30;
	20 25 30 0];

start_node=[1 2];

labels=['A' 'B' 'C' 'D'];

//Error
//tsp : Invalid start_node index value. Singlular value indicating the index of the node from where the journey is to begin expected
//at line     145 of function tsp called by :  
//[mincost,path,status]=tsp(adj,start_node,labels);



[mincost,path,status]=tsp(adj,start_node,labels);
