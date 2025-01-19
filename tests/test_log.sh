setup() {
  source "./utils/log.sh"
  last_printf=""
  printf(){
    # Global mock the printf function, capture all the parameters and save them to a variable last_printf
    last_printf="$*"
  }
}

teardown() {
  unset printf
}

test_log_error_should_printf() {
  # Given
  local message="This is an error"
  local expected='\033[0;31m🚫 [ERROR] This is an error \033[0m\n'

  # When
  log::error "$message"
  teardown

  # Then
  if [[ "$last_printf" != "$expected" ]]; then
    log::warn "Test failed \nExpected: \n'$expected'"
    log::warn "Actual value was: \n'$last_printf'"
    return 1
  fi
}

test_log_warn_should_printf() {
  # Given
  local message="This is a warning"
  local expected='\033[0;33m🔶 [WARN] This is a warning \033[0m\n'

  # When
  log::warn "$message"
  teardown

  # Then
  if [[ "$last_printf" != "$expected" ]]; then
    log::warn "Test failed \nExpected: \n'$expected'"
    log::warn "Actual value was: \n'$last_printf'"
    diff <(echo "$expected") <(echo "$last_printf")
    return 1
  fi
}