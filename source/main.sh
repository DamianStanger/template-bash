#!/bin/bash
set -e

source "./utils/log.sh"
source "./utils/validation.sh"

usage () {
  echo "usage: $0 options

  This script is for ... well its a template ...
  The following environment variables should be set before running this script:
    - FOO_OPTIONS         - foo environment options

  OPTIONS:
     -h, --help            Show this message
     -f, --foobar-name     name of the foobar option
"
}

check_environment_variables() {
  if [[ -z $FOO_OPTIONS ]] ; then
    log::error "Not all required environment variables are set"
    usage
    exit 1
  fi
}

process_parameters() {
  while [[ "$#" -gt 0 ]]; do
    case $1 in
      -h | --help )
        usage
        exit
      ;;
      -f | --foobar-name)
        FOOBAR_NAME="$2"
        validation::check_variable_is_set "FOOBAR_NAME" $FOOBAR_NAME
        shift 2
      ;;
      *)
        log::error "Unknown parameter passed: $1"
        usage
        exit 1
      ;;
    esac
  done

  # Check for required parameters
  if [[ -z $FOOBAR_NAME ]] ; then
    log::error "All required parameters are not passed"
    usage
    exit 1
  fi
}

do_foo() {
   do_the_foo "$FOOBAR_NAME" "$FOO_OPTIONS"
}

log_script_variables() {
  # List non sensitive script parameters and environment variables

  log::info "FOOBAR_NAME: $FOOBAR_NAME"
  log::info "FOO_OPTIONS: $FOO_OPTIONS"
}

main() {
  local FOOBAR_NAME=""

  process_parameters "$@"
  check_environment_variables

  log_script_variables

  do_foo
}

# only execute main if we are running this from the command line
if [ $(basename "$0") = $(basename "$BASH_SOURCE") ] ; then
  main "$@"
fi

