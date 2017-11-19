//Check for the admissible number of output parameters( 2 or 3)

adj = 	[0 10 15 20;
	10 0 35 25;
	15 35 0 30;
	20 25 30 0];

start_node=1;

labels=['A' 'B' 'C' 'D'];

//Error
//Wrong number of output arguments.




[mincost,path,status,xx]=tsp(adj,start_node,labels,1);
