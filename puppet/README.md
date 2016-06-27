# Platform engineering test

## Puppet

|Content |Notes |
|-----------|-------|
| files/     |Static files |
| hiera/     |Hierarchical data YAML |
| manifests/ |State operations |
| templates/ |File templates for Hiera data |

# Technical tasks

## Prepare for implementation 

* Back up target and ensure restoration is viable

## Test the solution

* Create test web server with current functionality
* Mock or install node service on test web server and test
* Install git and Puppet to test web server
* Clone manifest and other automation resources to test web server
* Configure Apache with Puppet on test web server
* Test for differences in Apache configuration between test web server and target web server
* Test site functionality on test web server

## Prepare a replacement server 

* Install git and Puppet to replacement web server
* Clone manifest and other automation resources to replacement web server
* Configure Apache with Puppet on replacement web server
* Test site functionality on replacement web server

## Launch replacement 

* Update DNS to point traffic to replacement web server
* Decomission target web server
* Review
