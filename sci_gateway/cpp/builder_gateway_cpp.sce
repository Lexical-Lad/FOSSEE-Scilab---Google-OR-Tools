// This file is released under the 3-clause BSD license. See COPYING-BSD.

function builder_gw_cpp()

    GATEWAY_NAME = TOOLBOX_NAME + '_cpp';

    CUR_DIR = get_absolute_file_path('builder_gateway_cpp.sce');

    THIRD_PARTY_DIR = CUR_DIR + '/../../thirdparty';

    INC_DIR = [THIRD_PARTY_DIR + '/linux' + '/include'];

    [a, opt] = getversion();
    ARCH = opt(2);
    LIB_DIR = [THIRD_PARTY_DIR + '/linux' + '/lib/' + ARCH];

    LIB_CVRPTW = [LIB_DIR + '/libcvrptw_lib'];
    LIB_DIMACS = [LIB_DIR + '/libdimacs'];
    LIB_FAP = [LIB_DIR + '/libfap'];
    LIB_JNIORTOOLS = [LIB_DIR + '/libjniortools'];
    LIB_ORTOOLS = [LIB_DIR + '/libortools'];

    FUNC_NAMES = [
                    'solve_mincostflow','sci_min_cost_flow';
                    'solve_linsumassignment','sci_linear_sum_assignment';
					'MaxFlow','sci_max_flow';
					'BellmanFordShortestPath','sci_BellmanFord_shortestPath';
					'TSP','sci_tsp';
					'VRP','sci_vrp';
					'JSSP','sci_jssp'
                ];

    FILES = [
                'sci_iofunc.cpp',
                'sci_min_cost_flow.cpp',
                'sci_linear_sum_assignment.cpp',
				'sci_max_flow.cpp',
				'sci_BellmanFord_shortestPath.cpp',
				'sci_tsp.cpp',
				'sci_vrp.cpp',
				'sci_jssp.cpp'
            ];

    C_FLAGS = ['-ggdb -std=c++0x -D__USE_DEPRECATED_STACK_FUNCTIONS__ -w -fpermissive -I''' + CUR_DIR + ''' -I''' + INC_DIR + ''' -Wl,-rpath=''' + LIB_DIR + ''' '];
    LD_FLAGS = ['-L''' + LIB_CVRPTW + ''' -L''' + LIB_DIMACS + ''' -L''' + LIB_FAP + ''' -L''' + LIB_JNIORTOOLS + ''' -L''' + LIB_ORTOOLS + ''' -lz -lrt -lpthread -ggdb'];
    tbx_build_gateway(GATEWAY_NAME, FUNC_NAMES, FILES, CUR_DIR, [], LD_FLAGS, C_FLAGS);

endfunction

builder_gw_cpp();
clear builder_gw_cpp; // remove builder_gw_cpp on stack
