#
# main manifest
#

# declare the apache class to use the puppet apache module from puppet labs forge

# https://github.com/puppetlabs/puppetlabs-apache

class { 'apache' :

    # this class models the installation and configuration of the apache web server package
    # the version parameter defaults to latest

    apache::vhost { 'localhost' :
        port => 80,
        docroot => '/opt/web/www',
        docroot_owner => 'www-data',
        docroot_group => 'www-data',
    }

}