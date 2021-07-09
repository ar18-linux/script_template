#!/usr/bin/env bash
# ar18

function update_git() {
  # Prepare script environment
  {
    # Function template version 2021-07-06_08:05:30
    # Get old shell option values to restore later
    local shell_options
    shopt -s inherit_errexit
    IFS=$'\n' shell_options=($(shopt -op))
    # Set shell options for this script
    set +x
    set -o pipefail
    set -eu
    local LD_PRELOAD_old
    LD_PRELOAD_old="${LD_PRELOAD}"
    LD_PRELOAD=
    local ret
    ret=0
  }
  ##############################FUNCTION_START#################################
  
  local target_path
  target_path="${1}"
  target_path="$(realpath "${target_path}")"
  if [ -d "${target_path}" ]; then
    handle_directory "${target_path}"
  #elif [ -f "${target_path}" ]; then
  #  handle_file "${target_path}"
  else
    read -p "UNKNOWN TYPE: [${target_path}]"
    exit 1
  fi
  
  ###############################FUNCTION_END##################################
  # Restore environment
  {
    set +x
    LD_PRELOAD="${LD_PRELOAD_old}"
    # Restore old shell values
    for option in "${shell_options[@]}"; do
      eval "${option}"
    done
  }
  
  return "${ret}"
  
}


function handle_directory() {
  # Prepare script environment
  {
    # Function template version 2021-07-06_08:05:30
    # Get old shell option values to restore later
    local shell_options
    shopt -s inherit_errexit
    IFS=$'\n' shell_options=($(shopt -op))
    # Set shell options for this script
    set +x
    set -o pipefail
    set -eu
    local LD_PRELOAD_old
    LD_PRELOAD_old="${LD_PRELOAD}"
    LD_PRELOAD=
    local ret
    ret=0
  }
  ##############################FUNCTION_START#################################
  
  local target_path
  target_path="${1}"
  shopt -s dotglob
  for item in "${target_path}/"*; do
    if [ -d "${item}" ]; then
      if [ "$(basename "${item}")" = ".git" ]; then
        echo "Processing ${item}"
        rsync -av "${script_dir}/git_template/" "${item}"
      else
        handle_directory "${item}"
      fi
    elif [ -f "${item}" ]; then
      local temp
    else
      echo "unknown: ${item}"
    fi
  done
  
  ###############################FUNCTION_END##################################
  # Restore environment
  {
    set +x
    LD_PRELOAD="${LD_PRELOAD_old}"
    # Restore old shell values
    for option in "${shell_options[@]}"; do
      eval "${option}"
    done
  }
  
  return "${ret}"
  
}
