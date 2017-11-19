// Check if the type of the adj_matrix is correct ("constant" ie. scilab  numeric matrix)

adj = 	['0' '10' '15' '20';
	'10' '0' '35' '25';
	'15' '35' '0' '30';
	'20' '25' '30' '0'];

start_node=1;

labels=['A' 'B' 'C' 'D'];


//Error
//tsp: Expected type ["constant"] for input argument adj_matrix at input #1, but got "string" instead.
//at line      56 of function Checktype called by :  
//at line     112 of function tsp called by :  
//[mincost,path,status]=tsp(adj,start_node,labels);


[mincost,path,status]=tsp(adj,start_node,labels);
