# OnionWash - sanitize tor configuration files

If you don't clean your onions, you might only see half of a worm after a bite.

## onion-parser - parse tor configuration files elegantly

Wrapper aroung tor option `--verify config` to parse configuration files and verify if they are valid.

Also shows the order the files were parsed and their options if being verbose.

## vitor - safely edit tor configuration files

Vitor is a Vi for tor configuration files to be edited in a save manner. It creates a copy of the file you wish to edit, lock the file from being edited in another instance.

Then it selects the editor by looking the environment variables *SUDO_EDITOR*, *DOAS_EDITOR*, *VISUAL*, *EDITOR*. If all are empty, will try commonly used terminal editors that can be found as a command on your system.

After the file is edited and the user exits the editor, tor verify its configuration file but only from the modified file, if invalid, give option to edit again, exit without saving or save with danger flag.

[![asciicast](https://asciinema.org/a/470389.svg)](https://asciinema.org/a/470389)

## Installation

### Requirements

All scripts requires the `tor` program, but vitor also requires an program to run as another user, specifically `sudo` or `doas`.

### How to install on any unix system

Install the script and the manual:
```sh
sudo ./configure.sh install
```

### How to build deb package from source sode

#### Build the package

Install developer scripts:
```sh
sudo apt install -y devscripts equivs
```

Install build dependencies.
```sh
sudo mk-build-deps --remove --install
```
If that did not work, have a look in `debian/control` file and manually install all packages listed under Build-Depends and Depends.

Build the package without signing it (not required for personal use) and install it.
```sh
dpkg-buildpackage -b --no-sign
```

#### Install the package

The package can be found in the parent folder.
Install the package:
```sh
sudo dpkg -i ../onionwash_*.deb
```

#### Clean up

Delete temporary debhelper files in package source folder as well as debhelper artifacts:
```sh
sudo rm -rf *-build-deps_*.buildinfo *-build-deps_*.changes \
debian/*.debhelper.log debian/*.substvars \
debian/.debhelper debian/files \
debian/debhelper-build-stamp debian/onionwash
```

Delete debhelper artifacts from the parent folder (including the .deb file):
```sh
sudo rm -f ../onionwash_*.deb ../onionwash_*.buildinfo ../onionwash_*.changes
```

## Usage

### vitor

vitor must not be run as root, in the case of a GUI editor, it would be catastrophic. Instead, the script will only do the necessary tasks as root using `sudo` or `doas`, edit the file as the normal user.

If no file is provided on the command line, it autodetects your tor configuration file if using [OnionJuggler](https://github.com/nyxnor/onionjuggler) or [Whonix](https://whonix.org).

Edit the user tor configuration file /etc/tor/torrc (On Whonix: /usr/local/etc/tor/torrc.d/50_user.conf)
```sh
vitor
```

Edit any tor configuration file:
```sh
vitor -f /usr/share/tor/tor-services-defaults/torrc
```

Set your editor with the variable `VISUAL`:
```sh
export VISUAL="mousepad"
vitor
```

#When using `doas`, set environment variables persist root or debian-tor login by using option `keepenv` for your user on doas.conf.
### onion-parser

onion-parser must be run as root and the tor configuration files included must have the *User* option set.

Run onion-parser:
```sh
sudo onion-parser
```

See how the files are parsed:
```sh
sudo onion-parser -v
```

Include comments when parsing files:
```sh
sudo onion-parser -vv
```
