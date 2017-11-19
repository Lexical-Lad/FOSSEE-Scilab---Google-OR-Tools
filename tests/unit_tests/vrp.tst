// Copyright (C) 2017 - IIT Bombay - FOSSEE
//
// Author:	Samuel Wilson
// Organization: FOSSEE, IIT Bombay
// Email: harpreet.mertia@gmail.com
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->
// <-- NO CHECK REF -->
// <-- NO CHECK ERROR OUTPUT -->

//
// assert_close --
//   Returns 1 if the two real matrices computed and expected are close,
//   i.e. if the relative distance between computed and expected is lesser than epsilon.
// Arguments
//   computed, expected : the two matrices to compare
//   epsilon : a small number
//
function flag = assert_close ( computed, expected, epsilon )
  if expected==0.0 then
    shift = norm(computed-expected);
  else
    shift = norm(computed-expected)/norm(expected);
  end
//  if shift < epsilon then
//    flag = 1;
//  else
//    flag = 0;
//  end
//  if flag <> 1 then pause,end
    flag = assert_checktrue ( shift < epsilon );
endfunction
//
// assert_equal --
//   Returns 1 if the two real matrices computed and expected are equal.
// Arguments
//   computed, expected : the two matrices to compare
//   epsilon : a small number
//
//function flag = assert_equal ( computed , expected )
//  if computed==expected then
//    flag = 1;
//  else
//    flag = 0;
//  end
//  if flag <> 1 then pause,end
//endfunction


//A simple Vehicle-Routing Problem(with optimal solution)

adj_matrix =    [0, 2451,  713, 1018, 1631, 1374, 
		2451,    0, 1745, 1524,  831, 1240;
		713, 1745,    0,  355,  920,  803; 
		1018, 1524,  355,    0,  700,  862; 
		1631,  831,  920,  700,    0,  663; 
		1374, 1240,  803,  862,  663,    0];

labels = ["New York", "Los Angeles", "Chicago", "Minneapolis", "Denver", "Dallas"];

start = 1;

vehicles = 2;

demands = [0, 19, 21, 6, 19, 7];

service_time_per_demand=3;

max_vehicle_capacity = 60;



[total_distance, routes,distances, total_time, times, status] = vrp( adj_matrix, vehicles, start, labels, demands, max_vehicle_capacity, service_time_per_demand);


assert_checkequal(total_distance, int32(6589));
assert_checkequal(routes,int32([1 3 1 0	0 0; 1 6 2 5 4 1));
assert_checkequal(distances, int32([1426 5163]));
assert_checkequal(total_time, int32([216]));
assert_checkequal(times, int32([63 153]));
assert_checkequal(status, int32([1]));
printf("\nTest Successful!\n");

