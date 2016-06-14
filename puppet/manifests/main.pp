#
# main manifest
#

# declare the apache class to use the puppet apache module from puppet labs forge

# https://github.com/puppetlabs/puppetlabs-apache

class { 'apache' : 

}

# for now, there is an additional line added to the test machine /etc/hosts
# 127.0.0.1 vhost.example.com

apache::vhost { 'vhost.example.com':
  port    => '80',
  docroot => '/var/www/vhost',
}
 
file { '/var/www/vhost':
  ensure => directory,
  owner  => 'www-data',
}

file { '/var/www/vhost/index.html':
  ensure  => present,
  content => file ('/home/ubuntu/platform-engineering/puppet/files/vhost-index.html'),
}