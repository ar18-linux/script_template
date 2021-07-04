#!/bin/bash
# ar18


function run() {
  # Function template 2021-06-13
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
  # Function template 2021-06-13
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
  for item in "${target_path}/"*; do
      if [ -f "${item}" ]; then
        if [[ "${item}" == *.sh ]]; then
          handle_file "${item}"
        fi
      elif [ -d "${item}" ]; then
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
  local check
  check="$(sed "2!d" "${filepath}")"
  if [ "${check}" = "# ar18" ]; then
    echo "Processing ${filepath}"
    update_functions "${filepath}"
    update_script "${filepath}"
  fi
}


function init_template_script_wrapper() {
  # Function template 2021-06-13
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
  
  if [ ! -v script_part_1 ] || [ ! -v script_part_2 ]; then
    current_date="$(cat "${script_dir}/VERSION")"
    local line_no
    line_no=0
    local script_dir
    script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    while IFS= read -r line; do
      line_no=$((line_no + 1))
      if [ "${line}" = "#################################SCRIPT_START##################################" ]; then
        script_part_1="$(tail -n "+1" "${script_dir}/script_template" | head -n "$((line_no - 1 + 1))")"
        export script_part_1="${script_part_1/@@VERSION@@/${current_date}}"
      elif [ "${line}" = "##################################SCRIPT_END###################################" ]; then
        export script_part_2="$(tail -n "+${line_no}" "${script_dir}/script_template")"
        break
      fi
    done < "${script_dir}/script_template"
  fi
  
  ###############################FUNCTION_END##################################
  set +x
  for option in "${shell_options[@]}"; do
    eval "${option}"
  done
  LD_PRELOAD="${LD_PRELOAD_old}"
  return "${ret}"
}


function init_template_function_wrapper() {
  # Function template 2021-06-13
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
        body_part_1="$(tail -n "+2" "${script_dir}/function_template" | head -n "$((line_no - 2 + 1))")"
        export body_part_1="${body_part_1/@@VERSION@@/${current_date}}"
      elif [ "${line}" = "  ###############################FUNCTION_END##################################" ]; then
        export body_part_2="$(tail -n "+${line_no}" "${script_dir}/function_template")"
      fi
    done < "${script_dir}/function_template"
  fi
  
  ###############################FUNCTION_END##################################
  set +x
  for option in "${shell_options[@]}"; do
    eval "${option}"
  done
  LD_PRELOAD="${LD_PRELOAD_old}"
  return "${ret}"
}


function update_script() {
  # Function template 2021-06-13
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
  init_template_script_wrapper
  local script_start
  script_start="0"
  local script_end
  script_end="0"
  rm -f "${filepath}_bak"
  touch "${filepath}_bak"
  local line_no
  line_no=0
  while IFS= read -r line; do
    line_no=$((line_no + 1))
    if [ "${line}" = "#################################SCRIPT_START##################################" ]; then
      script_start="$((line_no + 1))"
    elif [ "${line}" = "##################################SCRIPT_END###################################" ]; then
      script_end="$((line_no - 1))"
    fi
    if [ "${script_end}" != "0" ]; then
      if [ "${script_start}" != "0" ]; then
        echo "${script_part_1}" >> "${filepath}_bak"
        echo "$(tail -n "+${script_start}" "${filepath}" | head -n "$((script_end - script_start + 1))")" >> "${filepath}_bak"
        # TODO: Somehow, newlines are completely removed between end of script and footer. This is just a patch, not a solution
        echo '' >> "${filepath}_bak"
        echo "${script_part_2}" >> "${filepath}_bak"
        mv "${filepath}_bak" "${filepath}"
        break 
      else
        break
      fi
    fi
  done < "${filepath}"
  
  rm -f "${filepath}_bak"
  
  ###############################FUNCTION_END##################################
  set +x
  for option in "${shell_options[@]}"; do
    eval "${option}"
  done
  LD_PRELOAD="${LD_PRELOAD_old}"
  return "${ret}"
}


function update_functions() {
  # Function template 2021-06-13
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
      if [ "${function_start}" != "0" ]; then
        if [ "${body_start}" != "0" ] && [ "${body_end}" != "0" ]; then
          echo "$(sed "${function_start}!d" "${filepath}")" >> "${filepath}_bak"
          echo "${body_part_1}" >> "${filepath}_bak"
          echo "$(tail -n "+${body_start}" "${filepath}" | head -n "$((body_end - body_start + 1))")" >> "${filepath}_bak"
          echo "${body_part_2}" >> "${filepath}_bak"
        else
          echo "$(tail -n "+${function_start}" "${filepath}" | head -n "$((function_end - function_start + 1))")" >> "${filepath}_bak"
        fi
      else
        echo "${line}" >> "${filepath}_bak"
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
