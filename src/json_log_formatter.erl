-module(json_log_formatter).

-export([format/2]).


format(#{level:=Level, msg:={report,
                              #{label:={application_controller, AppStatus},
                              report:= AppReport}}, meta:=_Meta}, _FConfig) ->
    App = proplists:get_value(application, AppReport),
    jsx:encode(#{
        <<"level">> => Level,
        <<"label">> => <<"application_controller">>,
        <<"state">> => AppStatus,
        <<"application">> => App
    }).
