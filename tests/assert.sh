assert_expected_vs_actual(){
  if [[ "$1" != "$2" ]]; then
    log::warn "Test failed: diff expected vs actual"
    diff <(echo "$1") <(echo "$2")
    return 1
  fi
}

assert_error_code_success() {
  if [[ $1 -ne 0 ]]; then
    log::warn "Test failed - Expected zero error code, got $1"
    return 1
  fi
}

assert_error_code_failure() {
  if [[ $1 -eq 0 ]]; then
    log::warn "Test failed - Expected non-zero error code, got $1"
    return 1
  fi
}
