# profiles::puppet::node
#
# This class vhost reverse proxy for puppetdb
#
# Required modules :
# - puppetlbas/inifile
#
# TODO : Make Unt tests
class profiles::puppet::node (
  String $puppetdb_url                 = 'https://puppetdb.service.consul:8081',
  String $puppetdb_url_timeout         = '5',
  String $puppetdb_conf_file           = '/etc/puppetlabs/puppet/puppetdb.conf',
  Boolean $puppetdb_soft_write_failure = true,
  Boolean $puppet_storeconfigs         = false,
  String $puppet_conf_file             = '/etc/puppetlabs/puppet/puppet.conf',
  String $puppet_storeconfigs_backend  = 'puppetdb',
  Boolean $puppet_report               = true,
  String $puppet_reports               = 'puppetdb',
  String $puppet_routes                = 'undef',
  String $puppet_pkg_version           = 'present',
  String $puppet_hiera_config          = '/etc/puppetlabs/code/hiera.yaml'

)  {

  package { 'puppet-agent':
    ensure => $puppet_pkg_version,
  }

  Ini_setting {
    require => Package['puppet-agent'],
  }

  if $puppet_routes != 'undef' {
    file { '/etc/puppetlabs/puppet/routes.yaml':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => $puppet_routes,
    }
  }

  # TODO: use a HASH
  # Setup puppetdb config file
  ini_setting { 'puppetdb_url':
    ensure  => present,
    path    => $puppetdb_conf_file,
    section => 'main',
    setting => 'server_urls',
    value   => $puppetdb_url,
  }

  ini_setting { 'server_url_timeout':
    ensure  => present,
    path    => $puppetdb_conf_file,
    section => 'main',
    setting => 'server_url_timeout',
    value   => $puppetdb_url_timeout,
  }

  ini_setting { 'puppetdb_soft_write_failure':
    ensure  => present,
    path    => $puppetdb_conf_file,
    section => 'main',
    setting => 'soft_write_failure',
    value   => $puppetdb_soft_write_failure,
  }

  # Setup puppet config
  ini_setting { 'puppet_storeconfigs':
    ensure  => present,
    path    => $puppet_conf_file,
    section => 'main',
    setting => 'storeconfigs',
    value   => $puppet_storeconfigs,
  }

  if  $puppet_storeconfigs {
    ini_setting { 'puppet_storeconfigs_backend':
      ensure  => present,
      path    => $puppet_conf_file,
      section => 'main',
      setting => 'storeconfigs_backend',
      value   => $puppet_storeconfigs_backend,
    }
  }

  ini_setting { 'puppet_report':
    ensure  => present,
    path    => $puppet_conf_file,
    section => 'main',
    setting => 'report',
    value   => $puppet_report,
  }

  ini_setting { 'puppet_reports':
    ensure  => present,
    path    => $puppet_conf_file,
    section => 'main',
    setting => 'reports',
    value   => $puppet_reports,
  }

  ini_setting { 'puppet_hiera_config':
    ensure  => present,
    path    => $puppet_conf_file,
    section => 'main',
    setting => 'hiera_config',
    value   => $puppet_hiera_config,
  }

}
