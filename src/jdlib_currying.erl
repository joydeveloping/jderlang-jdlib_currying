%% @doc
%% Functions currying.
%%
%% Copyright Joy Developing.

% Module name.
-module(jdlib_currying).

% Export.
-export([pseudo_curry/2, pseudo_curry_1/2, curry/2, curry_1/2]).

%---------------------------------------------------------------------------------------------------
% Change function arity function.
%---------------------------------------------------------------------------------------------------

-spec expand_args_list(F :: fun((list()) -> term()), Arity :: integer()) -> fun().
%% @doc
%% Transform function of list to function of several arguments.
%% Function works only for arity from 1 to 8.
%% If next Erlang version will support possibility of creating arbitrary arity funs
%% then this place should be corrected.
expand_args_list(Fun, 1) ->
    fun(A) ->
        Fun([A])
    end;
expand_args_list(Fun, 2) ->
    fun(A, B) ->
        Fun([A, B])
    end;
expand_args_list(Fun, 3) ->
    fun(A, B, C) ->
        Fun([A, B, C])
    end;
expand_args_list(Fun, 4) ->
    fun(A, B, C, D) ->
        Fun([A, B, C, D])
    end;
expand_args_list(Fun, 5) ->
    fun(A, B, C, D, E) ->
        Fun([A, B, C, D, E])
    end;
expand_args_list(Fun, 6) ->
    fun(A, B, C, D, E, F) ->
        Fun([A, B, C, D, E, F])
    end;
expand_args_list(Fun, 7) ->
    fun(A, B, C, D, E, F, G) ->
        Fun([A, B, C, D, E, F, G])
    end;
expand_args_list(Fun, 8) ->
    fun(A, B, C, D, E, F, G, H) ->
        Fun([A, B, C, D, E, F, G, H])
    end;
expand_args_list(Fun, N) ->
    [Arg_H | Args_T] =
        lists:map
        (
            fun(Num) ->
                lists:flatten(io_lib:format("A~p", [Num]))
            end,
            lists:seq(1, N)
        ),
    Args_Str =
        lists:foldl
        (
            fun(A, Acc) ->
                Acc ++ ", " ++ A
            end,
            Arg_H,
            Args_T
        ),
    Fun_Str =
        "fun(F) ->"
        ++ "fun(" ++ Args_Str ++ ") ->"
        ++ "F([" ++ Args_Str ++ "])"
        ++ "end end.",
    {ok, Scan, _} = erl_scan:string(Fun_Str),
    {ok, Parse} = erl_parse:parse_exprs(Scan),
    {value, Meta_Fun, _} = erl_eval:exprs(Parse, []),
    Meta_Fun(Fun).

%---------------------------------------------------------------------------------------------------
% Pseudo curry functions.
%---------------------------------------------------------------------------------------------------

-spec pseudo_curry(F :: fun(), Args :: list()) -> fun((list()) -> term()).
%% @doc
%% Function pseudo currying by applying list of arguments.
%% Function currying by applying list of arguments.
%% Arguments of this function are:
%%   - function F of n arguments,
%%   - list Args (Args(1), Args(2),.. Args(m)) of first m actual arguments (m <= n).
%% Result of this function is new function G with one (!) argument - list of remain arguments.
%% G([A(1),.. A(n - m)]) = F(Args(1),.. Args(m), A(1),.. A(n - m)).
pseudo_curry(F, Args) when (is_function(F) andalso is_list(Args)) ->
    {arity, Arity} = erlang:fun_info(F, arity),
    Args_Count = length(Args),

    if
        % Result is new function.
        Args_Count < Arity ->
            fun(Remain) ->
                apply(F, Args ++ Remain)
            end;

        % Too many arguments.
        Args_Count > Arity ->
            throw({too_many_arguments, Args});

        % All actual argumens is passed to currying function.
        % So we can get final result (or error when too many arguments are passed).
        true ->
            apply(F, Args)
    end;

pseudo_curry(F, Args) ->
    throw({badarg, {F, Args}}).

%---------------------------------------------------------------------------------------------------

-spec pseudo_curry_1(F :: fun(), T :: term()) -> fun((list()) -> term()).
%% @doc
%% Function pseudo currying by applying only one argument.
pseudo_curry_1(F, T) ->
    pseudo_curry(F, [T]).

%---------------------------------------------------------------------------------------------------
% Curry functions.
%---------------------------------------------------------------------------------------------------

-spec curry(F :: fun(), Args :: list()) -> fun().
%% @doc
%% Function currying by applying list of arguments.
%% Arguments of this function are:
%%   - function F of n arguments,
%%   - list Args (Args(1), Args(2),.. Args(m)) of first m actual arguments (m <= n).
%% Result of this function is new function G with n - m arguments.
%% G(A(1),.. A(n - m)) = F(Args(1),.. Args(m), A(1),.. A(n - m)).
curry(F, Args) ->
    Curried_F = pseudo_curry(F, Args),
    {arity, Arity} = erlang:fun_info(F, arity),
    New_Arity = Arity - length(Args),

    % If result is function we need to expand its arguments list.
    % Otherwise we have to return calculated result.
    if
        New_Arity =:= 0 ->
            Curried_F;
        true ->
            expand_args_list(Curried_F, New_Arity)
    end.

%---------------------------------------------------------------------------------------------------

-spec curry_1(F :: fun(), T :: term()) -> fun().
%% @doc
%% Function currying by applying only one argument.
curry_1(F, T) ->
    curry(F, [T]).

%---------------------------------------------------------------------------------------------------

