#!/usr/bin/env bash

#
# Defines the prompt rules to be shown to the user.
#
# @param string $1
# ::
#   - default : "raw"
#   - list    : !SHELLNS_DIALOG_TYPE_COLOR
# ::
# Main message dialogue type.
#
#
# @param string $2
# Message that will be shown.
#
#
# @param bool $3
# ::
#   - default : "1"
#   - list    : SHELLNS_PROMPT_OPTION_BOOL
# ::
# If the value is required.
#
#
# @param ?string $4
# Default value if the user enter a empty value.
#
#
# @param ?bool $5
# ::
#   - default : "1"
#   - list    : SHELLNS_PROMPT_OPTION_BOOL
# ::
# Whether the value entered by the user should be trimmed.
#
#
# @param ?assoc $6
# Name of an associative array that contains the accepted values and their
# respective labels.
#
#
# @param bool $7
# ::
#   - default : "0"
#   - list    : SHELLNS_PROMPT_OPTION_BOOL
# ::
# Indicates when to use only the keys of the associative array
# provided in **$6**.
#
#
# @param bool $8
# ::
#   - default : "1"
#   - list    : SHELLNS_PROMPT_OPTION_BOOL
# ::
# If the comparison of values should be done in case sensitive.
#
#
# @param bool $9
# ::
#   - default : "1"
#   - list    : SHELLNS_PROMPT_OPTION_BOOL
# ::
# Whether the comparison of values should take into account the glyphs
# present in ASCII characters.
#
#
# @return void
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