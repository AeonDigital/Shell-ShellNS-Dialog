#!/usr/bin/env bash

shellNS_string_remove_glyphs() {
  local isCmd=$(command -v iconv &> /dev/null; echo "$?";)
  if [ "${isCmd}" == "0" ]; then
      echo -ne "${1}" | iconv --from-code="UTF8" --to-code="ASCII//TRANSLIT"
  fi
}
shellNS_string_trim() {
  local strReturn="${1}"
  strReturn="${strReturn#"${strReturn%%[![:space:]]*}"}" # trim L
  strReturn="${strReturn%"${strReturn##*[![:space:]]}"}" # trim R
  echo -ne "${strReturn}"
}
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
declare -gA SHELLNS_PACKAGE_DEPENDENCIES
SHELLNS_PACKAGE_DEPENDENCIES["packages"]=""
SHELLNS_PACKAGE_DEPENDENCIES["commands"]="iconv"
if [[ ! "${SHELLNS_DIALOG_DATA[@]+_}" ]]; then
  declare -gA SHELLNS_DIALOG_DATA
  SHELLNS_DIALOG_DATA["type"]="raw"
  SHELLNS_DIALOG_DATA["message"]=""
fi
declare -gA SHELLNS_DIALOG_DATA_TYPES=(
  ["raw"]=""
  ["info"]="\e[1;34m"
  ["warning"]="\e[0;93m"
  ["error"]="\e[1;31m"
  ["question"]="\e[1;35m"
  ["input"]="\e[1;36m"
  ["ok"]="\e[20;49;32m"
  ["fail"]="\e[20;49;31m"
)
SHELLNS_DIALOG_COLOR_NONE="\e[0m"
SHELLNS_DIALOG_COLOR_TEXT_DEFAULT="\e[0;49m"
SHELLNS_DIALOG_COLOR_TEXT_DEFAULT_HIGHLIGHT="\e[1;49m"
SHELLNS_DIALOG_TEXT_INDENT="        "
if [[ ! "${SHELLNS_PROMPT_DATA[@]+_}" ]]; then
  declare -gA SHELLNS_PROMPT_DATA
  SHELLNS_PROMPT_DATA["type"]="raw"
  SHELLNS_PROMPT_DATA["message"]=""
  SHELLNS_PROMPT_DATA["required"]="1"
  SHELLNS_PROMPT_DATA["default"]=""
  SHELLNS_PROMPT_DATA["trimInput"]="1"
  SHELLNS_PROMPT_DATA["options"]=""
  SHELLNS_PROMPT_DATA["compareCase"]="1"
  SHELLNS_PROMPT_DATA["compareGlyphs"]="1"
  SHELLNS_PROMPT_DATA["input"]=""
fi
SHELLNS_PROMPT_OPTION_TEXT_SELECT="Select one of the following options:"
SHELLNS_PROMPT_OPTION_TEXT_INDENT="        "
SHELLNS_PROMPT_OPTION_READ_BULLET="      > "
SHELLNS_PROMPT_COLOR_NONE="\e[0m"
SHELLNS_PROMPT_COLOR_BRACKETS=""
SHELLNS_PROMPT_COLOR_VALUE="\e[0;90;49m"
SHELLNS_PROMPT_COLOR_LABEL=""
unset SHELLNS_PROMPT_OPTION_BOOL
declare -gA SHELLNS_PROMPT_OPTION_BOOL=(
  ["0"]="n no not cancel"
  ["1"]="y yes ok confirm"
)
unset SHELLNS_PROMPT_OPTION_BOOL_ENABLED
declare -gA SHELLNS_PROMPT_OPTION_BOOL_ENABLED=(
  ["0"]="d disabled"
  ["1"]="e enable"
)
SHELLNS_DIALOG_LBL_ERROR_INVALID_VALUE="Invalid value."
SHELLNS_DIALOG_LBL_ERROR_REQUIRED_VALUE="Required value."
shellNS_prompt_reset() {
  SHELLNS_PROMPT_DATA["type"]="raw"
  SHELLNS_PROMPT_DATA["message"]=""
  SHELLNS_PROMPT_DATA["required"]="1"
  SHELLNS_PROMPT_DATA["default"]=""
  SHELLNS_PROMPT_DATA["trimInput"]="1"
  SHELLNS_PROMPT_DATA["options"]=""
  SHELLNS_PROMPT_DATA["compareCase"]="1"
  SHELLNS_PROMPT_DATA["compareGlyphs"]="1"
  SHELLNS_PROMPT_DATA["input"]=""
}
shellNS_prompt_set() {
  local strPromptType="${1}"
  local strPromptMessage="${2}"
  local boolPromptRequired="${3}"
  local strPromptDefault="${4}"
  local boolPromptTrimInput="${5}"
  local assocPromptOptions="${6}"
  local boolPromptCompareCase="${7}"
  local boolPromptCompareGlyphs="${8}"
  if [ "${strPromptType}" == "" ] || [ "${SHELLNS_DIALOG_DATA_TYPES["${strPromptType}"]}" == "" ]; then
    strPromptType="raw"
  fi
  if [ "${boolPromptRequired}" != "0" ] && [ "${boolPromptRequired}" != "1" ]; then
    boolPromptRequired="1"
  fi
  if [ "${boolPromptTrimInput}" != "0" ] && [ "${boolPromptTrimInput}" != "1" ]; then
    boolPromptTrimInput="1"
  fi
  if [ "${assocPromptOptions}" != "" ] && [[ "$(declare -p "${assocPromptOptions}" 2> /dev/null)" != "declare -A"* ]]; then
    assocPromptOptions=""
  fi
  if [ "${boolPromptCompareCase}" != "0" ] && [ "${boolPromptCompareCase}" != "1" ]; then
    boolPromptCompareCase="1"
  fi
  if [ "${boolPromptCompareGlyphs}" != "0" ] && [ "${boolPromptCompareGlyphs}" != "1" ]; then
    boolPromptCompareGlyphs="1"
  fi
  SHELLNS_PROMPT_DATA["type"]="${strPromptType}"
  SHELLNS_PROMPT_DATA["message"]="${strPromptMessage}"
  SHELLNS_PROMPT_DATA["required"]="${boolPromptRequired}"
  SHELLNS_PROMPT_DATA["default"]="${strPromptDefault}"
  SHELLNS_PROMPT_DATA["trimInput"]="${boolPromptTrimInput}"
  SHELLNS_PROMPT_DATA["options"]="${assocPromptOptions}"
  SHELLNS_PROMPT_DATA["compareCase"]="${boolPromptCompareCase}"
  SHELLNS_PROMPT_DATA["compareGlyphs"]="${boolPromptCompareGlyphs}"
  SHELLNS_PROMPT_DATA["input"]=""
}
shellNS_prompt_get() {
  echo "${SHELLNS_PROMPT_DATA["input"]}"
}
shellNS_prompt_show() {
  local strPromptType="${SHELLNS_PROMPT_DATA["type"]}"
  local strPromptMessage="${SHELLNS_PROMPT_DATA["message"]}"
  local boolPromptRequired="${SHELLNS_PROMPT_DATA["required"]}"
  local strPromptDefault="${SHELLNS_PROMPT_DATA["default"]}"
  local boolPromptTrimInput="${SHELLNS_PROMPT_DATA["trimInput"]}"
  local assocPromptOptions="${SHELLNS_PROMPT_DATA["options"]}"
  local boolPromptCompareCase="${SHELLNS_PROMPT_DATA["compareCase"]}"
  local boolPromptCompareGlyphs="${SHELLNS_PROMPT_DATA["compareGlyphs"]}"
  SHELLNS_PROMPT_DATA["input"]=""
  local strPromptInput=""
  local strPromptTextIndent="${SHELLNS_PROMPT_OPTION_TEXT_INDENT}"
  local strPromptTextBullet="${SHELLNS_PROMPT_OPTION_READ_BULLET}"
  local strPromptInputCompare=""
  if [ "${assocPromptOptions}" != "" ]; then
    local strPromptTips=$(shellNS_prompt_prepare_options "${assocPromptOptions}")
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
        strSameKeyValues="'${strAllowedKey}' ${assocOptionList[${strAllowedKey}]}"
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
shellNS_dialog_reset() {
  SHELLNS_DIALOG_DATA["type"]="raw"
  SHELLNS_DIALOG_DATA["message"]=""
}
shellNS_dialog_set() {
  local strDialogType="${1}"
  local strDialogMessage="${2}"
  if [ "${strDialogType}" == "" ] || [ "${SHELLNS_DIALOG_DATA_TYPES["${strDialogType}"]}" == "" ]; then
    strDialogType="raw"
  fi
  SHELLNS_DIALOG_DATA["type"]="${strDialogType}"
  SHELLNS_DIALOG_DATA["message"]="${strDialogMessage}"
}
shellNS_dialog_show() {
  local strDialogType="${SHELLNS_DIALOG_DATA["type"]}"
  local strDialogMessage="${SHELLNS_DIALOG_DATA["message"]}"
  if [ "${strDialogMessage}" != "" ]; then
    local strShowMessage=""
    local strShowMessagePrefix=""
    case "${strDialogType}" in
      "info")
        strShowMessagePrefix="inf"
        ;;
      "warning")
        strShowMessagePrefix="war"
        ;;
      "error")
        strShowMessagePrefix="err"
        ;;
      "question")
        strShowMessagePrefix=" ? "
        ;;
      "input")
        strShowMessagePrefix=" < "
        ;;
      "ok")
        strShowMessagePrefix=" v "
        ;;
      "fail")
        strShowMessagePrefix=" x "
        ;;
      *)
        strShowMessagePrefix=" - "
        ;;
    esac
    if [ "${strShowMessagePrefix}" == "raw" ]; then
      echo -ne "${strDialogMessage}"
      return 0
    fi
    local codeColorNone="${SHELLNS_DIALOG_COLOR_NONE}"
    local codeColorText="${SHELLNS_DIALOG_COLOR_TEXT_DEFAULT}"
    local codeColorHighlight="${SHELLNS_DIALOG_COLOR_TEXT_DEFAULT_HIGHLIGHT}"
    local codeColorPrefix="${SHELLNS_DIALOG_DATA_TYPES["${strDialogType}"]}"
    local strIndent="${SHELLNS_DIALOG_TEXT_INDENT}"
    local tmpCount="0"
    while [[ "${strDialogMessage}" =~ "**" ]]; do
      ((tmpCount++))
      if (( tmpCount % 2 != 0 )); then
        strDialogMessage="${strDialogMessage/\*\*/${codeColorHighlight}}"
      else
        strDialogMessage="${strDialogMessage/\*\*/${codeColorNone}}"
      fi
    done
    local codeNL=$'\n'
    strDialogMessage=$(echo -ne "${strDialogMessage}")
    strDialogMessage="${strDialogMessage//${codeNL}/${codeNL}${strIndent}}"
    strShowMessage+="[ ${codeColorPrefix}${strShowMessagePrefix}${codeColorNone} ] "
    strShowMessage+="${codeColorText}${strDialogMessage}${codeColorNone}\n"
    echo -ne "${strShowMessage}"
  fi
  return 0
}

