# Setting up gitblit users
define gitblit::user(
  $password = undef,
  $roles = []
) {

  validate_string($password)

  ensure_resource('concat','/opt/gitblit/data/users.conf',{ensure => present})

  concat::fragment {"add user ${name}" :
    target  => '/opt/gitblit/data/users.conf',
    content => template('gitblit/user.erb'),
    order   => '00',
    require => Archive["gitblit-${::gitblit::version}"]
  } ~> Service['gitblit']
}
