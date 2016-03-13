#!/usr/bin/env bash
with_echo() { echo "-- evaluating: $@"; eval "$@" ;}
export -f with_echo

with_echo "mimipass import"
with_echo "mimipass get test || true"
with_echo "echo inicial1234 | mimipass set test"
with_echo "mimipass get test"
with_echo "mimipass copy test"
with_echo "mimipass new-set test2"
with_echo "mimipass new-set test3 8"
with_echo "mimipass list"

with_echo "yes | mimipass delete test3 && [ ! -f test/test.enc ]"
with_echo "mimipass list"
with_echo "mimipass get test3 || true"

with_echo "yes | mimipass delete test test2 && [ ! -f test/test.enc ]"
with_echo "mimipass get test || true"
with_echo "mimipass get test2 || true"
with_echo "mimipass list || true"

with_echo "echo inicial4321 | mimipass set with/nested/scopes"
with_echo "mimipass get with/nested/scopes"

with_echo "echo passwordinference | mimipass set account/password"
with_echo "mimipass get account/password"
with_echo "mimipass get account"
with_echo "mimipass get account/"

with_echo "rm -rf test/.sandbox/*key.txt && mimipass export"
exit 0
