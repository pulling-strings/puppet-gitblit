# Setting up gitblit users
define gitblit::user(
  $password = undef,
  $roles = [],
  $keys  = []
) {

  validate_string($password)

  ensure_resource('concat','/opt/gitblit/data/users.conf',{ensure => present})

  ensure_resource('concat',"/opt/gitblit/data/ssh/${name}.keys",{ensure => present})

  concat::fragment {"add user ${name}" :
    target  => '/opt/gitblit/data/users.conf',
    content => template('gitblit/user.erb'),
    order   => '00',
    require => Archive["gitblit-${::gitblit::version}"]
  } ~> Service['gitblit']

  concat::fragment {"add keys for ${name}" :
    target  => "/opt/gitblit/data/ssh/${name}.keys",
    content => template('gitblit/keys.erb'),
    order   => '00',
    require => Archive["gitblit-${::gitblit::version}"]
  } ~> Service['gitblit']
}
