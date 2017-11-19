// Copyright (C) 2017 - IIT Bombay - FOSSEE
//
// Author:	Souvik Das
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


//A simple min-cost-flow example

//	Before balancing (Infeasible):
//	kNumSources = 4;
//	kNumTargets = 4;
//	kCost = [4, 6, 8, 13; 13, 11, 10, 8; 14, 4, 10, 13; 9, 11, 13, 8];
//	kCapacity = [200, 200, 200, 200; 200, 200, 200, 200; 200, 200, 200, 200; 200, 200, 200, 200];
//	kSupply = [50, 70, 30, 50];
//	kDemand = [25, 35, 105, 20];
//	[cost, flow, status] = min_cost_flow(kNumSources, kNumTargets, kCost, kCapacity, kSupply, kDemand);

//	After balancing (Optimal):


kNumSources = 4;
kNumTargets = 5;
kCost = [4, 6, 8, 13, 0; 13, 11, 10, 8, 0; 14, 4, 10, 13, 0; 9, 11, 13, 8, 0];
kCapacity = [200, 200, 200, 200, 200; 200, 200, 200, 200, 200; 200, 200, 200, 200, 200; 200, 200, 200, 200, 200];
kSupply = [50, 70, 30, 50];
kDemand = [25, 35, 105, 20, 15];
[cost, flow, status] = min_cost_flow(kNumSources, kNumTargets, kCost, kCapacity, kSupply, kDemand);


assert_checkequal(cost,[1465]); //We can check for equality rather than 'close' as cost is supposed to be integral(as specified by the typedef in Google OR tools)
assert_checkequal(flow,[25    0     25    0    0;  
    0     0     70    0     0;   
    0     30    0     0     0;  
    0     5     10    20   15]);
assert_checkequal(status,[1]);
printf("\nTest Successful!\n");
