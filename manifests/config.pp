# Setting up gitblit config, $repo_folder should exist 
class gitblit::config(
  $repo_folder = undef
){

  validate_string($repo_folder)

  Archive["gitblit-${::gitblit::version}"] -> Editfile <||>

  Editfile <||> ~> Service['gitblit']

  editfile::config { 'repo folder':
    ensure => $repo_folder,
    entry  => 'git.repositoriesFolder',
    path   => '/opt/gitblit/data/gitblit.properties',
    quote  => false
  }

  editfile { 'local host unbind':
    ensure   => absent,
    provider => regexp,
    path     => '/opt/gitblit/data/gitblit.properties',
    match    => '/server.httpsBindInterface.*/',
    notify   => Service['gitblit']
  }

}
