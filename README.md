Mimipass
========

# Disclaimer

Mimipass is a simple tool I hacked in like, 5 hours, for my own amusement and to
learn a bit about how to use gpg. It is experimental and lacks many features. If
you want a full-blown shell-friendly password management solution, have a look
at [pass](http://www.passwordstore.org/)

# Introduction

Mimipass is a home-baked convenience tool for storing passwords safely with
`gpg`. Think of it as your personal & local gpg-based `onepassword` clone.

Mimipass uses `gpg-agent` for all of its hardwork and you should understand how to
use it.

# Set up

In order to use `Mimipass` from the command line, you can add a symlink to
`/bin/`. This is wrapped in the provided `link-mimipass` script:

```
$ ./link-mimipass
# Done!
```

The script will also add auto-completion to bash if `/etc/bash_completion.d`
exists.

With this, calling `mimipass` directly from the shell will work.

Make sure you have `gpg-agent` installed and configured at your machine. A good
introduction to `gpg` is available
[here](http://www.ianatkinson.net/computing/gnupg.htm)

Adding the following excerpt to your profile should suffice to start gpg-agent
when needed:

```sh
# Invoke GnuPG-Agent the first time we login.
# Does `~/.gpg-agent-info' exist and points to gpg-agent process accepting signals?
if test -f $HOME/.gpg-agent-info && \
    kill -0 `cut -d: -f 2 $HOME/.gpg-agent-info` 2>/dev/null; then
    GPG_AGENT_INFO=`cat $HOME/.gpg-agent-info | cut -c 16-`
else
    # No, gpg-agent not available; start gpg-agent
    eval `gpg-agent --daemon --no-grab --write-env-file $HOME/.gpg-agent-info`
fi
export GPG_TTY=`tty`
export GPG_AGENT_INFO
```
