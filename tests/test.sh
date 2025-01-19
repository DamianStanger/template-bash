#!/bin/bash
source "./utils/log.sh"

run_tests_in_file() {
  #remove the function setup if it exists
  setup () {
    return 0
  }

  source $1

  #run all functions that start with test_
  for test in $(compgen -A function | grep -E '^test_'); do
    tests_run=$((tests_run+1))

    # Reset the environment between tests
    setup

    # do not exit when commands return non-zero, we want the tests to catch this and handle it
    set +e
    log::info "Running  $test"

    # Reset all environment variables
    unset FOOBAR_NAME
    unset FOO_OPTIONS

    # Run the test
    $test

    # Check the result
    if [[ $? -eq 0 ]]; then
      log::success "  ✔️ Passed"
      tests_succeeded=$((tests_succeeded+1))
    else
      log::error "❌ Failed"
      tests_failed=$((tests_failed+1))
    fi
  done
}

run_all_test_files() {
  for file in $(find . -name "test_*.sh"); do
    test_files=$((test_files+1))
    log::blank
    log::info "Running tests in $file"
    run_tests_in_file $file
  done
}


main() {
  local start_time=$(date +%s)
  local test_files=0
  local tests_run=0
  local tests_failed=0
  local tests_succeeded=0

  run_all_test_files

  local end_time=$(date +%s)
  local tot_time=$((end_time - start_time))

  log::info    "--------------------"
  log::info    " Test Summary"
  log::info    " Files checked: [$test_files]"
  log::info    " Tests run:     [$tests_run]"
  log::success "   Tests success: [$tests_succeeded]"
  log::error   "Tests failed:  [$tests_failed]"
  log::info    " Total time:    [$tot_time seconds]"
  log::info    "--------------------"


  if [[ $tests_failed -gt 0 ]]; then
    exit 1
  fi
}

main