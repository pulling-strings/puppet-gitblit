# Setting up gitblit users
class gitblit::user($password = undef) {
  
  validate_string($password)

  file { '/opt/gitblit/data/users.conf':
    ensure  => file,
    mode    => '0644',
    content => template('gitblit/users.conf.erb'),
    owner   => root,
    group   => root,
    require => Archive["gitblit-${::gitblit::version}"]
  } ~> Service['gitblit']
}
