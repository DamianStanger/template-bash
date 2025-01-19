setup() {
  source "./utils/log.sh"
  last_printf=""
  printf(){
    # Global mock the printf function, capture all the parameters and save them to a variable last_printf
    last_printf="$*"
  }
}

teardown() {
  unset -f printf
}

test_log_blank_should_printf() {
  # Given
  local expected='\n'

  # When
  log::blank

  # Then
  assert_expected_vs_actual "$expected" "$last_printf"
}

test_log_error_should_printf() {
  # Given
  local message1="This is an"
  local message2="error"
  local expected='\033[0;31m🚫 [ERROR] This is an error\033[0m\n'

  # When
  log::error "$message1" "$message2"

  # Then
  assert_expected_vs_actual "$expected" "$last_printf"
}

test_log_warn_should_printf() {
  # Given
  local message="This is a warning"
  local expected='\033[0;33m🔶 [WARN] This is a warning\033[0m\n'

  # When
  log::warn "$message"

  # Then
  assert_expected_vs_actual "$expected" "$last_printf"
}

test_log_info_should_printf() {
  # Given
  local message="This is info"
  local expected='\033[1;36mℹ️ [INFO] This is info\033[0m\n'

  # When
  log::info "$message"

  # Then
  assert_expected_vs_actual "$expected" "$last_printf"
}

test_log_success_should_printf() {
  # Given
  local message="This is success"
  local expected='\033[0;32m✅ [OK] This is success\033[0m\n'

  # When
  log::success "$message"

  # Then
  assert_expected_vs_actual "$expected" "$last_printf"
}