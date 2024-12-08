#!/usr/bin/env bash

#
# Eliminates blank space at the end of a string.
#
# @param string $1
# String that will be changed.
#
# @return string
# The returned string will retain the control characters in
# literal form.
shellNS_string_trimR_raw() {
  local strReturn="${1}"
  strReturn="${strReturn%"${strReturn##*[![:space:]]}"}" # trim R
  echo -n "${strReturn}"
}