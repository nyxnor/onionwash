# vitor - safely edit tor configuration files

[![demo](https://asciinema.org/a/463445.svg)](https://asciinema.org/a/463445?autoplay=1)

## Architecture

Vitor is a Vi for tor configuration files to be edited in a save manner. It creates a copy of the file you wish to edit, lock the file from being edited in another instance.

Then it selects the editor by looking the environment variables *SUDO_EDITOR*, *DOAS_EDITOR*, *VISUAL*, *EDITOR*. If all are empty, will try commonly used terminal editors that can be found as a command on your system.

After the file is edited and the user exits the editor, tor verify its configuration file but only from the modified file, if invalid, give option to edit again, exit without saving or save with danger flag.

## Installation

### How to install on any unix system

Install the script and the manual:
```sh
sudo ./configure.sh install
```

### How to build deb package from source sode

#### Build the package

Install developer scripts:
```sh
sudo apt install -y devscripts
```

Install build dependencies.
```sh
sudo mk-build-deps --remove --install
```
If that did not work, have a look in `debian/control` file and manually install all packages listed under Build-Depends and Depends.

Build the package without signing it (not required for personal use) and install it.
```sh
dpkg-buildpackage -b
```

#### Install the package

The package can be found in the parent folder.
Install the package:
```sh
sudo dpkg -i ../vitor_*.deb
```

#### Clean up

Delete temporary debhelper files in package source folder as well as debhelper artifacts:
```sh
sudo rm -rf *-build-deps_*.buildinfo *-build-deps_*.changes \
debian/*.debhelper.log debian/*.substvars \
debian/.debhelper debian/files \
debian/debhelper-build-stamp debian/vitor
```

Delete debhelper artifacts from the parent folder (including the .deb file):
```sh
sudo rm -f ../vitor_*.deb ../vitor_*.buildinfo ../vitor_*.changes
```

## Usage

Vitor must be run as root if the configuration folder is owned by root, but in the case the configuration folder is owned by the tor user, you must run vitor as the tor user.

```sh
sudo vitor
sudo -u debian-tor vitor
```

Edit the default tor configuration file /etc/tor/torrc:
```sh
sudo vitor
```

Edit configuration file that does not contain the *User* option set:
```sh
sudo vitor -u debian-tor
```

Edit an alternative configuration file:
```sh
sudo vitor -u debian-tor /usr/local/etc/tor/torrc.d/50_user.conf
```
