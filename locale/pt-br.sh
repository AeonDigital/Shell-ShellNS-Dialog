#!/usr/bin/env bash

#
# Message to be shown to the user when there is a list of valid
# options to select.
SHELLNS_PROMPT_OPTION_TEXT_SELECT="Selecione uma das seguintes opções:"


#
# Picklist for Boolean values.
unset SHELLNS_PROMPT_OPTION_BOOL
declare -gA SHELLNS_PROMPT_OPTION_BOOL=(
  ["0"]="n não cancelar"
  ["1"]="s sim ok confirmar"
)
#
# Picklist for Contextualized Boolean values.
unset SHELLNS_PROMPT_OPTION_BOOL_ENABLED
declare -gA SHELLNS_PROMPT_OPTION_BOOL_ENABLED=(
  ["0"]="d desativar"
  ["1"]="a ativar"
)


#
# Labels
SHELLNS_DIALOG_LBL_ERROR_INVALID_VALUE="Valor inválido."
SHELLNS_DIALOG_LBL_ERROR_REQUIRED_VALUE="Valor obrigatório."