%%%-------------------------------------------------------------------
%% @doc emqx-backend-mysql top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(emqx_backend_mysql_sup).

-behaviour(supervisor).

-export([start_link/1]).

-export([init/1]).



start_link(Pools) ->
  supervisor:start_link({local, emqx_backend_mysql_sup},emqx_backend_mysql_sup, [Pools]).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional
init([Pools]) ->
  {ok, {{one_for_one, 10, 100}, [pool_spec(Pool, Env) || {Pool, Env} <- Pools]}}.

%% internal functions

pool_spec(Pool, Env) ->
  ecpool:pool_spec({emqx_backend_mysql, Pool}, emqx_backend_mysql:pool_name(Pool), emqx_backend_mysql_cli, Env).
