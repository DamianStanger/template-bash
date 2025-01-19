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

check_expected_vs_actual(){
  if [[ "$last_printf" != "$expected" ]]; then
    log::warn "Test failed: diff expected vs actual"
    diff <(echo "$expected") <(echo "$last_printf")
    return 1
  fi
}

test_log_blank_should_printf() {
  # Given
  local expected='\n'

  # When
  log::blank
  teardown

  # Then
  check_expected_vs_actual
}

test_log_error_should_printf() {
  # Given
  local message1="This is an"
  local message2="error"
  local expected='\033[0;31m🚫 [ERROR] This is an error\033[0m\n'

  # When
  log::error "$message1" "$message2"
  teardown

  # Then
  check_expected_vs_actual
}

test_log_warn_should_printf() {
  # Given
  local message="This is a warning"
  local expected='\033[0;33m🔶 [WARN] This is a warning\033[0m\n'

  # When
  log::warn "$message"
  teardown

  # Then
  check_expected_vs_actual
}

test_log_info_should_printf() {
  # Given
  local message="This is info"
  local expected='\033[1;36mℹ️ [INFO] This is info\033[0m\n'

  # When
  log::info "$message"
  teardown

  # Then
  check_expected_vs_actual
}

test_log_success_should_printf() {
  # Given
  local message="This is success"
  local expected='\033[0;32m✅ [OK] This is success\033[0m\n'

  # When
  log::success "$message"
  teardown

  # Then
  check_expected_vs_actual
}