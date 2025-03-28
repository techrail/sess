#!/usr/bin/env zsh

echo "Usage: You can use sess in one of the following ways:"
echo ""
echo "sess MGMT_OPERATION sess_name"
echo "sess -l LIST_TYPE"
echo "sess --editinit"
echo ""
echo "MGMT_OPERATION can be one of:"
echo "  -c (or --create)  Creates a new session with sess_name as its name."
echo "                    Created session will be joined immediately"
echo "  -j (or --join)    Joins the session with sess_name. The session must already exist."
echo "                    Adding '--loop' after the session name will rejoin the session"
echo "                      for upto 10 quits."
echo "  -e (or --end)     Ends the session with sess_name."
echo "  -D (or --delete)  Deletes an ended session with sess_name from disk."
echo "  --editinit        Opens your \$EDITOR to let you edit the sess_name's init.sh file"
echo ""
echo "LIST_TYPE can be one of:"
echo "  a (or active)     For listing active sessions"
echo "  l (or live)       For listing live sessions"
echo "                    Live sessions are active sessions running in a terminal right now"
echo "  e (or ended)      For listing ended sessions"
echo "  A (or all)        For listing all sessions"
echo ""
echo "The --editinit option opens nano to let you edit the active session's init.sh file"
echo "  This option requires that you are already inside the session whose init file you want to edit."
