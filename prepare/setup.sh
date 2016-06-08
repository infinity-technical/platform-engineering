#!/bin/bash


echo Requires unzip, wget and puppet

echo


UNZIP=which unzip

WGET=which wget

PUPPET=which puppet


if [ "${UNZIP}" = "" ] ; then
  echo unzip not found
  exit 1
fi

if [ "${WGET}" = "" ] ; then
  echo wget not found
  exit 2
fi

if [ "${PUPPET}" = "" ] ; then
  echo puppet not found
  exit 3
fi



ARCHIVE="master.zip"

REPOSITORY_URL="https://github.com/infinity-technical/platform-engineering/archive/${ARCHIVE}"


echo Downloading repository archive

echo

wget ${REPOSITORY_URL}


echo Unpacking archive

echo

unzip ${ARCHIVE}


cd platform-engineering-master

ls -l
