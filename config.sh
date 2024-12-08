#!/usr/bin/env bash

#
# Package Config


#
# Register Package Dependencies
declare -gA SHELLNS_PACKAGE_DEPENDENCIES
SHELLNS_PACKAGE_DEPENDENCIES["packages"]=""
SHELLNS_PACKAGE_DEPENDENCIES["commands"]="iconv"



#
# Associative array that stores information regarding dialog messages that
# should be shown to the user.
#
# Below is a description of the expected keys.
#
# - type    : Type of the dialog that will be shown.
#             Default value: 'raw'
#             Valid values are those defined as keys in the associative
#             array 'SHELLNS_DIALOG_TYPE_COLOR'.
# - message : Message that will be shown.
#
if [[ ! "${SHELLNS_DIALOG_DATA[@]+_}" ]]; then
  declare -gA SHELLNS_DIALOG_DATA
  SHELLNS_DIALOG_DATA["type"]="raw"
  SHELLNS_DIALOG_DATA["message"]=""
fi

#
# Associative array that stores the types of dialog messages that can be used
# to communicate with the user. Each type is associated with a color code
# that will be used to highlight the message.
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
#
# Associative array that correlates dialog message types with their prefixes
# for presentation.
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

#
# Code to remove text coloring.
SHELLNS_DIALOG_COLOR_NONE="\e[0m"
#
# Code for the default text color.
SHELLNS_DIALOG_COLOR_TEXT_DEFAULT="\e[0;49m"
#
# Code for the accent color of the text.
SHELLNS_DIALOG_COLOR_TEXT_DEFAULT_HIGHLIGHT="\e[1;49m"
#
# Indentation for the text that comes after the main message of the dialogue.
SHELLNS_DIALOG_TEXT_INDENT="        "





#
# PROMPT
# The prompt is shown to the user following the following template:
#
# ``` shell
# [ inf ] Prompt message to user
# [ ??? ] Select one of the following options:
#         [ 0 ] n no not cancel
#         [ 1 ] y yes ok confirm
#       > ...
# ```
#
# The first line is shown using a normal dialog message.
# The second line is a default message for when there is a list of valid
# values to select.
# The other lines show the user each of the available options to be selected.



#
# Associative array that stores prompt information that will be shown to the
# user.
#
# Below is a description of the expected keys.
#
# - type          : Type of the dialog that will be shown.
#                   Default value: 'raw'
#                   Valid values are those defined as keys in the associative
#                   array 'SHELLNS_DIALOG_TYPE_COLOR'.
# - message       : Message that will be shown.
# - required      : Informs if the completion is mandatory.
#                   Default: '1'
#                   Enter '0' for empty values to be accepted.
# - default       : Default value to be used when no other value is entered.
# - trimInput     : If should pass the value entered through a 'trim'.
#                   Default: '1'
# - options       : If entered, it must be the name of an associative array
#                   that contains the values accepted as valid and their
#                   respective labels.
# - compareCase   : Indicates whether the comparison of values should be done
#                   in case sensitive (a != A).
#                   Default '1'
#                   If '0' will make the comparison in case insensitive
#                   (a == A).
#                   Used only if 'options' is set.
# - compareGlyphs : Indicates whether the comparison of values should be made
#                   taking into account the glyphs of the characters (a != ã).
#                   Default '1'
#                   If '0' will make the comparison ignoring the presence of
#                   glyphs in ascii characters (a == ã)
#                   Used only if 'options' is set.
# - input         : Stores the value entered by the user and considered valid.
#
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



#
# Message to be shown to the user when there is a list of valid
# options to select.
SHELLNS_PROMPT_OPTION_TEXT_SELECT="Select one of the following options:"
#
# Indentation of the text used in the prompt
SHELLNS_PROMPT_OPTION_TEXT_INDENT="        "
#
# Bullet for the line where the user will type their answer.
SHELLNS_PROMPT_OPTION_READ_BULLET="      > "

#
# Code to remove text coloring.
SHELLNS_PROMPT_COLOR_NONE="\e[0m"
#
# Color of brackets used to display the true value of the option
SHELLNS_PROMPT_COLOR_BRACKETS=""
#
# Color of the actual value to be selected
SHELLNS_PROMPT_COLOR_VALUE="\e[0;90;49m"
#
# Color of the labels corresponding to the actual value
SHELLNS_PROMPT_COLOR_LABEL=""



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
  ["0"]="d disabled"
  ["1"]="e enable"
)


#
# Labels
SHELLNS_DIALOG_LBL_ERROR_INVALID_VALUE="Invalid value."
SHELLNS_DIALOG_LBL_ERROR_REQUIRED_VALUE="Required value."