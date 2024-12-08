#!/usr/bin/env bash

#
# Assembles the dialog message for the user for the last existing record
# in 'SHELLNS_DIALOG_DATA'.
#
# @return string
shellNS_dialog_show() {
  local strDialogType="${SHELLNS_DIALOG_DATA["type"]}"
  local strDialogMessage="${SHELLNS_DIALOG_DATA["message"]}"

  local codeColorPrefix="${SHELLNS_DIALOG_TYPE_COLOR["${strDialogType}"]}"
  local strMessagePrefix="${SHELLNS_DIALOG_TYPE_PREFIX[${strDialogType}]}"

  if [ "${strDialogMessage}" != "" ] && [ "${codeColorPrefix}" != "" ] && [ "${strMessagePrefix}" != "" ]; then
    local strIndent="${SHELLNS_DIALOG_TEXT_INDENT}"
    local codeColorNone="${SHELLNS_DIALOG_COLOR_NONE}"
    local codeColorText="${SHELLNS_DIALOG_COLOR_TEXT_DEFAULT}"
    local codeColorHighlight="${SHELLNS_DIALOG_COLOR_TEXT_DEFAULT_HIGHLIGHT}"


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
  fi

  return 0
}