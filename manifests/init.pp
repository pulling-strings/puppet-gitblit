# This module manages gitblit
class gitblit(
  $version = '1.8.0',
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
    url              => "https://dl.bintray.com/gitblit/releases/gitblit-${version}.tar.gz",
    target           => '/opt/',
    digest_string    => '433a3e9ae296632f9f3d3625413f229c',
    follow_redirects => true,
    timeout          => 900 
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
