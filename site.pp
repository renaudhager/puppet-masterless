

Exec {
  path => '/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin:/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin',
}

# Regex on hostname to determine the role of the node
if empty( hiera( 'role', undef ) )
{
  case $::hostname {
    /compute-sl\d\d$/:  { $role = 'mesos-slave' }
    /compute-ma\d\d$/:  { $role = 'mesos-master' }
    /util-puppetdb\d\d$/:  { $role = 'puppetdb' }
    default:            { $role = undef }
  }
}
else {
  $role = hiera( 'role' )
}

$datacenter = hiera( 'datacenter' )

node default {
  hiera_hash('include')['classes'].each |$c| { if $c !~ /^--/ and ! defined( Class[$c] ) { include $c } }
}
