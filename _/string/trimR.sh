#!/usr/bin/env bash

#
# Eliminates blank space at the end of a string.
#
# @param string $1
# String that will be changed.
#
# @return string
# The returned string will have its control characters in
# interpreted format **echo -e**.
shellNS_string_trimR() {
  local strReturn="${1}"
  strReturn="${strReturn%"${strReturn##*[![:space:]]}"}" # trim R
  echo -ne "${strReturn}"
}