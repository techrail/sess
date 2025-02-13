#!/usr/bin/env zsh

if [ -d "${ZSHY_SESS_DATA_PATH}/active.${1}" ]; then
  clpr red "Cannot delete an active session!"
  echo "Please end the session and try again."
  return 46
fi

if [ ! -d "${ZSHY_SESS_DATA_PATH}/ended.${1}" ]; then
  clpr red "No such session. Cannot delete a non-existent session!"
  return 47
fi

clpr blue "Are you sure?"
clpr blue "-------------"

read -k1 "choice?Are you sure you want to delete session '${1}'? [y/n] "
if [[ $choice = "y" || $choice = "Y" ]]; then
  echo ""
  clpr red "Deleting session"
  rm -r "${ZSHY_SESS_DATA_PATH}/ended.${1}"
  clpr green "...done"
else
  clpr blue "You opted for not deleting the session."
  clpr blue "!!! Aborting !!!"
  return 48
fi

return 0
