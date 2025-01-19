restore_required_functions() {
  #sometimes tests mock out the required functions that assert needs, this puts them back
  unset -f echo
  unset -f printf
  unset -f exit
  source "./utils/log.sh"
}

assert_expected_vs_actual(){
  restore_required_functions
  if [[ "$1" != "$2" ]]; then
    log::warn "Test failed: diff expected vs actual"
    diff <(echo "$1") <(echo "$2")
    return 1
  fi
}

assert_error_code_success() {
  restore_required_functions
  if [[ $1 -ne 0 ]]; then
    log::warn "Test failed - Expected zero error code, got $1"
    return 1
  fi
}

assert_error_code_failure() {
  restore_required_functions
  if [[ $1 -eq 0 ]]; then
    log::warn "Test failed - Expected non-zero error code, got $1"
    return 1
  fi
}
