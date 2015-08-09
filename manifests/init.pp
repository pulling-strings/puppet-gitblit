# This module manages gitblit
class gitblit(
  $version = '1.6.2',
  $users = {},
  $backup = true,
  $keys = [],
  $user = 'ubuntu'
){

  include gitblit::config

  if($backup){
    include gitblit::backup
  }

  create_resources(gitblit::user, $users)

  class{'jdk':
    version => 7
  }

  archive { "gitblit-${version}":
    ensure           => present,
    url              => "http://dl.bintray.com/gitblit/releases/gitblit-${version}.tar.gz",
    target           => '/opt/gitblit/',
    digest_string    => '12158ff9d28a9cfaa209bed690796fe8',
    follow_redirects => true
  } ->

  file { '/etc/init.d/gitblit':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/gitblit/gitblit',
    owner  => root,
    group  => root,
  }

  service{'gitblit':
    ensure    => running,
    enable    => true,
    hasstatus => false,
    require   => [File['/etc/init.d/gitblit'], Class['jdk']]
  }

  if $keys != [] {
    create_resources(ssh_authorized_key, $keys, {user => $user})
  }
}
