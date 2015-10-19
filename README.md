Mimipass
========

# Disclaimer

Mimipass is a simple tool I hacked in like, 5 hours, for my own amusement and to
learn a bit about how to use `gpg`. It is experimental and lacks many features. If
you want a full-blown shell-friendly password management solution, have a look
at [pass](http://www.passwordstore.org/)

Mimipass was also only tested with Debian GNU/Linux. If you're at some other
platform you should look at [pass](http://www.passwordstore.org/).

# Introduction

Mimipass is a home-baked convenience tool for storing passwords safely with
`gpg`. Think of it as your personal & local `gpg`-based `onepassword` clone.

Mimipass uses `gpg-agent` for all of its hardwork and you should understand how to
use it.

# Setup

## Installation

In order to use `Mimipass` from the command line, you can add a symlink to
`/bin/`. This is wrapped in the provided `link-mimipass` script:

```
$ ./link-mimipass
# Done!
```

The script will also add auto-completion to bash if `/etc/bash_completion.d`
exists.

With this, calling `mimipass` directly from the shell will work.

## `gpg-agent` configuration

Mimipass is just a simple frontend to `gpg-agent` optimized to deal with
passwords. Every meaningful configuration must be done at the `gpg-agent` level.

In order to use it, you must set the two following environment variables:
`MIMIPASS_HOME` and `MIMIPASS_RECIPIENT` which correspond to the directory to
put encrypted password files and the name of the recipient for the `gpg`'s
public key to be used.

Make sure you have `gpg-agent` installed and configured at your machine. A good
introduction to `gpg` is available
[here](http://www.ianatkinson.net/computing/gnupg.htm)

Adding the following excerpt to your profile should suffice to start `gpg-agent`
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

If you have the `gnome-keyring-daemon` in your system, it will high-jack the
`gpg-agent`. See [this link](http://wiki.gnupg.org/GnomeKeyring) for more info.
If you're under this situation, you can configure the `gpg-cache` with the
following commands:

```sh
$ gsettings set org.gnome.crypto.cache gpg-cache-method 'timeout'
$ gsettings set org.gnome.crypto.cache gpg-cache-ttl 3600
```

# Usage

Below are an example of the typical functionalities provided by `Mimipass`. The
examples assume that you have a `gpg-agent` configured with the `passphrase`
cached.

Auto-completion is provided for `Bash`.

```sh
$ mimipass import         # Import mimipass keys into gpg keyring
# => gpg: key BDD12B22: "renan ranelli <myemail@gmail.com>" not changed
# => gpg: Total number processed: 1
# => gpg:              unchanged: 1
# => gpg: key BDD12B22: already in secret keyring
# => gpg: Total number processed: 1
# => gpg:       secret keys read: 1
# => gpg:  secret keys unchanged: 1
$ mimipass export
# => File `/mimipass/home/.secrets/publickey.txt' exists. Overwrite? (y/N) y
# => File `/mimipass/home/.secrets/privatekey.txt' exists. Overwrite? (y/N) y
# => Done!
$ mimipass new            # generates a new password of 64 characters
# => aVJ3OXn5VnIdS/2P7KpfvtYZANXy5DP3hm4yt9vvAFWwneqYsa3qIJiN6+QVmU//
$ mimipass new 8          # you can also specify the size of the password
# => ak17aQ2R
$ mimipass get test       # recover a previously set password
# => Couldn't find [ test ] in the passwd list
$ mimipass set test       # ops. We forgot to set it. let's do it now
# => Type the text. Press C-d when done.
# => 1234
# => Done!
$ mimipass get test       # Voilá !
# => 1234
$ mimipass copy test      # Send the password to the clipboard (requires xclip)
# => Password [ test ] sent to clipboard :)
$ mimipass new-set test2  # generate a new password and set it to `test2`
# => Done!
$ mimipass get test2      # it works!
# => OVv5FQi5maQlgrAfJtn8E+rldsGNgfazrbF/HLX4WvskwHpmm8wiPuxIRq96Edy+
$ mimipass new-set test3 8 # and of course you can specify its size
# => Done!
$ mimipass get test3
# => laENWYpt
$ mimipass delete test3
# => Are you sure [y/N]?
# => y
# => Done!
$ mimipass get test3
# => Couldn't find [ test3 ] in the passwd list
$ logout # byebye
```

# Development

## Testing

You can perform a regression test by executing the `test.sh` script. Executing
`test.sh` is also a nice way to check if your system is working correctly.
