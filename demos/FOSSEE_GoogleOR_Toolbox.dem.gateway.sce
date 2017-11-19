//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function subdemolist = demo_gateway()
    demopath = get_absolute_file_path("FOSSEE_GoogleOR_Toolbox.dem.gateway.sce");

    subdemolist = ["min_cost_flow", "min_cost_flow.dem.sce";
    				"linsum", "linsum.dem.sce";
    				"fmaxflow","fmaxflow.dem.sce";
    				"fshortestpath","fshortestpath.dem.sce";
    				"tsp","tsp.dem.sce"];

    subdemolist(:,2) = demopath + subdemolist(:,2);

endfunction

subdemolist = demo_gateway();
clear demo_gateway; // remove demo_gateway on stack
