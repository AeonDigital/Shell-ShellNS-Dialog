#!/usr/bin/env bash

#
# Prepares the list of options to be presented to the user.
#
# @param assoc $1
# Name of an associative array that contains the accepted values and their
# respective labels.
#
# @param bool $2
# Enter **1** to ignore the values and use only the keys from the array of
# valid values.
#
# @return string
shellNS_prompt_prepareOptions() {
  local k=""
  local v=""
  local strOptionTips=""

  local -n assocOptionList="${1}"
  local -a assocOptionListSortedKeys=()
  shellNS_array_sort "${1}" "assocOptionListSortedKeys"

  local boolIgnoreValues="0"
  if [ "${2}" == "1" ]; then boolIgnoreValues="1"; fi

  local codeFontReset="${SHELLNS_FONT_RESET}"
  local codeColorBrackets="${SHELLNS_PROMPT_COLOR_BRACKETS}"
  local codeColorValue="${SHELLNS_PROMPT_COLOR_VALUE}"
  local codeColorLabel="${SHELLNS_PROMPT_COLOR_LABEL}"
  local strPromptTextIndent="${SHELLNS_PROMPT_OPTION_TEXT_INDENT}"


  for k in "${assocOptionListSortedKeys[@]}"; do
    v="${assocOptionList[${k}]}"

    strOptionTips+="${strPromptTextIndent}"
    strOptionTips+="${codeColorBrackets}[${codeFontReset}"
    strOptionTips+=" ${codeColorValue}${k}${codeFontReset} "
    strOptionTips+="${codeColorBrackets}]${codeFontReset}"
    strOptionTips+=" "
    if [ "${boolIgnoreValues}" == "0" ]; then
      strOptionTips+="${codeColorLabel}${v}${codeFontReset}"
    fi
    strOptionTips+="\n"
  done

  echo -ne "${strOptionTips}"
}