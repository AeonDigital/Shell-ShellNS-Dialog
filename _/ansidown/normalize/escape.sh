#!/usr/bin/env bash

#
# Normalizes every escape character used to represent non-visible characters
# such as \n, \r, \t so that they are not lost until the presentation phase.
#
# Will convert all character **\\** to **'SHELLNS_ASCII_x9D**.
#
# @param string $1
# String thats will be normalized.
#
# @return string
shellNS_ansidown_normalize_escape() {
  local strReturn="${1}"
  strReturn="${strReturn//\\/${SHELLNS_ASCII_x9D//\\/\'}}"
  echo "${strReturn}"
}