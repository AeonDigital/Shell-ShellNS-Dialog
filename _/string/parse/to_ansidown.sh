#!/usr/bin/env bash

#
# Converts a string with **ansidown** markup to its corresponding value
# ready to be used in **CLI**.
#
# @param string $1
# Original string.
#
# @param ?assoc $2
# Associative array with mapping for replace default configuration values.
#
# Use keys with the same name of **SHELLNS_FONT** variables.
#
# @return string
shellNS_string_parse_to_ansidown() {
  local strReturn="${1}"
  if [ "${strReturn}" == "" ]; then
    return 0
  fi

  strReturn=$(shellNS_ansidown_normalize_escape "${strReturn}")
  strReturn=$(shellNS_ansidown_normalize_blocks "${strReturn}")
  strReturn=$(shellNS_ansidown_normalize_breakline "${strReturn}")



  local it=""
  local -A assocOriginalFontConfig
  if [ "${2}" != "" ]; then
    local -n assocNewFontConfig="${2}"

    local originalCode=""
    for it in "${!assocNewFontConfig[@]}"; do
      originalCode="${!it}"
      if [ "${originalCode}" == "" ]; then continue; fi

      assocOriginalFontConfig["${it}"]="${originalCode}"
      eval "${it}=\"${assocNewFontConfig[${it}]}\""
    done
  fi



  #
  # Replaces the current markup with a temporary one.
  # Without this, subsequent overrides do not work, as the control characters 
  # prevent recognition of nested markups.

  ## Bold and Italic 
  local code_BoldItalicIn="${SHELLNS_FONT_BOLD_ITALIC_IN/\\/\'}"
  local code_BoldItalicOut="${SHELLNS_FONT_BOLD_ITALIC_OUT/\\/\'}"
  strReturn=$(shellNS_string_replace_markup "${strReturn}" "\*\*\*" "\*\*\*" "${code_BoldItalicIn}" "${code_BoldItalicOut}")


  ## Bold
  local code_BoldIn="${SHELLNS_FONT_BOLD_IN/\\/\'}"
  local code_BoldOut="${SHELLNS_FONT_BOLD_OUT/\\/\'}"
  strReturn=$(shellNS_string_replace_markup "${strReturn}" "\*\*" "\*\*" "${code_BoldIn}" "${code_BoldOut}")


  ## Low intensity
  local code_LowIntensityIn="${SHELLNS_FONT_LOW_INTENSITY_IN/\\/\'}"
  local code_LowIntensityOut="${SHELLNS_FONT_LOW_INTENSITY_OUT/\\/\'}"
  strReturn=$(shellNS_string_replace_markup "${strReturn}" ",," ",," "${code_LowIntensityIn}" "${code_LowIntensityOut}")


  ## Italic
  local code_ItalicIn="${SHELLNS_FONT_ITALIC_IN/\\/\'}"
  local code_ItalicOut="${SHELLNS_FONT_ITALIC_OUT/\\/\'}"
  strReturn=$(shellNS_string_replace_markup "${strReturn}" "__" "__" "${code_ItalicIn}" "${code_ItalicOut}")


  ## Underline
  local code_UnderlineIn="${SHELLNS_FONT_UNDERLINE_IN/\\/\'}"
  local code_UnderlineOut="${SHELLNS_FONT_UNDERLINE_OUT/\\/\'}"
  strReturn=$(shellNS_string_replace_markup "${strReturn}" "_," ",_" "${code_UnderlineIn}" "${code_UnderlineOut}")


  ## Strike
  local code_StrikeIn="${SHELLNS_FONT_STRIKE_IN/\\/\'}"
  local code_StrikeOut="${SHELLNS_FONT_STRIKE_OUT/\\/\'}"
  strReturn=$(shellNS_string_replace_markup "${strReturn}" "~~" "~~" "${code_StrikeIn}" "${code_StrikeOut}")


  ## Inline Block Code
  local code_InlineBlockCodeIn="${SHELLNS_FONT_INLINE_BLOCK_IN/\\/\'}"
  local code_InlineBlockCodeOut="${SHELLNS_FONT_INLINE_BLOCK_OUT/\\/\'}"
  strReturn=$(shellNS_string_replace_markup "${strReturn}" "\`" "\`" "${code_InlineBlockCodeIn}" "${code_InlineBlockCodeOut}")



  #
  # Replaces the temporary markup with the final values.
  strReturn="${strReturn//${code_BoldItalicIn}/${SHELLNS_FONT_BOLD_ITALIC_IN}}"
  strReturn="${strReturn//${code_BoldItalicOut}/${SHELLNS_FONT_BOLD_ITALIC_OUT}}"

  strReturn="${strReturn//${code_BoldIn}/${SHELLNS_FONT_BOLD_IN}}"
  strReturn="${strReturn//${code_BoldOut}/${SHELLNS_FONT_BOLD_OUT}}"

  strReturn="${strReturn//${code_LowIntensityIn}/${SHELLNS_FONT_LOW_INTENSITY_IN}}"
  strReturn="${strReturn//${code_LowIntensityOut}/${SHELLNS_FONT_LOW_INTENSITY_OUT}}"

  strReturn="${strReturn//${code_ItalicIn}/${SHELLNS_FONT_ITALIC_IN}}"
  strReturn="${strReturn//${code_ItalicOut}/${SHELLNS_FONT_ITALIC_OUT}}"

  strReturn="${strReturn//${code_UnderlineIn}/${SHELLNS_FONT_UNDERLINE_IN}}"
  strReturn="${strReturn//${code_UnderlineOut}/${SHELLNS_FONT_UNDERLINE_OUT}}"

  strReturn="${strReturn//${code_StrikeIn}/${SHELLNS_FONT_STRIKE_IN}}"
  strReturn="${strReturn//${code_StrikeOut}/${SHELLNS_FONT_STRIKE_OUT}}"

  strReturn="${strReturn//${code_InlineBlockCodeIn}/${SHELLNS_FONT_INLINE_BLOCK_IN}}"
  strReturn="${strReturn//${code_InlineBlockCodeOut}/${SHELLNS_FONT_INLINE_BLOCK_OUT}}"


  local code_x9D="${SHELLNS_ASCII_x9D/\\/\'}"
  strReturn="${strReturn//${code_x9D}/\\\\}"


  for it in "${!assocOriginalFontConfig[@]}"; do
    eval "${it}=\"${assocOriginalFontConfig[${it}]}\""
  done


  echo -ne "${strReturn}${SHELLNS_FONT_RESET}"
}