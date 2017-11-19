//Check if the type of the 'labels' vector is correct ( "string" i.e. scilab string matrix)

adj = 	[0 10 15 20;
	10 0 35 25;
	15 35 0 30;
	20 25 30 0];

start_node=1;

labels=[1 2 3 4];


//Error
//tsp: Expected type ["string"] for input argument labels at input #3, but got "constant" instead.
//at line      56 of function Checktype called by :  
//at line     116 of function tsp called by :  
//[mincost,path,status]=tsp(adj,start_node,labels);


[mincost,path,status]=tsp(adj,start_node,labels);
