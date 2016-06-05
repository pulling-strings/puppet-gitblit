# This module manages gitblit
class gitblit(
  $version = '1.7.1',
  $users = {},
  $backup = true
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
    target           => '/opt/',
    digest_string    => '093b73a21f45d47f6af7d2c304a299d2',
    follow_redirects => true
  } ->

  file{'/opt/gitblit':
    ensure => link,
    target => "/opt/gitblit-${version}"
  }

  file { '/etc/init.d/gitblit':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/gitblit/gitblit',
    owner  => root,
    group  => root,
  } ->

  file { '/etc/systemd/system/gitblit.service':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/gitblit/gitblit.service',
    owner  => root,
    group  => root,
  } ->

  exec{'enable service':
    command => 'systemctl enable gitblit.service',
    user    => 'root',
    path    => ['/usr/bin','/bin',]
  } ->

  service{'gitblit':
    ensure    => running,
    provider  => 'systemd',
    enable    => true,
    hasstatus => false,
    require   => [File['/etc/init.d/gitblit'], Class['jdk']]
  }

}
