#!/bin/sh

# Exit on error and turn on debug
#
set -ex

# Update Certificates
#
update-ca-certificates

# https://wiki.alpinelinux.org/wiki/Package_management#Upgrade_a_Running_System
# "To get the latest security upgrades and bugfixes available for the 
#  installed packages of a running system, first update the list of available
#  packages and then upgrade the installed packages:"
#
# Documentation also indicates you can do an
#   apk -U upgrade
#
#/sbin/apk update
#/sbin/apk upgrade
/sbin/apk -U upgrade

# Add a non-root user
#
adduser -D -u1000 gonzo

exit 0
