#!/usr/bin/env bash

#
# Normalizes the predefined data blocks for **ansidown**.
#
# @param string $1
# String thats will be normalized.
#
# @return string
shellNS_ansidown_normalize_blocks() {
  local strOriginalDocument=$(shellNS_string_trim_raw "${1}")
  if [ "${strOriginalDocument}" == "" ]; then
    return 0
  fi


  local codeNL=$'\n'
  local strReturn=""

  local isIgnoreNextEmptyLines="0"

  local boolOpenBlockProperties="0"
  local boolOpenBlockList="0"
  local boolOpenBlockCode="0"


  local strRawLine=""
  local strTrimLine=""
  IFS=$'\n'
  while read -r strRawLine || [ -n "${strRawLine}" ]; do
    strTrimLine=$(shellNS_string_trim_raw "${strRawLine}")


    #
    # ignore empty lines
    if [ "${isIgnoreNextEmptyLines}" == "1" ]; then
      if [ "${strTrimLine}" == "" ]; then
        continue
      fi
      isIgnoreNextEmptyLines="0"
    fi



    #
    # empty line
    if [ "${strTrimLine}" == "" ]; then
      boolOpenBlockList="0"

      strReturn+="${codeNL}"
      continue
    fi



    #
    # subsection definition line
    if [[ "${strTrimLine}" =~ ^@[a-zA-Z]+ ]]; then
      strReturn+="${strTrimLine}  ${codeNL}"
      isIgnoreNextEmptyLines="1"
      continue
    fi



    #
    # properties block ini/end
    if [ "${strTrimLine}" == "::" ]; then
      if [ "${boolOpenBlockProperties}" == "0" ]; then
        boolOpenBlockProperties="1"
        strReturn+="::  ${codeNL}"
      else
        boolOpenBlockProperties="0"
        strReturn+="::${codeNL}${codeNL}"
      fi
      isIgnoreNextEmptyLines="1"
      continue
    fi
    #
    # propertie definition line
    if [ "${boolOpenBlockProperties}" == "1" ]; then
      isIgnoreNextEmptyLines="1"
      strReturn+="  ${strTrimLine}  ${codeNL}"
      continue
    fi



    #
    # code block ini/end
    if [ "${strTrimLine:0:3}" == "\`\`\`" ]; then
      if [ "${boolOpenBlockCode}" == "0" ]; then
        boolOpenBlockCode="1"
        strReturn+="${strTrimLine}  ${codeNL}"
      else
        boolOpenBlockCode="0"
        strReturn+="\`\`\`  ${codeNL}"
      fi
      continue
    fi
    #
    # code line
    if [ "${boolOpenBlockCode}" == "1" ]; then
      strTrimLine=$(shellNS_string_trimR_raw "${strRawLine}")
      strReturn+="${strTrimLine}  ${codeNL}"
      continue
    fi



    #
    # list item line
    if [ "${#strTrimLine}" -ge "3" ] && [ "${strTrimLine:0:2}" == "- " ]; then
      boolOpenBlockList="1"

      strTrimLine=$(shellNS_string_trimR_raw "${strRawLine}")
      strReturn+="${strTrimLine}  ${codeNL}"
      continue
    fi
    #
    # list line
    if [ "${boolOpenBlockList}" == "1" ]; then
      strTrimLine=$(shellNS_string_trimR_raw "${strRawLine}")
      strReturn+="${strTrimLine}  ${codeNL}"
      continue
    fi



    strReturn+="${strRawLine}${codeNL}"
  done <<< "${strOriginalDocument}"
  unset IFS


  if [ "${strReturn}" == "" ]; then
    return 11
  fi
  echo -n "${strReturn}"
}