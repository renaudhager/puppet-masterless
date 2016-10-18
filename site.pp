

Exec {
  path => '/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin:/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin',
}

# Regex on hostname to determine the role of the node
if empty( hiera( 'role', undef ) )
{
  case $::hostname {
    /compute-sl\d\d$/:    { $role = 'mesos-slave' }
    /compute-ma\d\d$/:    { $role = 'mesos-master' }
    /util-nginx\d\d$/:    { $role = 'nginx' }
    /util-puppetdb\d\d$/: { $role = 'puppetdb' }
    default:              { $role = undef }
  }
}
else {
  $role = hiera( 'role' )
}

# Assign DC
# if eth0 is 10.0.2.15 DC => vgt
# else use the regexp
if empty( hiera( 'datacenter', undef ) )
{
  if $::ipaddress_eth0 == '10.0.2.15' {
    $datacenter = 'vgt'
  }
  else {
    # Split hostname to find DC
    $hostname_infos = split( $::hostname, '-' )
    case $hostname_infos[0] {
      'ew1':   { $datacenter = 'ew1' }
      default: { $datacenter = undef }
    }
  }
}
else {
  $datacenter = hiera( 'datacenter' )
}


node default {
  hiera_hash('include')['classes'].each |$c| { if $c !~ /^--/ and ! defined( Class[$c] ) { include $c } }
}
