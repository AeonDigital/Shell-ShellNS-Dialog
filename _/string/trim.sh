#!/usr/bin/env bash

#
# Eliminates blank space at the beginning or end of a string.
#
# @param string $1
# String that will be changed.
#
# @return string
# The returned string will have its control characters in
# interpreted format **echo -e**.
shellNS_string_trim() {
  local strReturn="${1}"
  strReturn="${strReturn#"${strReturn%%[![:space:]]*}"}" # trim L
  strReturn="${strReturn%"${strReturn##*[![:space:]]}"}" # trim R
  echo -ne "${strReturn}"
}