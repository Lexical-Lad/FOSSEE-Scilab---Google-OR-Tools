//Check if all the capacity values are integral(however, 'tis not mandatory for them to be stored in a matrix integer type)


start_nodes=[ 0 0 1 1.0 2 4 5 4];
end_nodes= [ 1 5 2 5 3 3 4 2];
capacities=[10.1 8 5.7 2 7 10 10 8];
st=[0,3];

//Error
//fmaxflow : The values in the 'capacities' vector(input argument #3) are expected to be integral.
//at line     227 of function fmaxflow called by :  
//[maxflow,arcflows,status]=fmaxflow(start_nodes,end_nodes,capacities,st);
//NOTE that the '1.0' in start_nodes is acceptable as it's still technically integral


[maxflow,arcflows,status]=fmaxflow(start_nodes,end_nodes,capacities,st);
