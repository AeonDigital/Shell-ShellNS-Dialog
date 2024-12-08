#!/usr/bin/env bash

#
# Assembles the dialog message for the user for the last existing record
# in 'SHELLNS_DIALOG_DATA'.
#
# @return string
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