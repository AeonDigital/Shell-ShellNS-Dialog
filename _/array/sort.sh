#!/usr/bin/env bash

#
# Sort the values of an **array** or the keys of **assoc**.
#
# @param array|assoc $1
# Name of an array or an associative array that will be sorted.
#
# @param array $2
# Name of the array that will receive the sorted values.
#
# @param bool $3
# Enter **1** to sort the **assoc** values instead of the keys.
#
# @param bool $4
# Enter **1** to sort the array in reverse order.
#
# @return array
shellNS_array_sort() {
  local -n arrayOriginal="${1}"
  local -n arraySorted="${2}"
  local boolSortValues="0"
  local boolReverse="0"

  if [ "${3}" == "1" ]; then boolSortValues="1"; fi
  if [ "${4}" == "1" ]; then boolReverse="1"; fi

  local it=""
  local -a arraySortedKeys=()
  if [[ "$(declare -p "${1}" 2> /dev/null)" == "declare -a"* ]] || [ "${boolSortValues}" == "1" ]; then
    for it in "${!arrayOriginal[@]}"; do
      arraySortedKeys+=("${arrayOriginal[${it}]}")
    done
  else
    for it in "${!arrayOriginal[@]}"; do
      arraySortedKeys+=("${it}")
    done
  fi

  if [ "${boolReverse}" == "0" ]; then
    IFS=$'\n';
    arraySorted=($(for it in "${arraySortedKeys[@]}"; do echo "${it}"; done | sort))
    unset IFS;
  else
    IFS=$'\n';
    arraySorted=($(for it in "${arraySortedKeys[@]}"; do echo "${it}"; done | sort -r))
    unset IFS;
  fi

  return "0"
}