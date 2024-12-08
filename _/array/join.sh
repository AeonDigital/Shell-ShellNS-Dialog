#!/usr/bin/env bash

#
# Joins the items in an array using a special string indicated.
#
# @param string $1
# String that will be used as `glue`.
#
# @param array $2
# Array name.
#
# @return string
shellNS_array_join() {
  local strReturn=""
  local strGlue="${1}"
  local intGlueLength="${#strGlue}"
  declare -n arrayOriginal="${2}"

  local strIt=""
  for strIt in "${arrayOriginal[@]}"; do
    strReturn+="${strIt}${strGlue}"
  done

  if [ "${intGlueLength}" -gt "0" ]; then
    strReturn="${strReturn:: -$intGlueLength}"
  fi

  echo -n "${strReturn}"
}