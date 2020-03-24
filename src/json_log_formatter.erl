-module(json_log_formatter).

-export([format/2]).


format(#{level:=_Level,
       msg:={report, ReportMap},
       meta:=_Meta}, _FConfig) when is_map(ReportMap) ->
    TermMap = termify_map(ReportMap),
    jsx:encode(TermMap).

termify_map(Map) when is_map(Map) ->
    maps:fold(fun encode_map/3, #{}, Map).

encode_map(K, V, AccIn) when is_map(V) ->
    ValueMap = termify_map(V),
    maps:put(K, ValueMap, AccIn);
encode_map(K, V, AccIn) when is_list(V) ->
    Map = maps:from_list(V),
    ValueMap = termify_map(Map),
    maps:put(K, ValueMap, AccIn);
encode_map(K, {A, B, C}, AccIn) ->
    % This triplet can cause problems in jsx:is_term/1
    % as it sometimes gets parsed as a date/time
    NewValue = encode_non_term({A, B, C}),
    maps:put(K, NewValue, AccIn);
encode_map(K, V, AccIn) ->
    NewValue = case jsx:is_term(V) of
        true -> V;
        false -> encode_non_term(V)
    end,
    maps:put(K, NewValue, AccIn).

encode_non_term(L) when is_list(L) ->
    M = maps:from_list(L),
    termify_map(M);
encode_non_term(P) when is_pid(P) ->
    pid_to_list(P);
encode_non_term({A, B, C}) ->
    [A, B, C];
encode_non_term({A, B}) ->
    #{A => B}.
