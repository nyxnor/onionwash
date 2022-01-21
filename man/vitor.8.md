% vitor(8) Edit tor configuration files safely
% Written by nyxnor (nyxnor@protonmail.com)
% default_date

# NAME

vitor - Is a visudo/vidoas but for tor configuration files written in POSIX compliant shell.


# SYNOPSIS

**vitor** [**-h**] [**-u** *tor_user*]  [**-f** *tor_conf*]\

# DESCRIPTION

**vitor** creates a temporary copy of the file specified on *tor_conf* and if file doesn't exist, the editor will create one. Then, it is checked if vitor is already in use on that file by testing if lock file exists, if it does, abort. To get the editor value, it is checked for the environment variables to open the editor with the *SUDO_EDITOR*/*DOAS_EDITOR*, if they are empty try *VISUAL*, if it is also empty try *EDITOR*, if it is also empty fallback to a editor symlinked to the "editor" command, then to a unix text editor first, the Vi(1), else try Vim(1), NVim(1), Nano(1), Pico(1), Emacs(1), Mg(1). If there is no available editor, fail. After exiting the editor, the temporary copy is checked with *tor -f temp_file --verify-config* and if it is invalid, warn the user about the errors and press *e* to continue (loop opens the editor again) or *x* exit which will delete the temporary file and the lock file. If the configuration if valid, save the temporary copy to its original location.


# OPTIONS

**-h**

: Display a short help message and exit.

**-f** *tor_conf*

: Specify the configuration file to open. If *tor_conf* is not set, default to /etc/tor/torrc.

**-u** *tor_user*

: Specify the tor user to run the daemon as. If *tor_user* is not set, the *tor_conf* must contain the \"User\" option already.


# ENVIRONMENT

**SUDO_USER**, **DOAS_USER**

: Used to check where its not only running *vitor* as root but also specifying the command to runuser tor.

**SUDO_EDITOR**, **DOAS_EDITOR**, **VISUAL**, **EDITOR**

: Use environment variables in the above order to define the editor, in case any are empty, fallback to the next. If every variable is empty, fallback to Vi(1).


# EXIT VALUE

**0**
: Success.

**1**
: Fail.


# EXAMPLES

Edit the default configuration file /etc/tor/torrc:
```
vitor
```

Edit a configuration file that does not have the *User* option set (where *debian-tor* is the tor user of your system):
```
vitor -u debian-tor
```

Edit an alternative configuration file (note *-f* is not needed if the file is the last positional argument):
```
vitor -u debian-tor /usr/local/etc/tor/torrc.d/50_user.conf
```

# SEE ALSO

tor(1)


# COPYRIGHT

Copyright  ©  2021 OnionJuggler developers (MIT)
Copyright  ©  2022 Vitor developers (MIT)
This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to the extent permitted by law.
