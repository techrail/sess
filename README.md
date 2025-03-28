# sess

`sess` is a **session manager** for terminal which is **not a terminal multiplexer**. Using sess you can create sessions that have different environments. A session, in this context, is an _isolated environment_ in a shell. Think of it like creating a separate `.zshrc` file for one tab in your terminal window for a particular usecase. That's what this tool does. 

## What gets isolated?
In a session created by `sess`, you would have basically two things:

1. **A separate history file**: Since a session is supposed to be different from the default session of your shell as well as from the other sessions, each session gets its own history file.
2. **An init script**: When you create a session, an init script is created with it. Whenever you join the session, that init script is `source`d.

You can use the init script to create aliases, set and alter your environment variables and to create custom functions which are available only in that session! You can check out the usecases below to understand how this can help.
## Installation
To install `sess`, you need to first **have [zshy](https://github.com/techrail/zshy) installed** first and have created the extensions directory. Without that, `sess` will not work properly. Once you have done that, run: 

```
zshy install https://github.com/techrail/sess.git 
```

Once the installation completes, you can open a new terminal window (or tab) and try running the `sess` command. If it works, sess is installed.

**NOTE**: On the first run, `sess` might complain with an error message like this: `ZSHY_SESS_DATA_PATH points to a non-existent location`. It should also give you a command to create that  path. Please run that command to create the directory. It is in that directory that your sessions (the history file, the init file and the lock file) are stored.
## Usage and options
**FINISH THIS SECTION**


When you run sess, you will get the following output. So let's discuss the options listed.

```
Usage: You can use sess in one of the following ways:

sess MGMT_OPERATION sess_name
sess -l LIST_TYPE
sess --editinit

MGMT_OPERATION can be one of:
  -c (or --create)  Creates a new session with sess_name as its name.
                    Created session will be joined immediately
  -j (or --join)    Joins the session with sess_name. The session must already exist.
                    Adding '--loop' after the session name will rejoin the session
                      for upto 10 quits.
  -e (or --end)     Ends the session with sess_name.
  -D (or --delete)  Deletes an ended session with sess_name from disk.
  --editinit        Opens your $EDITOR to let you edit the sess_name's init.sh file

LIST_TYPE can be one of:
  a (or active)     For listing active sessions
  l (or live)       For listing live sessions
                    Live sessions are active sessions running in a terminal right now
  e (or ended)      For listing ended sessions
  A (or all)        For listing all sessions

The --editinit option opens \$EDITOR to let you edit the active session's init.sh file
  This option requires that you are already inside the session whose init file you want to edit.
```

### States of sessions and listing
A session can be in one of the two primary states after creation:

1. **Active**: A session that has just been created is marked as active. A session that has been joined and is currently being used in a terminal can be called "live". A session stays in "active" mode until you "end" them. _Please remember that a session that was joined but it was not ended cleanly will appear live till it is ended._
2. **Ended**: A session ends when you issue the command to end it. 

Listing of sessions can be done using the `-l` option along with the filter. The filter can list 

- **just active sessions** (`a`) : `sess -l a`
- **just live sessions** (`l`): `sess -l l`
- **just ended sessions** (`e`): `sess -l e` 
- **all sessions irrespective of their states** (`A`): `sess -l A`
### Session Management options
There are 4 actions that you can take with a session (other than listing it and editing the init script):

1. **Create**: _Obviously!_
2. **Join**: You can join the session. Doing so will launch a new sub-shell from where you launched it! When you exit the shell (using either `Ctrl + D` or `exit`), you will return to the old shell (and the old environment) from where you joined the session. 
3. **End**: You can end a session. You can only end a session which is _active_ but not _live_. Please note that _if you ever exit a session by killing it forcefully, such as by closing the terminal tab, of if your computer crashed or lost power while you were in a session, then that session will always appear to be live_!
4. **Delete**: You can delete a session. However, you can only delete a session which you have ended. 

**VERY IMPORTANT: DELETING A SESSION WILL DELETE THE ASSOCIATED HISTORY FILE, INIT FILE AND THE LOCK FILE FROM THE DISK PERMANENTLY. PLEASE BE CAREFUL!**
## Usecases
The origin story of `sess` is an interesting one, and a compelling reason why you might want `sess` too. Since then I have found multiple reasons to use sess. Some of them are: 
### Having a separate `$PATH`
Sometimes you need to use different versions of software which are located at different places in your filesystem but you can't keep updating your `$PATH` everytime you need to do that, right!?

For example, you want to run the new version of `go` for testing your software, before you switch to it. Create a session with this in the init file.

```
export PATH=/path/to/new-go/bin:$PATH
```

And join the session. Your path (for only that session would be updated)!
### Working with Production Data
So normally, we just <kbd>↑</kbd>  <kbd>↑</kbd>  <kbd>↑</kbd>  <kbd>↑</kbd>   and press enter to run a command, or press <kbd>Ctrl</kbd> + <kbd>r</kbd>  and type a command and press enter and execute it. But what if one of the previous commands was  `dropdb companydb`? Doing that by mistake can be disaster! `sess` protects you in two ways: 
	- A separate history file would make sure that the commands that you executed previously is different and hopefully, in a production context does not contain a `dropdb` command.
	- You can write an alias like `alias dropdb="echo 'dropdb not allowed in production'"` in your session init file and that should help protect you from a disaster (aliases have a higher order precedence over executables located in `$PATH`)

Depending on what you do, this can be very helpful. The original usecase of `sess` is very similar to this usecase.
## Having helper functions for certain tasks
One of my regular needs includes dumping the contents of a database onto my disk once in a while. The total task can take hours and includes issuing around 30-40 commands to do it properly or else the rest of the workflow (for which I need to do it) won't work.

In such a case, having a separate session where a function to automate that task exists works well.
## Switching to a directory automatically in a session
So think of a session named `temp` which when switched to, `cd`'s to `/tmp`. Put this line in the session's init file: 

```
cd /tmp
```

and that would put you in `/tmp` every time you join the session!

### The original usecase
I was working for a well-known multinational company as a DevOps engineer. At the time I was working on a project where we had to migrate a kubernetes cluster from one provider to another. Part of the work was to analyse how the production and staging environments were configured and try to replicate the same setting in the target environment. There were a lot of apps, their configurations and dependencies to move and the entire dependency graph wasn't completely clear.

The typical workday for me (and a couple of others on the team) involved creating and destroying kubernets clusters all day long with various configurations to test. So, one evening, as the traffic was rising outside the office and I was in a bit of hurry to leave, I wrote the deletion command for a cluster and was about to press <kbd>enter</kbd> when I thought to myself "not sure which context is active in this tab". I ran the `echo $KUBECONFIG` and found that I was in the production context for one of the global regions covering 1/4th of the planet. Thousands of other companies that relied on that installation would have suffered had I pressed that button.

The idea of `sess` and of [zshy](https://github.com/techrail/zshy) comes from that evening!

PS: I hope my account did not have the permission to run deletion command against that prod cluster but I would hate for anybody to find that out by trying to delete it.

## Need Help? 
If you want some help related to `sess`, please come over to [Techrail Discord](https://discord.gg/aKkWFghPrV) and ask a question (the _General_ channel is fine for it).
