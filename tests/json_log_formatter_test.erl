-module(json_log_formatter_test).
-include_lib("eunit/include/eunit.hrl").

application_progress_test() ->
    Report = #{label => {application_controller,progress},
               report => [{application,sasl},{started_at,nonode@nohost}]},

    Log = log_with_msg_report(Report),

    BinaryMessage = json_log_formatter:format(Log, #{}),

    Data = jsx:decode(BinaryMessage, [return_maps]),
    assert_path_has_value(Data, [<<"label">>, <<"application_controller">>], <<"progress">>),
    assert_path_has_value(Data, [<<"report">>, <<"application">>], <<"sasl">>),

    ok.

supervisor_progress_test() ->
    Report = #{label => {supervisor,progress},
               report => [
                 {supervisor,{local,sasl_safe_sup}},
                 {started,[
                    {pid, list_to_pid("<0.85.0>")},
                    {id,alarm_handler_a},
                    {mfargs,
                        {alarm_handler_b,start_link,[]}},
                    {restart_type,permanent},
                    {shutdown,2000},
                    {child_type,worker}]}
    ]},

    Log = log_with_msg_report(Report),

    BinaryMessage = json_log_formatter:format(Log, #{}),
    Data = jsx:decode(BinaryMessage, [return_maps]),

    assert_path_has_value(Data, [<<"label">>, <<"supervisor">>], <<"progress">>),
    assert_path_has_value(Data, [<<"report">>, <<"started">>, <<"pid">>], <<"<0.85.0>">>),
    assert_path_has_value(Data, [<<"report">>, <<"started">>, <<"child_type">>], <<"worker">>),
    assert_path_has_value(Data, [<<"report">>, <<"started">>, <<"id">>], <<"alarm_handler_a">>),
    assert_path_has_value(Data, [<<"report">>, <<"started">>, <<"mfargs">>],
        [<<"alarm_handler_b">>,<<"start_link">>,[]]),

    ok.

log_macro_test() ->
    Msg = "Custom log message",
    Report = {report,#{what => Msg}},
    Log = log_with_report(Report),

    BinaryMessage = json_log_formatter:format(Log, #{}),
    Data = jsx:decode(BinaryMessage, [return_maps]),

    % ?assertEqual(#{}, Data),
    assert_path_has_value(Data, [<<"what">>], Msg),

    ok.

assert_path_has_value(Data, [], Value) ->
    ?assertEqual(Data, Value);
assert_path_has_value(Data, [Key|Rest], Value) ->
    ?assert(maps:is_key(Key, Data)),
    NewData = maps:get(Key, Data),
    assert_path_has_value(NewData, Rest, Value).

log_with_msg_report(Report) ->
    #{level => test,
      msg => {report,Report},
      meta => #{}
    }.

log_with_report(Report) ->
    #{level => test,
      msg => Report,
      meta => #{}
    }.
