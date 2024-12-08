#!/usr/bin/env bash

if [[ "$(declare -p "SHELLNS_STANDALONE_LOAD_STATUS" 2> /dev/null)" != "declare -A"* ]]; then
  declare -gA SHELLNS_STANDALONE_LOAD_STATUS
fi
SHELLNS_STANDALONE_LOAD_STATUS["shellns_dialog_standalone.sh"]="ready"
unset SHELLNS_STANDALONE_DEPENDENCIES
declare -gA SHELLNS_STANDALONE_DEPENDENCIES
shellNS_standalone_install_set_dependency() {
  local strDownloadFileName="shellns_${2,,}_standalone.sh"
  local strPkgStandaloneURL="https://raw.githubusercontent.com/AeonDigital/${1}/refs/heads/main/standalone/package.sh"
  SHELLNS_STANDALONE_DEPENDENCIES["${strDownloadFileName}"]="${strPkgStandaloneURL}"
}
declare -gA SHELLNS_DIALOG_TYPE_COLOR=(
  ["raw"]=""
  ["info"]="\e[1;34m"
  ["warning"]="\e[0;93m"
  ["error"]="\e[1;31m"
  ["question"]="\e[1;35m"
  ["input"]="\e[1;36m"
  ["ok"]="\e[20;49;32m"
  ["fail"]="\e[20;49;31m"
)
declare -gA SHELLNS_DIALOG_TYPE_PREFIX=(
  ["raw"]=" - "
  ["info"]="inf"
  ["warning"]="war"
  ["error"]="err"
  ["question"]=" ? "
  ["input"]=" < "
  ["ok"]=" v "
  ["fail"]=" x "
)
declare -g SHELLNS_DIALOG_PROMPT_INPUT=""
shellNS_standalone_install_dialog() {
  local strDialogType="${1}"
  local strDialogMessage="${2}"
  local boolDialogWithPrompt="${3}"
  local codeColorPrefix="${SHELLNS_DIALOG_TYPE_COLOR["${strDialogType}"]}"
  local strMessagePrefix="${SHELLNS_DIALOG_TYPE_PREFIX[${strDialogType}]}"
  if [ "${strDialogMessage}" != "" ] && [ "${codeColorPrefix}" != "" ] && [ "${strMessagePrefix}" != "" ]; then
    local strIndent="        "
    local strPromptPrefix="      > "
    local codeColorNone="\e[0m"
    local codeColorText="\e[0;49m"
    local codeColorHighlight="\e[1;49m"
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
    local strShowMessage=""
    strShowMessage+="[ ${codeColorPrefix}${strMessagePrefix}${codeColorNone} ] "
    strShowMessage+="${codeColorText}${strDialogMessage}${codeColorNone}\n"
    echo -ne "${strShowMessage}"
    if [ "${boolDialogWithPrompt}" == "1" ]; then
      SHELLNS_DIALOG_PROMPT_INPUT=""
      read -r -p "${strPromptPrefix}" SHELLNS_DIALOG_PROMPT_INPUT
    fi
  fi
  return 0
}
shellNS_standalone_install_dependencies() {
  if [[ "$(declare -p "SHELLNS_STANDALONE_DEPENDENCIES" 2> /dev/null)" != "declare -A"* ]]; then
    return 0
  fi
  if [ "${#SHELLNS_STANDALONE_DEPENDENCIES[@]}" == "0" ]; then
    return 0
  fi
  local pkgFileName=""
  local pkgSourceURL=""
  local pgkLoadStatus=""
  for pkgFileName in "${!SHELLNS_STANDALONE_DEPENDENCIES[@]}"; do
    pgkLoadStatus="${SHELLNS_STANDALONE_LOAD_STATUS[${pkgFileName}]}"
    if [ "${pgkLoadStatus}" == "" ]; then pgkLoadStatus="0"; fi
    if [ "${pgkLoadStatus}" == "ready" ] || [ "${pgkLoadStatus}" -ge "1" ]; then
      continue
    fi
    if [ ! -f "${pkgFileName}" ]; then
      pkgSourceURL="${SHELLNS_STANDALONE_DEPENDENCIES[${pkgFileName}]}"
      curl -o "${pkgFileName}" "${pkgSourceURL}"
      if [ ! -f "${pkgFileName}" ]; then
        local strMsg=""
        strMsg+="An error occurred while downloading a dependency.\n"
        strMsg+="URL: **${pkgSourceURL}**\n\n"
        strMsg+="This execution was aborted."
        shellNS_standalone_install_dialog "error" "${strMsg}"
        return 1
      fi
    fi
    chmod +x "${pkgFileName}"
    if [ "$?" != "0" ]; then
      local strMsg=""
      strMsg+="Could not give execute permission to script:\n"
      strMsg+="FILE: **${pkgFileName}**\n\n"
      strMsg+="This execution was aborted."
      shellNS_standalone_install_dialog "error" "${strMsg}"
      return 1
    fi
    SHELLNS_STANDALONE_LOAD_STATUS["${pkgFileName}"]="1"
  done
  if [ "${1}" == "1" ]; then
    for pkgFileName in "${!SHELLNS_STANDALONE_DEPENDENCIES[@]}"; do
      pgkLoadStatus="${SHELLNS_STANDALONE_LOAD_STATUS[${pkgFileName}]}"
      if [ "${pgkLoadStatus}" == "ready" ]; then
        continue
      fi
      . "${pkgFileName}"
      if [ "$?" != "0" ]; then
        local strMsg=""
        strMsg+="An unexpected error occurred while load script:\n"
        strMsg+="FILE: **${pkgFileName}**\n\n"
        strMsg+="This execution was aborted."
        shellNS_standalone_install_dialog "error" "${strMsg}"
        return 1
      fi
      SHELLNS_STANDALONE_LOAD_STATUS["${pkgFileName}"]="ready"
    done
  fi
}
shellNS_standalone_install_dependencies "1"
unset shellNS_standalone_install_set_dependency
unset shellNS_standalone_install_dependencies
unset shellNS_standalone_install_dialog
unset SHELLNS_STANDALONE_DEPENDENCIES
shellNS_var_get() {
  local strCurrentValue="${1}"
  local strDefaultValueIfEmptyOrInvalid="${2}"
  IFS=$'\n'
  local tmpCode="local -a arrValidOptions=("${3}")"
  eval "${tmpCode}"
  IFS=$' \t\n'
  local strReturn="${strDefaultValueIfEmptyOrInvalid}"
  if [ "${#arrValidOptions[@]}" == "0" ] && [ "${strCurrentValue}" != "" ]; then
    strReturn="${strCurrentValue}"
  fi
  if [ "${#arrValidOptions[@]}" -gt "0" ]; then
    local value=""
    for value in "${arrValidOptions[@]}"; do
      if [ "${strCurrentValue}" == "${value}" ]; then
        strReturn="${strCurrentValue}"
        break
      fi
    done
  fi
  echo -ne "${strReturn}"
}
shellNS_array_export() {
  local str=""
  local -n arrayToExport="${1}"
  local sep=$'\n'
  local k=""
  local v=""
  for k in "${!arrayToExport[@]}"; do
    v=$(shellNS_string_normalize "${arrayToExport[$k]}")
    str+="${k}=${v}${sep}"
  done
  if [ "${str}" != "" ]; then
    echo -n "${str:0: -1}"
  fi
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
shellNS_array_join() {
  local strReturn=""
  local strGlue="${1}"
  local intGlueLength="${#strGlue}"
  declare -n arrayOriginal="${2}"
  local strIt=""
  for strIt in "${arrayOriginal[@]}"; do
    strReturn+="${strIt}${strGlue}"
  done
  if [ "${intGlueLength}" -gt "0" ]; then
    strReturn="${strReturn:: -$intGlueLength}"
  fi
  echo -n "${strReturn}"
}
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
  done <<< "${strOriginalDocument}"
  unset IFS
  echo -n "${strReturn}"
}
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
    if [ "${isIgnoreNextEmptyLines}" == "1" ]; then
      if [ "${strTrimLine}" == "" ]; then
        continue
      fi
      isIgnoreNextEmptyLines="0"
    fi
    if [ "${strTrimLine}" == "" ]; then
      boolOpenBlockList="0"
      strReturn+="${codeNL}"
      continue
    fi
    if [[ "${strTrimLine}" =~ ^@[a-zA-Z]+ ]]; then
      strReturn+="${strTrimLine}  ${codeNL}"
      isIgnoreNextEmptyLines="1"
      continue
    fi
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
    if [ "${boolOpenBlockProperties}" == "1" ]; then
      isIgnoreNextEmptyLines="1"
      strReturn+="  ${strTrimLine}  ${codeNL}"
      continue
    fi
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
    if [ "${boolOpenBlockCode}" == "1" ]; then
      strTrimLine=$(shellNS_string_trimR_raw "${strRawLine}")
      strReturn+="${strTrimLine}  ${codeNL}"
      continue
    fi
    if [ "${#strTrimLine}" -ge "3" ] && [ "${strTrimLine:0:2}" == "- " ]; then
      boolOpenBlockList="1"
      strTrimLine=$(shellNS_string_trimR_raw "${strRawLine}")
      strReturn+="${strTrimLine}  ${codeNL}"
      continue
    fi
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
shellNS_ansidown_normalize_escape() {
  local strReturn="${1}"
  strReturn="${strReturn//\\/${SHELLNS_ASCII_x9D//\\/\'}}"
  echo "${strReturn}"
}
shellNS_string_trim_raw() {
  local strReturn="${1}"
  strReturn="${strReturn#"${strReturn%%[![:space:]]*}"}" # trim L
  strReturn="${strReturn%"${strReturn##*[![:space:]]}"}" # trim R
  echo -n "${strReturn}"
}
shellNS_string_split() {
  if [ "$#" -ge "3" ]; then
    declare -n arrTargetArray="${1}"
    arrTargetArray=()
    local strSeparator="${2}"
    local strString="${3}"
    local strSubStr=""
    local boolRemoveEmpty=$(shellNS_var_get "${4}" "0" "0 1")
    local boolTrimElements=$(shellNS_var_get "${5}" "0" "0 1")
    local mseLastChar=""
    while [ "${strString}" != "" ]; do
      if [[ "${strString}" != *"${strSeparator}"* ]]; then
        if [ "${boolTrimElements}" == "1" ]; then
          strString=$(shellNS_string_trim_raw "${strString}")
        fi
        arrTargetArray+=("${strString}")
        break
      else
        strSubStr="${strString%%${strSeparator}*}"
        if [ "${strSubStr}" == "" ] && [ "${strSeparator}" == " " ]; then
          strSubStr=" "
        fi
        mseLastChar="${strString: -1}"
        if [ "${boolTrimElements}" == "1" ]; then
          strSubStr=$(shellNS_string_trim_raw "${strSubStr}")
        fi
        if [ "${strSubStr}" != "" ] || [ "${boolRemoveEmpty}" == "0" ]; then
          arrTargetArray+=("${strSubStr}")
        fi
        strString="${strString#*${strSeparator}}"
        if [ "${strString}" == "" ] && [ "${mseLastChar}" == "${strSeparator}" ] && [ "${boolRemoveEmpty}" == "0" ]; then
          arrTargetArray+=("")
        fi
      fi
    done
  fi
}
shellNS_string_remove_glyphs() {
  local isCmd=$(command -v iconv &> /dev/null; echo "$?";)
  if [ "${isCmd}" == "0" ]; then
      echo -ne "${1}" | iconv --from-code="UTF8" --to-code="ASCII//TRANSLIT"
  fi
}
shellNS_string_parse_to_ansidown() {
  local strReturn="${1}"
  if [ "${strReturn}" == "" ]; then
    return 0
  fi
  strReturn=$(shellNS_ansidown_normalize_escape "${strReturn}")
  strReturn=$(shellNS_ansidown_normalize_blocks "${strReturn}")
  strReturn=$(shellNS_ansidown_normalize_breakline "${strReturn}")
  local it=""
  local -A assocOriginalFontConfig
  if [ "${2}" != "" ]; then
    local -n assocNewFontConfig="${2}"
    local originalCode=""
    for it in "${!assocNewFontConfig[@]}"; do
      originalCode="${!it}"
      if [ "${originalCode}" == "" ]; then continue; fi
      assocOriginalFontConfig["${it}"]="${originalCode}"
      eval "${it}=\"${assocNewFontConfig[${it}]}\""
    done
  fi
  local code_BoldItalicIn="${SHELLNS_FONT_BOLD_ITALIC_IN/\\/\'}"
  local code_BoldItalicOut="${SHELLNS_FONT_BOLD_ITALIC_OUT/\\/\'}"
  strReturn=$(shellNS_string_replace_markup "${strReturn}" "\*\*\*" "\*\*\*" "${code_BoldItalicIn}" "${code_BoldItalicOut}")
  local code_BoldIn="${SHELLNS_FONT_BOLD_IN/\\/\'}"
  local code_BoldOut="${SHELLNS_FONT_BOLD_OUT/\\/\'}"
  strReturn=$(shellNS_string_replace_markup "${strReturn}" "\*\*" "\*\*" "${code_BoldIn}" "${code_BoldOut}")
  local code_LowIntensityIn="${SHELLNS_FONT_LOW_INTENSITY_IN/\\/\'}"
  local code_LowIntensityOut="${SHELLNS_FONT_LOW_INTENSITY_OUT/\\/\'}"
  strReturn=$(shellNS_string_replace_markup "${strReturn}" ",," ",," "${code_LowIntensityIn}" "${code_LowIntensityOut}")
  local code_ItalicIn="${SHELLNS_FONT_ITALIC_IN/\\/\'}"
  local code_ItalicOut="${SHELLNS_FONT_ITALIC_OUT/\\/\'}"
  strReturn=$(shellNS_string_replace_markup "${strReturn}" "__" "__" "${code_ItalicIn}" "${code_ItalicOut}")
  local code_UnderlineIn="${SHELLNS_FONT_UNDERLINE_IN/\\/\'}"
  local code_UnderlineOut="${SHELLNS_FONT_UNDERLINE_OUT/\\/\'}"
  strReturn=$(shellNS_string_replace_markup "${strReturn}" "_," ",_" "${code_UnderlineIn}" "${code_UnderlineOut}")
  local code_StrikeIn="${SHELLNS_FONT_STRIKE_IN/\\/\'}"
  local code_StrikeOut="${SHELLNS_FONT_STRIKE_OUT/\\/\'}"
  strReturn=$(shellNS_string_replace_markup "${strReturn}" "~~" "~~" "${code_StrikeIn}" "${code_StrikeOut}")
  local code_InlineBlockCodeIn="${SHELLNS_FONT_INLINE_BLOCK_IN/\\/\'}"
  local code_InlineBlockCodeOut="${SHELLNS_FONT_INLINE_BLOCK_OUT/\\/\'}"
  strReturn=$(shellNS_string_replace_markup "${strReturn}" "\`" "\`" "${code_InlineBlockCodeIn}" "${code_InlineBlockCodeOut}")
  strReturn="${strReturn//${code_BoldItalicIn}/${SHELLNS_FONT_BOLD_ITALIC_IN}}"
  strReturn="${strReturn//${code_BoldItalicOut}/${SHELLNS_FONT_BOLD_ITALIC_OUT}}"
  strReturn="${strReturn//${code_BoldIn}/${SHELLNS_FONT_BOLD_IN}}"
  strReturn="${strReturn//${code_BoldOut}/${SHELLNS_FONT_BOLD_OUT}}"
  strReturn="${strReturn//${code_LowIntensityIn}/${SHELLNS_FONT_LOW_INTENSITY_IN}}"
  strReturn="${strReturn//${code_LowIntensityOut}/${SHELLNS_FONT_LOW_INTENSITY_OUT}}"
  strReturn="${strReturn//${code_ItalicIn}/${SHELLNS_FONT_ITALIC_IN}}"
  strReturn="${strReturn//${code_ItalicOut}/${SHELLNS_FONT_ITALIC_OUT}}"
  strReturn="${strReturn//${code_UnderlineIn}/${SHELLNS_FONT_UNDERLINE_IN}}"
  strReturn="${strReturn//${code_UnderlineOut}/${SHELLNS_FONT_UNDERLINE_OUT}}"
  strReturn="${strReturn//${code_StrikeIn}/${SHELLNS_FONT_STRIKE_IN}}"
  strReturn="${strReturn//${code_StrikeOut}/${SHELLNS_FONT_STRIKE_OUT}}"
  strReturn="${strReturn//${code_InlineBlockCodeIn}/${SHELLNS_FONT_INLINE_BLOCK_IN}}"
  strReturn="${strReturn//${code_InlineBlockCodeOut}/${SHELLNS_FONT_INLINE_BLOCK_OUT}}"
  local code_x9D="${SHELLNS_ASCII_x9D/\\/\'}"
  strReturn="${strReturn//${code_x9D}/\\\\}"
  for it in "${!assocOriginalFontConfig[@]}"; do
    eval "${it}=\"${assocOriginalFontConfig[${it}]}\""
  done
  echo -ne "${strReturn}${SHELLNS_FONT_RESET}"
}
shellNS_string_trimL_raw() {
  local strReturn="${1}"
  strReturn="${strReturn#"${strReturn%%[![:space:]]*}"}" # trim L
  echo -n "${strReturn}"
}
shellNS_string_trim() {
  local strReturn="${1}"
  strReturn="${strReturn#"${strReturn%%[![:space:]]*}"}" # trim L
  strReturn="${strReturn%"${strReturn##*[![:space:]]}"}" # trim R
  echo -ne "${strReturn}"
}
shellNS_string_trimR_raw() {
  local strReturn="${1}"
  strReturn="${strReturn%"${strReturn##*[![:space:]]}"}" # trim R
  echo -n "${strReturn}"
}
shellNS_string_trimL() {
  local strReturn="${1}"
  strReturn="${strReturn#"${strReturn%%[![:space:]]*}"}" # trim L
  echo -ne "${strReturn}"
}
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
shellNS_string_trimR() {
  local strReturn="${1}"
  strReturn="${strReturn%"${strReturn##*[![:space:]]}"}" # trim R
  echo -ne "${strReturn}"
}
shellNS_string_normalize() {
  local strNormalized="${1//'\0'/}" # remove all null characters
  strNormalized=$(echo -ne "${strNormalized}")
  local -A assocStringCommands
  assocStringCommands['\\n']=$'\n'  # New Line
  assocStringCommands['\\t']=$'\t'  # Tab Horizontal
  assocStringCommands['\\r']=$'\r'  # Carriage Return
  assocStringCommands['\\b']=$'\b'  # Backspace
  assocStringCommands['\\a']=$'\a'  # Alert
  assocStringCommands['\\v']=$'\v'  # Tab Vertical
  assocStringCommands['\\f']=$'\f'  # Form Feed
  local strCmd=""
  local realCmd=""
  for strCmd in "${!assocStringCommands[@]}"; do
    realCmd="${assocStringCommands[${strCmd}]}"
    strNormalized="${strNormalized//${realCmd}/${strCmd}}"
  done
  echo -ne "${strNormalized}"
}
declare -gA SHELLNS_PACKAGE_DEPENDENCIES
SHELLNS_PACKAGE_DEPENDENCIES["packages"]=""
SHELLNS_PACKAGE_DEPENDENCIES["commands"]="iconv"
if [[ ! "${SHELLNS_DIALOG_DATA[@]+_}" ]]; then
  declare -gA SHELLNS_DIALOG_DATA
  SHELLNS_DIALOG_DATA["type"]="raw"
  SHELLNS_DIALOG_DATA["message"]=""
fi
declare -gA SHELLNS_DIALOG_TYPE_COLOR=(
  ["raw"]=""
  ["info"]="\e[1;34m"
  ["warning"]="\e[0;93m"
  ["error"]="\e[1;31m"
  ["question"]="\e[1;35m"
  ["input"]="\e[1;36m"
  ["ok"]="\e[20;49;32m"
  ["fail"]="\e[20;49;31m"
)
declare -gA SHELLNS_DIALOG_TYPE_PREFIX=(
  ["raw"]=" - "
  ["info"]="inf"
  ["warning"]="war"
  ["error"]="err"
  ["question"]=" ? "
  ["input"]=" < "
  ["ok"]=" v "
  ["fail"]=" x "
)
SHELLNS_DIALOG_COLOR_TEXT_DEFAULT="\e[0;39m"
SHELLNS_DIALOG_TEXT_INDENT="        "
if [[ ! "${SHELLNS_PROMPT_DATA[@]+_}" ]]; then
  declare -gA SHELLNS_PROMPT_DATA
  SHELLNS_PROMPT_DATA["type"]="raw"
  SHELLNS_PROMPT_DATA["message"]=""
  SHELLNS_PROMPT_DATA["required"]="1"
  SHELLNS_PROMPT_DATA["default"]=""
  SHELLNS_PROMPT_DATA["trimInput"]="1"
  SHELLNS_PROMPT_DATA["options"]=""
  SHELLNS_PROMPT_DATA["onlyKeys"]="0"
  SHELLNS_PROMPT_DATA["compareCase"]="1"
  SHELLNS_PROMPT_DATA["compareGlyphs"]="1"
  SHELLNS_PROMPT_DATA["input"]=""
fi
SHELLNS_PROMPT_OPTION_TEXT_SELECT="Select one of the following options:"
SHELLNS_PROMPT_OPTION_TEXT_INDENT="        "
SHELLNS_PROMPT_OPTION_READ_BULLET="      > "
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
  ["0"]="d disable"
  ["1"]="e enable"
)
SHELLNS_ASCII_x81="\x81" # 129      | 201   |       Unused
SHELLNS_ASCII_x8D="\x8D" # 141      | 215   |       Unused
SHELLNS_ASCII_x8F="\x8F" # 143      | 217   |       Unused
SHELLNS_ASCII_x90="\x90" # 144      | 220   |       Unused
SHELLNS_ASCII_x9D="\x9D" # 157      | 235   |       Unused
SHELLNS_ASCII_xA0="\xA0" # 160      | 240   |       Non-breaking space (NBSP)
SHELLNS_ASCII_xAD="\xAD" # 173      | 255   |       Soft hyphen
SHELLNS_FONT_RESET="\e[0m"
SHELLNS_FONT_BOLD_ITALIC_IN="\e[1;3m"
SHELLNS_FONT_BOLD_ITALIC_OUT="\e[22;23m"
SHELLNS_FONT_BOLD_IN="\e[1m"
SHELLNS_FONT_BOLD_OUT="\e[22m"
SHELLNS_FONT_LOW_INTENSITY_IN="\e[2m"
SHELLNS_FONT_LOW_INTENSITY_OUT="\e[22m"
SHELLNS_FONT_ITALIC_IN="\e[3m"
SHELLNS_FONT_ITALIC_OUT="\e[23m"
SHELLNS_FONT_UNDERLINE_IN="\e[4m"
SHELLNS_FONT_UNDERLINE_OUT="\e[24m"
SHELLNS_FONT_STRIKE_IN="\e[9m"
SHELLNS_FONT_STRIKE_OUT="\e[29m"
SHELLNS_FONT_INLINE_BLOCK_IN="\e[2m"
SHELLNS_FONT_INLINE_BLOCK_OUT="\e[22m"
SHELLNS_DIALOG_LBL_ERROR_INVALID_VALUE="Invalid value."
SHELLNS_DIALOG_LBL_ERROR_REQUIRED_VALUE="Required value."
shellNS_prompt_set() {
  local strPromptType="${1}"
  local strPromptMessage="${2}"
  local boolPromptRequired="${3}"
  local strPromptDefault="${4}"
  local boolPromptTrimInput="${5}"
  local assocPromptOptions="${6}"
  local boolPromptOptionsOnlyKeys="${7}"
  local boolPromptCompareCase="${8}"
  local boolPromptCompareGlyphs="${9}"
  if [ "${strPromptType}" == "" ] || [ "${SHELLNS_DIALOG_TYPE_COLOR["${strPromptType}"]}" == "" ]; then
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
  if [ "${boolPromptOptionsOnlyKeys}" != "0" ] && [ "${boolPromptOptionsOnlyKeys}" != "1" ]; then
    boolPromptOptionsOnlyKeys="0"
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
  SHELLNS_PROMPT_DATA["onlyKeys"]="${boolPromptOptionsOnlyKeys}"
  SHELLNS_PROMPT_DATA["compareCase"]="${boolPromptCompareCase}"
  SHELLNS_PROMPT_DATA["compareGlyphs"]="${boolPromptCompareGlyphs}"
  SHELLNS_PROMPT_DATA["input"]=""
}
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
shellNS_prompt_reset() {
  SHELLNS_PROMPT_DATA["type"]="raw"
  SHELLNS_PROMPT_DATA["message"]=""
  SHELLNS_PROMPT_DATA["required"]="1"
  SHELLNS_PROMPT_DATA["default"]=""
  SHELLNS_PROMPT_DATA["trimInput"]="1"
  SHELLNS_PROMPT_DATA["options"]=""
  SHELLNS_PROMPT_DATA["onlyKeys"]="0"
  SHELLNS_PROMPT_DATA["compareCase"]="1"
  SHELLNS_PROMPT_DATA["compareGlyphs"]="1"
  SHELLNS_PROMPT_DATA["input"]=""
}
shellNS_prompt_get() {
  echo "${SHELLNS_PROMPT_DATA["input"]}"
}
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
shellNS_dialog_set() {
  local strDialogType="${1}"
  local strDialogMessage="${2}"
  if [ "${strDialogType}" == "" ] || [ "${SHELLNS_DIALOG_TYPE_COLOR["${strDialogType}"]}" == "" ]; then
    strDialogType="raw"
  fi
  SHELLNS_DIALOG_DATA["type"]="${strDialogType}"
  SHELLNS_DIALOG_DATA["message"]="${strDialogMessage}"
}
shellNS_dialog_show() {
  local strDialogType="${SHELLNS_DIALOG_DATA["type"]}"
  local strDialogMessage="${SHELLNS_DIALOG_DATA["message"]}"
  local codeColorPrefix="${SHELLNS_DIALOG_TYPE_COLOR["${strDialogType}"]}"
  local strMessagePrefix="${SHELLNS_DIALOG_TYPE_PREFIX[${strDialogType}]}"
  if [ "${strDialogMessage}" != "" ] && [ "${codeColorPrefix}" != "" ] && [ "${strMessagePrefix}" != "" ]; then
    local codeColorText="${SHELLNS_DIALOG_COLOR_TEXT_DEFAULT}"
    local tmpCount="0"
    strDialogMessage=$(shellNS_string_parse_to_ansidown "${strDialogMessage}")
    local codeNL=$'\n'
    local code_x9D="${SHELLNS_ASCII_x9D/\\/\'}"
    strDialogMessage="${strDialogMessage//\\\\/${code_x9D}}"
    strDialogMessage=$(echo -ne "${strDialogMessage}")
    strDialogMessage="${strDialogMessage//${codeNL}/${codeNL}${SHELLNS_DIALOG_TEXT_INDENT}}"
    local strShowMessage=""
    strShowMessage+="[ ${codeColorPrefix}${strMessagePrefix}${SHELLNS_FONT_RESET} ] "
    strShowMessage+="${SHELLNS_DIALOG_COLOR_TEXT_DEFAULT}${strDialogMessage}${SHELLNS_FONT_RESET}\n"
    strShowMessage=$(echo -ne "${strShowMessage}")
    strShowMessage="${strShowMessage//${code_x9D}/\\}"
    echo "${strShowMessage}"
  fi
  return 0
}
shellNS_dialog_reset() {
  SHELLNS_DIALOG_DATA["type"]="raw"
  SHELLNS_DIALOG_DATA["message"]=""
}
SHELLNS_PROMPT_OPTION_TEXT_SELECT="Select one of the following options:"
unset SHELLNS_PROMPT_OPTION_BOOL
declare -gA SHELLNS_PROMPT_OPTION_BOOL=(
  ["0"]="n no not cancel"
  ["1"]="y yes ok confirm"
)
unset SHELLNS_PROMPT_OPTION_BOOL_ENABLED
declare -gA SHELLNS_PROMPT_OPTION_BOOL_ENABLED=(
  ["0"]="d disable"
  ["1"]="e enable"
)
SHELLNS_DIALOG_LBL_ERROR_INVALID_VALUE="Invalid value."
SHELLNS_DIALOG_LBL_ERROR_REQUIRED_VALUE="Required value."
SHELLNS_TMP_PATH_TO_DIR_MANUALS="$(tmpPath=$(dirname "${BASH_SOURCE[0]}"); realpath "${tmpPath}/src-manuals/${SHELLNS_CONFIG_INTERFACE_LOCALE}")"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_dialog_reset"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/dialog/reset.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_dialog_set"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/dialog/set.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_dialog_show"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/dialog/show.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_prompt_get"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/prompt/get.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_prompt_prepareOptions"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/prompt/prepareOptions.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_prompt_reset"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/prompt/reset.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_prompt_set"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/prompt/set.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_prompt_show"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/prompt/show.man"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["dialog.reset"]="shellNS_dialog_reset"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["dialog.set"]="shellNS_dialog_set"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["dialog.show"]="shellNS_dialog_show"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["prompt.get"]="shellNS_prompt_get"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["prompt.prepareOptions"]="shellNS_prompt_prepareOptions"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["prompt.reset"]="shellNS_prompt_reset"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["prompt.set"]="shellNS_prompt_set"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["prompt.show"]="shellNS_prompt_show"
unset SHELLNS_TMP_PATH_TO_DIR_MANUALS
