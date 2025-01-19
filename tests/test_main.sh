setup() {
  source "./source/main.sh"
  last_echo=""
  echo(){
    # Global mock the echo function, capture all the parameters and save them to a variable last_echo
    last_echo="$*"
  }
  # Reset all environment variables
  unset FOOBAR_NAME
  unset FOO_OPTIONS
}
teardown() {
  unset -f echo
}

test_should_do_foo() {
  # Mocks
  do_the_foo() {
    if [[ "$1" != "aaa bbb" ]]; then
      log::warn "Test failed - expected 'aaa bbb' but got '$1'"
      return 1
    fi

    if [[ "$2" != "-a -b" ]]; then
      log::warn "Test failed - expected '-a -b' but got '$2'"
      return 1
    fi
  }

  # Given
  local FOOBAR_NAME="aaa bbb"
  local FOO_OPTIONS="-a -b"

  # When
  do_foo

  # Then
  assert_error_code_success $?
}

test_should_log_script_variables() {
  # Mocks
  local last_log=""
  log::info(){
    last_log="$last_log $*"
  }

  # Given
  local FOOBAR_NAME="aaa bbb"
  local FOO_OPTIONS="-a -b"

  # When
  log_script_variables
  teardown

  # Then
  expected=" FOOBAR_NAME: aaa bbb FOO_OPTIONS: -a -b"
  assert_expected_vs_actual "$expected" "$last_log"
}

test_should_exit_when_check_environment_variables_fails() {
  # Mocks
  local exit_called=0
  exit(){
    # mock the exit command, do nothing
    exit_called=1
  }

  # When
  check_environment_variables

  # Then
  unset -f exit # remove mock

  if [[ $exit_called -eq 0 ]]; then
    log::warn "Test failed - did not exit"
    return 1
  fi

}

test_should_not_exit_when_check_environment_variables_passes() {
  # Given
  local FOO_OPTIONS="-a -b"

  # When
  check_environment_variables
}

test_should_echo_help_text_when_calling_usage() {
  # When
  usage
  teardown

  # Then
  expected="usage: ./test.sh options

  This script is for ... well its a template ...
  The following environment variables should be set before running this script:
    - FOO_OPTIONS         - foo environment options

  OPTIONS:
     -h, --help            Show this message
     -f, --foobar-name     name of the foobar option
"

  assert_expected_vs_actual "$expected" "$last_echo"
}

test_should_exit_0_when_passed_help_flag_h() {
  # When
  (
    # run process_parameters in a subshell so it doesn't exit this script
    process_parameters "-h"

    log::warn "Test failed - did not exit"
    return 1
  )

  # Then
  assert_error_code_success $?
}

test_should_exit_0_when_passed_help_flag_help() {
  # When
  (
    # run process_parameters in a subshell so it doesn't exit this script
    process_parameters "--help"

    log::warn "Test failed - did not exit"
    return 1
  )

  # Then
  assert_error_code_success $?
}

test_should_exit_1_when_passed_random_flag() {
  # When
  (
    # run process_parameters in a subshell so it doesn't exit this script
    process_parameters "--random"

    log::warn "Test failed - did not exit"
    return 0
  )

  # Then
  assert_error_code_failure $?
}

test_should_exit_1_when_foobar_name_is_missing() {
  # When
  (
    # run process_parameters in a subshell so it doesn't exit this script
    process_parameters

    log::warn "Test failed - did not exit"
    return 0
  )

  # Then
  assert_error_code_failure $?
}

test_should_not_exit_when_foobar_name_is_present() {
  # When
  process_parameters "--foobar-name" "aaa bbb"

  # Then
  assert_error_code_success $?
}

test_should_not_exit_when_foobar_name_is_present_passed_in_shorthand() {
  #When
  process_parameters "-f" "name"

  # Then
  assert_error_code_success $?
}
