#!/bin/bash


echo = Set up target machine
echo
echo == First, ensure that the required applications to create state management are available
echo


GIT=$( which git )

PUPPET=$( which puppet )


if [ "${GIT}" = "" ] ; then
  echo = Installing git
  sudo apt-get install -y git
else
  echo = Found ${GIT}
fi

if [ "${PUPPET}" = "" ] ; then
  echo = Installing puppet-common from apt.puppetlabs.com as the version in the ubuntu repository does not provide the module subcommand
  DEB=puppetlabs-release-precise.deb
  SOURCE=http://apt.puppetlabs.com/${DEB}
  DESTINATION=/tmp/${DEB}
  wget -O ${DESTINATION} ${SOURCE}
  sudo dpkg -i ${DESTINATION}
  sudo apt-get update
  sudo apt-get install puppet-common
else
  echo = Found ${PUPPET}, checking for a version with the module subcommand
  puppet --version
fi


echo = Installing PuppetLabs Apache module

sudo puppet module install puppetlabs-apache


REPOSITORY="https://github.com/infinity-technical/platform-engineering.git"


echo = Cloning state management system

if [ -d platform-engineering ] ; then
  echo == Removing legacy platform-engineering/
  rm -rf platform-engineering
fi


echo == Downloading repository
echo

git clone ${REPOSITORY}

echo = State management

sudo puppet apply --verbose --detailed-exitcodes --noop platform-engineering/puppet/manifests/main.pp
