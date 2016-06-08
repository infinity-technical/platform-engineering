#!/bin/bash


echo Set up target machine
echo
echo First, ensure that the required applications to create state management are available

echo


UNZIP=$( which unzip )

WGET=$( which wget )

PUPPET=$( which puppet )


if [ "${WGET}" = "" ] ; then
  echo Installing wget
  sudo apt-get install wget
else
  echo Found ${WGET}
fi

if [ "${UNZIP}" = "" ] ; then
  echo installing unzip
  sudo apt-get install unzip
else
  echo Found ${UNZIP}
fi

if [ "${PUPPET}" = "" ] ; then
  echo installing puppet-common from apt.puppetlabs.com as the version in the ubuntu repository does not provide the module subcommand
  DEB=puppetlabs-release-precise.deb
  SOURCE=http://apt.puppetlabs.com/${DEB}
  DESTINATION=/tmp/${DEB}
  wget -O ${DESTINATION} ${SOURCE}
  sudo dpkg -i ${DESTINATION}
  sudo apt-get update
  sudo apt-get install puppet-common
else
  echo Found ${PUPPET}, checking for a version with the module subcommand
  puppet --version
fi


sudo puppet module install puppetlabs-apache


ARCHIVE="master.zip"

REPOSITORY_URL="https://github.com/infinity-technical/platform-engineering/archive/${ARCHIVE}"


echo Downloading repository archive

echo

wget ${REPOSITORY_URL}


echo Unpacking archive

echo

unzip ${ARCHIVE}


sudo puppet apply --verbose --detailed-exitcodes --noop platform-engineering-master/manifests/main.pp
