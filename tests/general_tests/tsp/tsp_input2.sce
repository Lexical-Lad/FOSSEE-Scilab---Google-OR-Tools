//Check for the admissible number of input arguments(2-3)

adj = 	[0 10 15 20;
	10 0 35 25;
	15 35 0 30;
	20 25 30 0];

start_node=1;

labels=['A' 'B' 'C' 'D'];

//Error
//tsp : Number of input arguments is expected to be 2 or 3. Found 4. Refer to help/FOT documentation for more details.
//at line      89 of function tsp called by :  
//[mincost,path,status]=tsp(adj,start_node,labels,1);



[mincost,path,status]=tsp(adj,start_node,labels,1);
