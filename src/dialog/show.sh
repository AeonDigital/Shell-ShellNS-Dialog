#!/usr/bin/env bash

#
# Assembles the dialog message for the user for the last existing record
# in **SHELLNS_DIALOG_DATA**.
#
# @return string
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