#!/usr/bin/env bash

#
# Prints the value selected by the user for the last prompt run.
#
# @return string
shellNS_prompt_get() {
  echo "${SHELLNS_PROMPT_DATA["input"]}"
}