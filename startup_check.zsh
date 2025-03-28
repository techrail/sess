#!/usr/bin/env zsh

if [ $# -lt 1 ]; then
  echo "You are not supposed to call this command manually"
  return 100
fi

# Check if the variable is set
if [[ ! -v ZSHY_SESS_DATA_PATH ]]; then
  # Let's check if the ZSHY extensions data directory is set or not
  if [[ -v ZSHY_EXT_DATA ]]; then 
    # It is defined. Check if the path exists 
    if [ -d $ZSHY_EXT_DATA ]; then
      ZSHY_SESS_DATA_PATH="$ZSHY_EXT_DATA/sess"
    else
      # We will try to create that directory 
      mkdir -p "$ZSHY_EXT_DATA/sess"
      if [ $? -ne 0 ]; then 
        echo "E#29W1QV: ZSHY_SESS_DATA_PATH could not be determined."
        echo "The directory $ZSHY_EXT_DATA/sess is supposed to exist but it does not"
        echo "Cannot continue. Please create the above directory and then "
        return 1
      fi

      # If we are here then the directory got created.
      ZSHY_SESS_DATA_PATH="$ZSHY_EXT_DATA/sess"
    fi
  else
    # ZSHY extensions data folder is also not set.
    echo "E#29W1X5: ZSHY_SESS_DATA_PATH is not set."
    echo "Sessions needs a directory to store sessions data."
    echo "Create the directory and set ZSHY_SESS_DATA_PATH to that value."
    return 1
  fi
fi

# Check that the directory exists
if [ -e "$ZSHY_SESS_DATA_PATH" ]; then
  # Path exists
  # Check if it is a file.
  if [ -f "$ZSHY_SESS_DATA_PATH" ]; then
    # It is a file.
    echo "ZSHY_SESS_DATA_PATH points to a file."
    echo "Please make sure that it points to a directory."
    return 2
  fi

  # Check that it is not a symbolic link
  if [ -d "$ZSHY_SESS_DATA_PATH" ]; then
    if [ -L "$ZSHY_SESS_DATA_PATH" ]; then
      echo "ZSHY_SESS_DATA_PATH is a symlink to a directory."
      echo "Please make sure that it points to a directory, not to a symlink."
      return 2
    fi
  else
    echo "ZSHY_SESS_DATA_PATH points to an address which is not a directory."
    echo "Please make sure that it points to a directory."
    return 4
  fi
else
  echo "ZSHY_SESS_DATA_PATH points to a non-existent location:"
  echo "$ZSHY_SESS_DATA_PATH"
  echo "Sessions needs a directory to store sessions data."
  echo "Create the directory and set ZSHY_SESS_DATA_PATH to that value."

  echo "Run this to create the directory:"
  echo ""
  echo "mkdir -p $ZSHY_SESS_DATA_PATH"

  return 5
fi

return 0
