log::blank() {
  printf "\n"
}

log::success() {
  local message="$*"
  local green="\033[0;32m"
  local default="\033[0m"

  printf "${green}✅ [OK] ${message:-}${default}\n"
}

log::warn() {
  local message="$*"
  local yellow="\033[0;33m"
  local default="\033[0m"

  printf "${yellow}🔶 [WARN] ${message:-}${default}\n"
}

log::info() {
  local message="$*"
  local blue="\033[1;36m"
  local default="\033[0m"

  printf "${blue}ℹ️ [INFO] ${message:-}${default}\n"
}

log::error() {
  local message="$*"
  local red="\033[0;31m"
  local default="\033[0m"

  printf "${red}🚫 [ERROR] ${message:-}${default}\n"
}