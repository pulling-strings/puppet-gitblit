# Setting up gitblit users
define gitblit::user(
  $password = undef,
  $roles = []
) {

  validate_string($password)

  concat { '/opt/gitblit/data/users.conf':
    ensure => present,
  }

  concat::fragment {'users.conf' :
    target  => '/opt/gitblit/data/users.conf',
    content => template('gitblit/user.erb'),
    order   => '00',
    require => Archive["gitblit-${::gitblit::version}"]
  } ~> Service['gitblit']

  #
  # file { '/opt/gitblit/data/users.conf':
  #   ensure  => file,
  #   mode    => '0644',
  #   content => template('gitblit/users.conf.erb'),
  #   owner   => root,
  #   group   => root,
  #   require => Archive["gitblit-${::gitblit::version}"]
  # } ~> Service['gitblit']
}
