#!/usr/bin/env bash

#
# Get path to the manuals directory.
SHELLNS_TMP_PATH_TO_DIR_MANUALS="$(tmpPath=$(dirname "${BASH_SOURCE[0]}"); realpath "${tmpPath}/src-manuals/${SHELLNS_CONFIG_INTERFACE_LOCALE}")"


#
# Mapp function to manual.
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_dialog_reset"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/dialog/reset.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_dialog_set"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/dialog/set.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_dialog_show"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/dialog/show.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_prompt_get"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/prompt/get.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_prompt_prepareOptions"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/prompt/prepareOptions.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_prompt_reset"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/prompt/reset.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_prompt_set"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/prompt/set.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_prompt_show"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/prompt/show.man"


#
# Mapp namespace to function.
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["dialog.reset"]="shellNS_dialog_reset"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["dialog.set"]="shellNS_dialog_set"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["dialog.show"]="shellNS_dialog_show"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["prompt.get"]="shellNS_prompt_get"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["prompt.prepareOptions"]="shellNS_prompt_prepareOptions"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["prompt.reset"]="shellNS_prompt_reset"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["prompt.set"]="shellNS_prompt_set"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["prompt.show"]="shellNS_prompt_show"





unset SHELLNS_TMP_PATH_TO_DIR_MANUALS