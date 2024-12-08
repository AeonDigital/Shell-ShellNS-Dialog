#!/usr/bin/env bash

#
# Restarts the prompt information array.
#
# @return void
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