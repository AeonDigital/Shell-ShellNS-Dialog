#!/usr/bin/env bash

#
# Normalizes the line breaks of the **ansidown** string.
#
# It follows the same line-breaking rules set for **markdown**.
#
# @param string $1
# String thats will be normalized.
#
# @return string
shellNS_ansidown_normalize_breakline() {
  local strOriginalDocument=$(shellNS_string_trim_raw "${1}")
  if [ "${strOriginalDocument}" == "" ]; then
    return 0
  fi


  local codeNL=$'\n'
  local strReturn=""

  local boolHasContentInLastLine="0"
  local boolHasBreakLineMarkupInLastLine="0"



  local strRawLine=""
  local strTrimLine=""
  IFS=$'\n'
  while read -r strRawLine || [ -n "${strRawLine}" ]; do
    strTrimLine=$(shellNS_string_trim_raw "${strRawLine}")
    strTrimRLine=$(shellNS_string_trimR_raw "${strRawLine}")


    if [ "${strTrimLine}" == "" ]; then
      strReturn+="${codeNL}"
      if [ "${boolHasContentInLastLine}" == "1" ]; then
        strReturn+="${codeNL}"
      fi
      boolHasContentInLastLine="0"
      boolHasBreakLineMarkupInLastLine="0"

      continue
    fi


    if [ "${boolHasBreakLineMarkupInLastLine}" == "1" ]; then
      boolHasBreakLineMarkupInLastLine="0"
      strReturn+="${codeNL}"
    else
      if [ "${boolHasContentInLastLine}" == "1" ]; then
        strReturn+=" "
      fi
    fi


    strReturn+="${strTrimRLine}"
    boolHasContentInLastLine="1"
    if [ "${#strRawLine}" -ge "3" ] && [ "${strRawLine: -2}" == "  " ]; then
      strReturn+="  "
      boolHasBreakLineMarkupInLastLine="1"
    fi
    # fi
  done <<< "${strOriginalDocument}"
  unset IFS

  echo -n "${strReturn}"
}