-module(jdlib_currying_sup).

-behaviour(supervisor).

% API export.
-export([start_link/0]).

% Callback functions export
-export([init/1]).

% Supervisor child declaration.
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%---------------------------------------------------------------------------------------------------
% API functions.
%---------------------------------------------------------------------------------------------------

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%---------------------------------------------------------------------------------------------------
% Callback functions.
%---------------------------------------------------------------------------------------------------

init([]) ->
    {ok, {{one_for_one, 5, 10}, []}}.

%---------------------------------------------------------------------------------------------------

