#!/usr/bin/env zsh

if [[ ! -v ZSH_SESSION_NAME ]]; then
  clpr red "Not inside an active session."
  echo "Please join a session first."
  return 40
fi

if [ ! -d "${ZSHY_SESS_DATA_PATH}/active.${ZSH_SESSION_NAME}" ]; then
  clpr red "Active session's storage directory is not present!!!!!"
  clpr red "!!! ABORTING !!!"
  return 39
fi

if [[ $EDITOR == "" ]]; then
  clpr red "\$EDITOR is not set. Cannot edit the init file"
  echo "Please set \$EDITOR to an editor"
  return 38
else
  $EDITOR "${ZSHY_SESS_DATA_PATH}/active.${ZSH_SESSION_NAME}/init.sh"
fi
