#
# main manifest
#

# declare the apache class to use the puppet apache module from puppet labs forge

# https://github.com/puppetlabs/puppetlabs-apache

class { 'apache' : 

}

apache::vhost { 'vhost.example.com':
  port    => '80',
  docroot => '/var/www/vhost',
}
 
file { '/var/www/vhost':
  ensure => directory,
  owner  => 'www-data',
}