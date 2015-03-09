%% @doc
%% Tests for jdlib_currying.
%%
%% @author Alexey Rybakov

% Module name.
-module(jdlib_currying_test).

% Unit-test using.
-include_lib("eunit/include/eunit.hrl").

% Functions import.
-import(jdlib_currying,
        [pseudo_curry/2, pseudo_curry_1/2, curry/2, curry_1/2]).

%---------------------------------------------------------------------------------------------------
% Functions for currying tests.
%---------------------------------------------------------------------------------------------------

-spec sum_5(A :: number(), B :: number(), C :: number(), D :: number(), E :: number()) -> number().
%% @doc
%% Sum of 5 numbers.
sum_5(A, B, C, D, E) ->
    A + B + C + D + E.

%---------------------------------------------------------------------------------------------------

-spec list_3(A :: term(), B :: term(), C :: term()) -> list().
%% @doc
%% Construct list of 3 elements.
list_3(A, B, C) ->
    [A, B, C].

%---------------------------------------------------------------------------------------------------
% Tests.
%---------------------------------------------------------------------------------------------------

-spec pseudo_curry_test() -> ok.
%% @doc
%% Function pseudo_curry test.
pseudo_curry_test() ->
    Sum_5 = fun sum_5/5,
    Sum_5_0 = pseudo_curry(Sum_5, []),
    Sum_5_2 = pseudo_curry(Sum_5, [1, 2]),
    Sum_5_5 = pseudo_curry(Sum_5, [1, 2, 3, 4, 5]),
    ?assertThrow({too_many_arguments, _}, pseudo_curry(Sum_5, [1, 2, 3, 4, 5, 6])),
    ?assertThrow({badarg, _}, pseudo_curry(Sum_5, 10)),
    ?assertThrow({badarg, _}, pseudo_curry(Sum_5_5, [10])),
    ?assertEqual(15, Sum_5_0([1, 2, 3, 4, 5])),
    ?assertEqual(15, Sum_5_2([3, 4, 5])),
    ?assertEqual(15, Sum_5_5),
    ok.

%---------------------------------------------------------------------------------------------------

-spec pseudo_curry_1_test() -> ok.
%% @doc
%% Function pseudo_curry_1 test.
pseudo_curry_1_test() ->
    List_3 = fun list_3/3,
    List_3_1 = pseudo_curry_1(List_3, 1),
    List_3_2 = pseudo_curry_1(List_3_1, [2, 3]),
    ?assertThrow({badarg, _}, pseudo_curry(List_3_2, 4)),
    ?assertEqual([1, 2, 3], List_3_1([2, 3])),
    ?assertEqual([1, 2, 3], List_3_2),
    ok.

%---------------------------------------------------------------------------------------------------

-spec curry_test() -> ok.
%% @doc
%% Function curry test.
curry_test() ->
    Sum_5 = fun sum_5/5,
    Sum_5_0 = curry(Sum_5, []),
    Sum_5_1 = curry(Sum_5_0, [1]),
    Sum_5_3 = curry(Sum_5_1, [2, 3]),
    Sum_5_5 = curry(Sum_5, [1, 2, 3, 4, 5]),
    ?assertThrow({too_many_arguments, _}, curry(Sum_5, [1, 2, 3, 4, 5, 6])),
    ?assertThrow({badarg, _}, curry(Sum_5, 10)),
    ?assertThrow({badarg, _}, curry(Sum_5_5, [6])),
    ?assertEqual(15, Sum_5_0(1, 2, 3, 4, 5)),
    ?assertEqual(15, Sum_5_1(2, 3, 4, 5)),
    ?assertEqual(15, Sum_5_3(4, 5)),
    ?assertEqual(15, Sum_5_5),
    ok.

%---------------------------------------------------------------------------------------------------

-spec curry_1_test() -> ok.
%% @doc
%% Function curry_1 test.
curry_1_test() ->
    List_3 = fun list_3/3,
    List_3_1 = curry_1(List_3, 1),
    List_3_2 = curry_1(List_3_1, 2),
    List_3_3 = curry_1(List_3_2, 3),
    ?assertThrow({badarg, _}, pseudo_curry(List_3_3, 4)),
    ?assertEqual([1, 2, 3], List_3_1(2, 3)),
    ?assertEqual([1, 2, 3], List_3_2(3)),
    ?assertEqual([1, 2, 3], List_3_3),
    ok.

%---------------------------------------------------------------------------------------------------

-spec big_curry_test() -> ok.
%% @doc
%% Curry test for function with many arguments
%% (the function after currying has more than 8 arguments).
big_curry_test() ->
    F =
        fun(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P) ->
            A + B + C + D + E + F + G + H + I + J + K + L + M + N + O + P
        end,
    F2 = curry(F, [1, 2]),
    ?assertEqual(136, F2(3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)),
    ok.

%---------------------------------------------------------------------------------------------------

