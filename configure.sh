#!/usr/bin/env sh

me="${0##*/}"
toplevel="$(git rev-parse --show-toplevel)"
package_name="onion-wash"
requirements="tor"

error_msg(){
  printf %s"${me}: ${1}\n" >&2
  exit 1
}

usage(){
  printf %s"Usage: ${me} [install|remove|build-deb|install-deb|clean-deb|man|check]

Common:
 install       install on any unix system
 remove        remove the scripts and its manual from your system
 help          print this help message

Debian packaging:
  build-deb    build the debian package
  install-deb  install the debian package
  clean-deb    clean deb artifacts and package

Developer:
  man          generate manual pages
  check        check syntax
"
  exit 1
}

has() {
  _cmd=$(command -v "$1") 2>/dev/null || return 1
  [ -x "$_cmd" ] || return 1
}

case "${1}" in
  install)
    for item in ${requirements}; do
      has "${item}" || miss_dep="${miss_dep} ${item}"
    done
    [ -n "${miss_dep}" ] && error_msg "missing dependency(ies): ${miss_dep}"
    [ "$(id -u)" -ne 0 ] && error_msg "${1} as root"
    for file in "${toplevel}"/usr/bin/*; do
      [ -f "${file}" ] && cp "${file}" /usr/bin/
    done
    for mandir in "/usr/local/man/man8" "/usr/local/share/man/man8" "/usr/share/man/man8"; do
      if [ -d "${mandir}" ]; then
        for man in "${toplevel}"/auto-generated-man-pages/*; do
          manual="${toplevel}/auto-generated-man-pages/${man##*/}"
          [ -f "${manual}" ] && cp "${manual}" "${mandir}" && break
        done
      fi
    done
  ;;

  remove)
    [ "$(id -u)" -ne 0 ] && error_msg "${1} as root"
    for file in "${toplevel}"/auto-generated-man-pages/*; do
      rm -f "/usr/local/man/man8/${file##*/}" "/usr/local/share/man/man8/${file##*/}" "/usr/share/man/man8/${file##*/}"
    done
    for file in "${toplevel}"/usr/bin/*; do
      [ -f "${file}" ] && rm -f "/usr/bin/${file##*/}" "/usr/local/bin/${file##*/}"
    done
  ;;

  build-deb)
    [ "$(id -u)" -ne 0 ] && error_msg "${1} as root"
    command -v mk-build-deps >/dev/null || { apt update -y && apt install -y devscripts ; }
    mk-build-deps --remove --install
    dpkg-buildpackage -b --no-sign
  ;;

  install-deb)
    [ "$(id -u)" -ne 0 ] && error_msg "${1} as root"
    dpkg -i ../"${package_name}"_*.deb
  ;;

  clean-deb)
    rm -rf -- *-build-deps_*.buildinfo *-build-deps_*.changes \
    debian/*.debhelper.log debian/*.substvars \
    debian/.debhelper debian/files \
    debian/debhelper-build-stamp "debian/${package_name}" \
    ../"${package_name}"_*.deb ../"${package_name}"_*.buildinfo ../"${package_name}"_*.changes
  ;;

  man)
    command -v pandoc >/dev/null || error_msg "Install 'pandoc' to create manual pages"
    [ "$(id -u)" -eq 0 ] && printf '%s\n' "${me}: don't generate the manual as root" && exit 1
    for file in "${toplevel}"/usr/bin/*; do
      test -f "${file}" || return
      file_name="${file##*/}"
      script_version="$("${toplevel}/usr/bin/${file_name}" -V)"
      pandoc -s -f markdown-smart -V header="Tor System Manager's Manual" -V footer="${script_version}" -t man "${toplevel}/man/${file_name}.8.md" -o "${toplevel}/auto-generated-man-pages/${file_name}.8"
      sed -i'' "s/default_date/$(date +%Y-%m-%d)/" "${toplevel}/auto-generated-man-pages/${file_name}.8"
    done
  ;;

  check)
    command -v shellcheck >/dev/null || error_msg "Install 'shellcheck' to linter scripts"
    shellcheck "${toplevel}"/usr/bin/*
  ;;

  *) usage;;
esac
