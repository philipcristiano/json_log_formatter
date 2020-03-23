-module(json_log_formatter_test).
-include_lib("eunit/include/eunit.hrl").

application_progress_test() ->
    Report = #{label => {application_controller,progress},
               report => [{application,sasl},{started_at,nonode@nohost}]},

    Log = log_with_report(Report),

    BinaryMessage = json_log_formatter:format(Log, []),
    Data = jsx:decode(BinaryMessage, [return_maps]),

    assert_path_has_value(Data, [<<"label">>], <<"application_controller">>),
    assert_path_has_value(Data, [<<"application">>], <<"sasl">>),
    assert_path_has_value(Data, [<<"state">>], <<"progress">>),

    ok.


assert_path_has_value(Data, [Key], Value) ->
    ?assert(maps:is_key(Key, Data)),
    ?assertEqual(Value, maps:get(Key, Data)).


log_with_report(Report) ->
    #{level => test,
      msg => {report,Report},
      meta => #{}
    }.
