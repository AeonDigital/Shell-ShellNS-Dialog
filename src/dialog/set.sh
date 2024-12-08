#!/usr/bin/env bash

#
# Defines the dialog information for an application.
#
# @param string $1
# ::
#   - default : "raw"
#   - list    : !SHELLNS_DIALOG_TYPE_COLOR
# ::
# Dialogue type.
#
#
# @param string $2
# Message that will be shown.
#
# @return void
shellNS_dialog_set() {
  local strDialogType="${1}"
  local strDialogMessage="${2}"

  if [ "${strDialogType}" == "" ] || [ "${SHELLNS_DIALOG_TYPE_COLOR["${strDialogType}"]}" == "" ]; then
    strDialogType="raw"
  fi

  SHELLNS_DIALOG_DATA["type"]="${strDialogType}"
  SHELLNS_DIALOG_DATA["message"]="${strDialogMessage}"
}