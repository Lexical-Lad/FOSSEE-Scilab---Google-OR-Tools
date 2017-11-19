mode(1)
//
// Demo of fmaxflow.sci
//

halt()   // Press return to continue
 
start_nodes = [0, 0, 0, 1, 1, 2, 2, 3, 3]
end_nodes = [1, 2, 3, 2, 4, 3, 4, 2, 4]
capacities = [20, 30, 10, 40, 30, 10, 20, 5, 20]
st=[0,4]
[maxflow,arcflows,status]=fmaxflow(start_nodes,end_nodes,capacities,st)
// Press Enter to continue
//Output
//Max flow = 60
//Arc    Flow    Capacity
//0->1    20    20
//0->2    30    30
//0->3    10    10
//1->2    0    40
//1->4    20    30
//2->3    10    10
//2->4    20    20
//3->2    0    5
//3->4    20    20
halt()   // Press return to continue
 
//An optimal solution was found
// status  =
//
//  0
// arcflows  =
//
//  20  30  10  0  20  10  20  0  20
// maxflow  =
//
//  60
halt()   // Press return to continue
 
halt()   // Press return to continue
 
halt()   // Press return to continue
 
start_nodes = [1, 1, 2, 2, 3, 3, 0]
end_nodes = [2, 4, 3, 4, 2, 4, 5]
capacities = [40, 30, 10, 20, 5, 20, 50]
st=[0,4]
[maxflow,arcflows,status]=fmaxflow(start_nodes,end_nodes,capacities,st)
//Press Enter to continue
//     Output
//     Max flow = 0
//Arc    Flow    Capacity
//1->2    0    40
//1->4    0    30
//2->3    0    10
//2->4    0    20
//3->2    0    5
//3->4    0    20
//0->5    0    50
halt()   // Press return to continue
 
//There is no path connecting the specified source node : 0  and the specified target node : 4
// status  =
//
//  0
// arcflows  =
//
//     []
// maxflow  =
//
//  0
halt()   // Press return to continue
 
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
