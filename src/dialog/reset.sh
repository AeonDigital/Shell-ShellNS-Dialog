#!/usr/bin/env bash

#
# Restarts the dialog information array.
#
# @return void
shellNS_dialog_reset() {
  SHELLNS_DIALOG_DATA["type"]="raw"
  SHELLNS_DIALOG_DATA["message"]=""
}