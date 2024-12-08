#!/usr/bin/env bash

#
# Replaces the old markup with the new one.
#
# The replacement is done line by line and will only happen if the start and
# end markings are present on the same line.
#
# If any marking used has special characters, they must be properly escaped.
#
# @param string $1
# String that will change.
#
# @param string $2
# Old opening marking.
#
# @param string $3
# Old closing marking.
#
# @param string $4
# New opening marking.
#
# @param string $5
# New closing marking.
#
# @return string
shellNS_string_replace_markup() {
  local strReturn=""

  local strOriginal="${1}"
  local strOldMarkupIni="${2}"
  local strOldMarkupEnd="${3}"
  local strNewMarkupIni="${4}"
  local strNewMarkupEnd="${5}"


  if [ "${strOriginal}" == "" ] || [ "${strOldMarkupIni}" == "" ] || [ "${strOldMarkupEnd}" == "" ] || [ "${strNewMarkupIni}" == "" ] || [ "${strNewMarkupEnd}" == "" ]; then
    return 0
  fi
  if [ "${strOldMarkupIni}" == "${strNewMarkupIni}" ] || [ "${strOldMarkupEnd}" == "${strNewMarkupEnd}" ]; then
    return 0
  fi


  local strSelectedPlainText=""
  local strOldSelectedMarkup=""
  local strNewSelectedMarkup=""

  local intCount="0"
  local codeNL=$'\n'
  local strNewLine=""
  local strRawLine=""
  IFS=$'\n'
  while read -r strRawLine || [ -n "${strRawLine}" ]; do
    strNewLine="${strRawLine}"
    strSelectedPlainText=""

    while [[ "${strNewLine}" == *${strOldMarkupIni}[^[:space:]]* ]]; do
      ((intCount++))
      strSelectedPlainText="${strNewLine#*${strOldMarkupIni}}"
      if [[ ! "${strSelectedPlainText}" == *[^[:space:]]${strOldMarkupEnd}* ]] || [ "${intCount}" -gt "128" ]; then
        break
      fi
      strSelectedPlainText="${strSelectedPlainText%%${strOldMarkupEnd}*}"

      strOldSelectedMarkup="${strOldMarkupIni}${strSelectedPlainText}${strOldMarkupEnd}"
      strNewSelectedMarkup="${strNewMarkupIni}${strSelectedPlainText}${strNewMarkupEnd}"
      strNewLine="${strNewLine//${strOldSelectedMarkup}/${strNewSelectedMarkup}}"
    done

    strReturn+="${strNewLine}${codeNL}"
  done <<< "${strOriginal}"
  unset IFS


  echo "${strReturn:0: -1}"
}