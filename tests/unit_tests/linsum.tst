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


//A simple linear sum test problem
// Ref : http://www.hungarianalgorithm.com/examplehungarianalgorithm.php

kNumLeftNodes = 4;
kNumRightNodes = 4;
kCost = [82, 83, 69, 92; 77, 37, 49, 92; 11, 69, 5, 86; 8, 9, 98, 23];

//Calling the routine
[cost, assignment, status] = linsum(kNumLeftNodes, kNumRightNodes, kCost);

assert_checkequal(cost,[140]);
assert_checkequal(assignment,[%F %F %T %F;%F %T %F %F;%T %F %F %F;%F %F %F %T]);
assert_checkequal(status,[1]);
printf("\nTest Successful!\n");