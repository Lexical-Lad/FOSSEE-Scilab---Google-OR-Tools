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


//A simple Travelling Saleman Problem Example(optimal solution exists). Refer to the documentation of the function for more details on the same example

//defining the adjacency matrix
adj=[0 10 15 20;
10 0 35 25;
15 35 0 30;
20 25 30 0];

//specifying the start node
start_node=1;
 
labels=['A' 'B' 'C' 'D'];

//calling the routine
[mincost,path,status]=tsp(adj,start_node,labels);


assert_checkequal(mincost,int32[80]);
assert_checkequal(path,int32[1 2 4 3 1]);
assert_checkequal(status,int32[1]);
printf("\n Test Successful!\n");


