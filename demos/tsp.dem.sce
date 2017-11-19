mode(1)
//
// Demo of tsp.sci
//

halt()   // Press return to continue
 
adj=[0 10 50 45;
10 0 25 25;
50 25 0 40;
45 25 40 0];
halt()   // Press return to continue
 
start_node=1;
halt()   // Press return to continue
 
[mincost,path,status]=tsp(adj,start_node);
//Press ENTER to continue
halt()   // Press return to continue
 
//OUTPUT :
//'ROUTING_SUCCESS' ; An optimal solution was found
//Minimum cost -> 120
//Optimal Path :-
//1 ->2 ->3 ->4 ->1
halt()   // Press return to continue
 
halt()   // Press return to continue
 
adj=[0 10 15 20;
10 0 35 25;
15 35 0 30;
20 25 30 0];
halt()   // Press return to continue
 
start_node=1;
halt()   // Press return to continue
 
labels=['A' 'B' 'C' 'D'];
[mincost,path,status]=tsp(adj,start_node,labels);
//Press ENTER to continue
//
//OUTPUT :
//'ROUTING_SUCCESS' ; An optimal solution was found
//Minimum cost -> 80
//Optimal Path :-
// A (1) -> B (2) -> D (4) -> C (3) ->A (1)
halt()   // Press return to continue
 
halt()   // Press return to continue
 
adj=[0 1 2 1 1;
1 0 1 2 1;
2 1 0 1 2;
1 2 1 0 2;
1 1 2 2 0];
halt()   // Press return to continue
 
start_node=1;
halt()   // Press return to continue
 
labels=['alpha' 'beta'  'gamma' 'theta' 'sigma'];
halt()   // Press return to continue
 
[mincost,path,status]=tsp(adj,start_node,labels);
//Press ENTER to continue
halt()   // Press return to continue
 
//OUTPUT :
//'ROUTING_SUCCESS' ; An optimal solution was found
//Minimum cost -> 5
//Optimal Path :-
// alpha (1) -> sigma (5) -> beta (2) -> gamma (3) -> theta (4) ->alpha (1)
halt()   // Press return to continue
 
halt()   // Press return to continue
 
adj=[0 10 -1 -2;
10 0 35 25;
-1 35 0 30;
-1 25 30 0];
halt()   // Press return to continue
 
start_node=1;
halt()   // Press return to continue
 
[mincost,path,status]=tsp(adj,start_node);
//Press ENTER to continue
//
//OUTPUT :
//'ROUTING_FAIL' ; No optimal solution  was found. No path starting and ending at the specified 'start node'(1) found.
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
