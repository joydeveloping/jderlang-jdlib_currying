jderlang-jdlib_currying is currying library written for erlang.
It is a part of jdlib library.

Usage:

If F is function F(A, B, C) = A + B + C then
G = pseudo_curry(F, []) is function G([A, B, C]) = A + B + C,
G = pseudo_curry(F, [1]) is function G([B, C]) = 1 + B + C,
G = pseudo_curry(F, [1, 2]) is function G([C]) = 3 + C,
G = pseudo_curry(F, [1, 2, 3]) is 6,
G = curry(F, []) is function G = F,
G = curry(F, [1]) is function G(B, C) = 1 + B + C,
G = curry(F, [1, 2]) is function G(C) = 3 + C,
G = curry(F, [1, 2, 3]) is 6.
