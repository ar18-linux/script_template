#!/bin/bash


function run() {
  # Function template 2021-06-12.01
  local LD_PRELOAD_old
  LD_PRELOAD_old="${LD_PRELOAD}"
  LD_PRELOAD=
  local shell_options
  IFS=$'\n' shell_options=($(shopt -op))
  set -eu
  set -o pipefail
  local ret
  ret=0
  set +x
  ##############################FUNCTION_START#################################
  
  local target_path
  target_path="${1}"
  handle_directory "${target_path}"
  
  ###############################FUNCTION_END##################################
  set +x
  for option in "${shell_options[@]}"; do
    eval "${option}"
  done
  LD_PRELOAD="${LD_PRELOAD_old}"
  return "${ret}"
}


function handle_directory() {
  # Function template 2021-06-12.01
  local LD_PRELOAD_old
  LD_PRELOAD_old="${LD_PRELOAD}"
  LD_PRELOAD=
  local shell_options
  IFS=$'\n' shell_options=($(shopt -op))
  set -eu
  set -o pipefail
  local ret
  ret=0
  set +x
  ##############################FUNCTION_START#################################
  
  local target_path
  target_path="${1}"
  for item in "${target_path}"/*; do
      if [ -f "${item}" ]; then
        if [[ "${item}" == *.sh ]]; then
          echo "file: ${item}"
          handle_file "${item}"
        fi
      elif [ -d "${item}" ]; then
        echo "dir: ${item}"
        handle_directory "${item}"
      else
        echo "unknown: ${item}"
      fi
  done
  
  ###############################FUNCTION_END##################################
  set +x
  for option in "${shell_options[@]}"; do
    eval "${option}"
  done
  LD_PRELOAD="${LD_PRELOAD_old}"
  return "${ret}"
}


function handle_file() {
  local filepath
  filepath="${1}"
  rm -f "${filepath}_bak"
  update_functions "${filepath}"
  
}


function init_template_function_wrapper() {
  # Function template 2021-06-12.01
  local LD_PRELOAD_old
  LD_PRELOAD_old="${LD_PRELOAD}"
  LD_PRELOAD=
  local shell_options
  IFS=$'\n' shell_options=($(shopt -op))
  set -eu
  set -o pipefail
  local ret
  ret=0
  set +x
  ##############################FUNCTION_START#################################
  
  if [ ! -v body_part_1 ] || [ ! -v body_part_2 ]; then
    current_date="$(date +%F)"
    local line_no
    line_no=0
    local script_dir
    script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    while IFS= read -r line; do
      line_no=$((line_no + 1))
      if [ "${line}" = "  ##############################FUNCTION_START#################################" ]; then
        body_part_1="$(tail -n "+2" "${script_dir}/function_template.sh" | head -n "$((line_no - 2 + 1))")"
        export body_part_1="${body_part_1/\$DATE\$/${current_date}}"
      elif [ "${line}" = "  ###############################FUNCTION_END##################################" ]; then
        export body_part_2="$(tail -n "+${line_no}" "${script_dir}/function_template.sh")"
      fi
    done < "${script_dir}/function_template.sh"
  fi
  
  ###############################FUNCTION_END##################################
  set +x
  for option in "${shell_options[@]}"; do
    eval "${option}"
  done
  LD_PRELOAD="${LD_PRELOAD_old}"
  return "${ret}"
}


function update_functions() {
  # Function template 2021-06-12.01
  local LD_PRELOAD_old
  LD_PRELOAD_old="${LD_PRELOAD}"
  LD_PRELOAD=
  local shell_options
  IFS=$'\n' shell_options=($(shopt -op))
  set -eu
  set -o pipefail
  local ret
  ret=0
  set +x
  ##############################FUNCTION_START#################################
  
  local filepath
  filepath="${1}"
  init_template_function_wrapper
  local function_start
  function_start="0"
  local body_start
  body_start="0"
  local body_end
  body_end="0"
  local function_end
  function_end="0"
  rm -f "${filepath}_bak"
  touch "${filepath}_bak"
  local line_no
  line_no=0
  while IFS= read -r line; do
    echo "${line}"
    line_no=$((line_no + 1))
    if [[ "${line}" == function* ]]; then
      function_start="${line_no}"
    elif [ "${line}" = "  ##############################FUNCTION_START#################################" ]; then
      body_start="$((line_no + 1))"
    elif [ "${line}" = "  ###############################FUNCTION_END##################################" ]; then
      body_end="$((line_no - 1))"
    elif [[ "${line}" == }* ]]; then
      function_end="${line_no}"
    fi
    if [ "${function_start}" = "0" ]; then
      echo "${line}" >> "${filepath}_bak"
    fi
    if [ "${function_end}" != "0" ]; then
      if [ "${function_start}" = "0" ]; then
        read -p "Missing function start"
        exit 1
      fi
      if [ "${body_start}" != "0" ] && [ "${body_end}" != "0" ]; then
        echo "$(sed "${function_start}!d" "${filepath}")" >> "${filepath}_bak"
        echo "${body_part_1}" >> "${filepath}_bak"
        echo "$(tail -n "+${body_start}" "${filepath}" | head -n "$((body_end - body_start + 1))")" >> "${filepath}_bak"
        echo "${body_part_2}" >> "${filepath}_bak"
      else
        echo "$(tail -n "+${function_start}" "${filepath}" | head -n "$((function_end - function_start + 1))")" >> "${filepath}_bak"
      fi
      function_start="0"
      body_start="0"
      body_end="0"
      function_end="0"
    fi
  done < "${filepath}"
  mv "${filepath}_bak" "${filepath}"
  
  ###############################FUNCTION_END##################################
  set +x
  for option in "${shell_options[@]}"; do
    eval "${option}"
  done
  LD_PRELOAD="${LD_PRELOAD_old}"
  return "${ret}"
}
