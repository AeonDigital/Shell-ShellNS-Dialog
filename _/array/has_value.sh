#!/usr/bin/env bash

#
# Identifies whether the value sought exists between the values of the
# indicated array.
#
# By default, it performs case-sensitive comparisons.
#
# @param array|assoc $1
# Array where the query will be made.
#
# @param string $2
# Value that is being researched.
#
# @param ?bool $3
# ::
#   - default : "0"
#   - list    : SHELLNS_PROMPT_OPTION_BOOL
# ::
# Indicate **1** if you want comparisons to be made in case insensitive.
#
# @return bool
shellNS_array_has_value() {
  local boolReturn="0"
  local -n arrTargetData="${1}"
  local strSearch="${2}"
  local boolCaseInsensitive="${3}"

  if [ "${boolCaseInsensitive}" == "1" ]; then
    strSearch="${strSearch,,}"
  fi

  local k=""
  local v=""
  for k in "${!arrTargetData[@]}"; do
    v="${arrTargetData[$k]}"

    if [ "${boolCaseInsensitive}" == "1" ]; then
      v="${v,,}"
    fi

    if [ "${v}" == "${strSearch}" ]; then
      boolReturn="1"
      break
    fi
  done

  echo -ne "${boolReturn}"
}