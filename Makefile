PROJECT = json_log_formatter
PROJECT_DESCRIPTION = Erlang JSON Log Formatter
PROJECT_VERSION = 0.0.1

BUILD_DEPS = elvis_mk jsx
DEP_PLUGINS = elvis_mk
TEST_DIR = tests

dep_elvis_mk = git https://github.com/inaka/elvis.mk.git 1.0.0
dep_jsx = git https://github.com/talentdeficit/jsx.git v2.10.0


include erlang.mk
