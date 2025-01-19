source "log.sh"

validation::check_variable_is_set() {
  local variable_name=$1
  local variable_value=$2

  if [[ -z $variable_value ]] ; then
    log::error "Parameter $variable_name is unset or set to the empty string. Use $0 --help for more details"
    exit 1
fi
}