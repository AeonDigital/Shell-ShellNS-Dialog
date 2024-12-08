#!/usr/bin/env bash

#
# Shows the configured prompt to the user and waits for a response.
#
# @return string
shellNS_prompt_show() {
  local strPromptType="${SHELLNS_PROMPT_DATA["type"]}"
  local strPromptMessage="${SHELLNS_PROMPT_DATA["message"]}"
  local boolPromptRequired="${SHELLNS_PROMPT_DATA["required"]}"
  local strPromptDefault="${SHELLNS_PROMPT_DATA["default"]}"
  local boolPromptTrimInput="${SHELLNS_PROMPT_DATA["trimInput"]}"
  local assocPromptOptions="${SHELLNS_PROMPT_DATA["options"]}"
  local boolPromptOptionsOnlyKeys="${SHELLNS_PROMPT_DATA["onlyKeys"]}"
  local boolPromptCompareCase="${SHELLNS_PROMPT_DATA["compareCase"]}"
  local boolPromptCompareGlyphs="${SHELLNS_PROMPT_DATA["compareGlyphs"]}"

  SHELLNS_PROMPT_DATA["input"]=""
  local strPromptInput=""

  local strPromptTextIndent="${SHELLNS_PROMPT_OPTION_TEXT_INDENT}"
  local strPromptTextBullet="${SHELLNS_PROMPT_OPTION_READ_BULLET}"
  local strPromptInputCompare=""


  if [ "${assocPromptOptions}" != "" ]; then
    local strPromptTips=$(shellNS_prompt_prepareOptions "${assocPromptOptions}" "${boolPromptOptionsOnlyKeys}")
    strPromptTips="${strPromptTextIndent}${SHELLNS_PROMPT_OPTION_TEXT_SELECT}\n${strPromptTips}"

    local -n assocOptionList="${assocPromptOptions}"
  fi


  while [ "${SHELLNS_PROMPT_DATA["input"]}" == "" ]; do
    if [ "${strPromptInput}" != "" ]; then
      shellNS_dialog_set "error" "${SHELLNS_DIALOG_LBL_ERROR_INVALID_VALUE} [ '${strPromptInput}' ]\n"
      shellNS_dialog_show
    fi

    shellNS_dialog_set "${strPromptType}" "${strPromptMessage}"
    shellNS_dialog_show
    echo -e "${strPromptTips}"
    read -r -p "${strPromptTextBullet}" strPromptInput


    if [ "${boolPromptTrimInput}" == "1" ]; then
      strPromptInput="$(shellNS_string_trim "${strPromptInput}")"
    fi
    strPromptInputCompare="${strPromptInput}"

    if [ "${strPromptInput}" == "" ] && [ "${boolPromptRequired}" == "1" ]; then
      shellNS_dialog_set "error" "${SHELLNS_DIALOG_LBL_ERROR_REQUIRED_VALUE}"
      shellNS_dialog_show

      continue
    fi

    if [ "${strPromptInput}" == "" ] && [ "${strPromptDefault}" != "" ]; then
      SHELLNS_PROMPT_DATA["input"]="${strPromptDefault}"
      break
    fi

    if [ "${strPromptInput}" != "" ] && [ "${assocPromptOptions}" != "" ]; then
      local isMatch="0"
      local strAllowedKey=""
      local -a arrOptionLabels=()

      if [ "${boolPromptCompareGlyphs}" == "0" ]; then
        strPromptInputCompare=$(shellNS_string_remove_glyphs "${strPromptInputCompare}")
      fi

      local strSameKeyValues=""
      for strAllowedKey in "${!assocOptionList[@]}"; do
        strSameKeyValues="'${strAllowedKey}'"
        if [ "${boolPromptOptionsOnlyKeys}" == "0" ]; then
          strSameKeyValues="'${strAllowedKey}' ${assocOptionList[${strAllowedKey}]}"
        fi

        if [ "${boolPromptCompareGlyphs}" == "0" ]; then
          strSameKeyValues=$(shellNS_string_remove_glyphs "${strSameKeyValues}")
        fi

        eval "arrOptionLabels=(${strSameKeyValues})"

        if [ $(shellNS_array_has_value "arrOptionLabels" "${strPromptInputCompare}" "${boolPromptCompareCase}") == "1" ]; then
          SHELLNS_PROMPT_DATA["input"]="${strAllowedKey}"
          break
        fi
      done
    fi
  done
}