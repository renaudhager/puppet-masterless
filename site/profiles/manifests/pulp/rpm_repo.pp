# profiles::pulp::rpm_repo

define profiles::pulp::rpm_repo (
  $feed         = '',
  $relative_url = $name,
  $serve_http   = true,
  $options      = undef,
  $command      = '/bin/pulp-admin',
  $initial_sync = true
  ) {

  # Create the repo
  exec {"create_repo_${name}":
    command => "${command} rpm repo create --repo-id=${name} --relative-url=${relative_url} --serve-http=${serve_http} --feed=${feed} ${options}",
    unless  => "${command} repo list --repo-id=${name}",
  }

  # Check for an initial sync:
  if $initial_sync {
    exec {"initial_sync_repo_${name}":
      command => "${command} rpm repo sync run --bg --repo-id=${name}",
      unless  => "${command} repo list --repo-id=${name} | grep 'Rpm:'",
    }
  }

}
