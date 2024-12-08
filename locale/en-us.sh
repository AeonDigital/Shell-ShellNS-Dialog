#!/usr/bin/env bash

#
# Message to be shown to the user when there is a list of valid
# options to select.
SHELLNS_PROMPT_OPTION_TEXT_SELECT="Select one of the following options:"


#
# Picklist for Boolean values.
unset SHELLNS_PROMPT_OPTION_BOOL
declare -gA SHELLNS_PROMPT_OPTION_BOOL=(
  ["0"]="n no not cancel"
  ["1"]="y yes ok confirm"
)
#
# Picklist for Contextualized Boolean values.
unset SHELLNS_PROMPT_OPTION_BOOL_ENABLED
declare -gA SHELLNS_PROMPT_OPTION_BOOL_ENABLED=(
  ["0"]="d disable"
  ["1"]="e enable"
)


#
# Labels
SHELLNS_DIALOG_LBL_ERROR_INVALID_VALUE="Invalid value."
SHELLNS_DIALOG_LBL_ERROR_REQUIRED_VALUE="Required value."