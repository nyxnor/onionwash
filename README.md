# vitor - safely edit tor configuration files

[![demo](https://asciinema.org/a/463445.svg)](https://asciinema.org/a/463445?autoplay=1)

## Architecture

Vitor is a Vi for tor configuration files to be edited in a save manner. It creates a copy of the file you wish to edit, lock the file from being edited in another instance.

Then it selects the editor by looking the environment variables *SUDO_EDITOR*, *DOAS_EDITOR*, *VISUAL*, *EDITOR*. If all are empty, will try commonly used terminal editors that can be found as a command on your system.

After the file is edited and the user exits the editor, tor verify its configuration file but only from the modified file, if invalid, give option to edit again, exit without saving or save with danger flag.

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
