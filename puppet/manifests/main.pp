#
# main manifest
#

# declare the apache class to use the puppet apache module from puppet labs forge

# https://github.com/puppetlabs/puppetlabs-apache

class { 'apache' :

    # this class models the installation and configuration of the apache web server package
    # the version parameter defaults to latest

    apache::vhost { 'localhost' :
        servername    => 'localhost',
        ip_based      => true,
        ip            => '10.0.2.15',
        port          => 80,
        docroot       => '/var/www',
        docroot_owner => 'www',
        docroot_group => 'www',
        proxy_pass    => [
                            {'path' => '/', 'url' => 'http://localhost:1337' },
                         ]
    }

}