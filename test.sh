#!/usr/bin/env bash
set -euo pipefail

clean() {
    set +e
    test_fpr=$(gpg --list-secret-keys --with-colons --fingerprint test@test.com \
                      | sed -n 's/^fpr:::::::::\([[:alnum:]]\+\):/\1/p')
    gpg --batch --yes --delete-secret-keys $test_fpr 2>/dev/null

    test_fpr=$(gpg --list-keys --with-colons --fingerprint test@test.com \
                      | sed -n 's/^fpr:::::::::\([[:alnum:]]\+\):/\1/p')
    gpg --batch --yes --delete-keys $test_fpr 2>/dev/null

    rm -rf $MIMIPASS_HOME
    set -e
}

run_test() {
    if diff <(test/input.sh) <(cat test/output.txt); then
        echo -e "\e[0;32mEverything is fine :+1:\e[0m"
    else
        echo -e "\e[0;31mEverything is broken :sob:\e[0m"
    fi
}

prepare() {
    export script_dir=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
    cd $script_dir

    export MIMIPASS_HOME=test/.sandbox
    export MIMIPASS_RECIPIENT=test@test.com

    clean
    mkdir -p $MIMIPASS_HOME
    cp test/*key.txt $MIMIPASS_HOME
}

## Prepare to run the tests
prepare

trap "clean" SIGINT SIGKILL EXIT

## Run the tests
if [ "${1-}" = "remake-regression" ]; then
    result_file=test/output.txt
else
    result_file=test/.sandbox/output.txt
fi
./test/input.sh >$result_file 2>&1

if diff $result_file test/output.txt; then
    echo -e "\e[0;32mEverything is right and you're awesome\e[0m"
else
    echo -e "\e[0;31mEverything is broken and you're terrible\e[0m"
fi
