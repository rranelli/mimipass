Mimipass
========

Mimipass is a home-baked convenience tool for storing passwords safely with
`gpg`. Think of it as your personal & local gpg-based `onepassword` clone.

Mimipass uses gpg-agent for all of its hardwork and you should understand how to
use it.

Make sure you have gpg-agent installed and configured at your machine.

Adding the following excerpt to your profile should suffice:

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

# TODO: write a documentation and all
