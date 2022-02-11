% onion-parser(8) Edit tor configuration files safely
% Written by Iry Koon (iry@riseup.net), Patrick Schleizer (adrelanos@whonix.org) and nyxnor (nyxnor@protonmail.com)
% default_date


# NAME

onion-parser(8) -- Tor configuration verification tool


# SYNOPSIS

**onion-parser** [*OPTION*]


# DESCRIPTION

**onion-parser** is a user-friendly wrapper around *tor --verify-config*. It will do a proper tor configuration verification and then generate an easy to understand report with useful suggestions.

**-h**, **--help**
: display this help and exit

**-v**, **--verbose**
: show an additional report on how tor configuration is parsed, excluding comments in the configuration files

**-vv**, **--very-verbose**
: show an additional report on how tor configuration is parsed, including comments in the configuration files

**-V**, **--version**
: show version number and exit


# EXIT VALUE

**0**
: Success.

**1**
: Fail.


# AUTHOR

This man page was written by Iry Koon (iry@riseup.net) and nyxnor (nyxnor@protonmail.com)


# COPYRIGHT

Copyright (C) 2022 nyxnor <nyxnor@protonmail.com>

Copyright (C) 2018 - 2021 ENCRYPTED SUPPORT LP <adrelanos@whonix.org>

Copyright (C) 2018 Iry Koon <iry@riseup.net>

See the file COPYING for copying conditions.
