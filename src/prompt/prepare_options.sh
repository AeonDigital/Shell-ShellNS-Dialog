#!/usr/bin/env bash

#
# Prepares the list of options to be presented to the user.
#
# @param assoc $6
# Name of an associative array that contains the accepted values and their
# respective labels.
#
# @return string
shellNS_prompt_prepare_options() {
  local k=""
  local v=""
  local strOptionTips=""

  local -n assocOptionList="${1}"
  local -a assocOptionListSortedKeys=($(for k in "${!assocOptionList[@]}"; do echo "${k}"; done | sort))


  local codeColorNone="${SHELLNS_PROMPT_COLOR_NONE}"
  local codeColorBrackets="${SHELLNS_PROMPT_COLOR_BRACKETS}"
  local codeColorValue="${SHELLNS_PROMPT_COLOR_VALUE}"
  local codeColorLabel="${SHELLNS_PROMPT_COLOR_LABEL}"
  local strPromptTextIndent="${SHELLNS_PROMPT_OPTION_TEXT_INDENT}"


  for k in "${assocOptionListSortedKeys[@]}"; do
    v="${assocOptionList[${k}]}"

    strOptionTips+="${strPromptTextIndent}"
    strOptionTips+="${codeColorBrackets}[${codeColorNone}"
    strOptionTips+=" ${codeColorValue}${k}${codeColorNone} "
    strOptionTips+="${codeColorBrackets}]${codeColorNone}"
    strOptionTips+=" "
    strOptionTips+="${codeColorLabel}${v}${codeColorNone}"
    strOptionTips+="\n"
  done

  echo -ne "${strOptionTips}"
}