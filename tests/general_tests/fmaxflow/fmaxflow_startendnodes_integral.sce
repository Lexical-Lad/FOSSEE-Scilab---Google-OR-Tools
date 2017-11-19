//Check if all the capacity values are integral(however, 'tis not mandatory for them to be stored in a matrix integer type)

start_nodes=[ 0 0 1 1 2 4 5 4];
end_nodes= [ 1 5 2 5 3 3 4 2];
capacities=[10 8 5 2 7 10 10 8];

st=[0.5 2.4]

//Error
//fmaxflow : The source and target node value(s)(input argument #4) are expected to be integral.
//at line     232 of function fmaxflow called by :  
//[maxflow,arcflows,status]=fmaxflow(start_nodes,end_nodes,capacities,st);


[maxflow,arcflows,status]=fmaxflow(start_nodes,end_nodes,capacities,st);
