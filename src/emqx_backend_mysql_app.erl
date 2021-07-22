%%%-------------------------------------------------------------------
%% @doc emqx-backend-mysql public API
%% @end
%%%-------------------------------------------------------------------

-module(emqx_backend_mysql_app).

-behaviour(application).

-emqx_plugin(backend).


-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Pools = application:get_env(emqx_backend_mysql, pools,[]),

    {ok, Sup} = emqx_backend_mysql_sup:start_link(Pools),

    emqx_backend_mysql:register_metrics(),

    emqx_backend_mysql:load(),

    {ok, Sup}.

stop(_State) -> emqx_backend_mysql:unload().
