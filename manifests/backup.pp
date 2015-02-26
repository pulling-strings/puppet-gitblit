# Setting up backup for git repos into s3
class gitblit::backup(
  $bucket     = undef,
  $pass       = undef,
  $user       = undef,
  $passphrase = undef
){

  validate_string($bucket, $pass, $user, $passphrase)

  include barbecue

  backup::duply {'gitblit-repos':
    source      => $::gitblit::config::repo_folder,
    target      => $bucket,
    target_pass => $pass,
    target_user => $user,
    passphrase  => $passphrase,
    globs       => ''
  }

  backup::duply::schedule {'gitblit-repos': }


}
