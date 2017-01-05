# profiles::pulp::httpd
#
# Required modules :
# - puppetlabs/apache
#
class profiles::pulp::httpd (

  $ca_cert = '/etc/pki/pulp/ca.crt',
  $https_cert = $ca_cert,
  $https_key = '/etc/pki/pulp/ca.key',
  $https_chain = undef,
  $ssl_protocol = 'all -SSLv2 -SSLv3',
  $additional_wsgi_scripts = {},
  $max_keep_alive = 10000,
  $ssl_username = false,

  ) {

  # Remove the pulp apache config from rpm
  file {'/etc/httpd/conf.d/pulp.conf':
    ensure => 'absent',
    notify => Service['httpd'],
  }

  apache::vhost { 'pulp-http':
    priority            => '05',
    docroot             => '/usr/share/pulp/wsgi',
    port                => 80,
    servername          => $::fqdn,
    serveraliases       => [$::hostname],
    additional_includes => '/etc/pulp/vhosts80/*.conf',
  }

  apache::vhost { 'pulp-https':
    priority                   => '05',
    docroot                    => '/usr/share/pulp/wsgi',
    port                       => 443,
    servername                 => $::fqdn,
    serveraliases              => [$::hostname],
    ssl                        => true,
    ssl_cert                   => $https_cert,
    ssl_key                    => $https_key,
    ssl_chain                  => $https_chain,
    ssl_ca                     => $ca_cert,
    ssl_verify_client          => 'optional',
    ssl_protocol               => $ssl_protocol,
    ssl_options                => '+StdEnvVars +ExportCertData',
    ssl_verify_depth           => '3',
    wsgi_process_group         => 'pulp',
    wsgi_application_group     => 'pulp',
    wsgi_daemon_process        => 'pulp user=apache group=apache processes=3 display-name=%{GROUP}',
    wsgi_pass_authorization    => 'On',
    wsgi_import_script         => '/usr/share/pulp/wsgi/webservices.wsgi',
    wsgi_import_script_options => {
      'process-group'     => 'pulp',
      'application-group' => 'pulp',
    },
    wsgi_script_aliases        => merge(
      {'/pulp/api'=>'/usr/share/pulp/wsgi/webservices.wsgi'},
      $additional_wsgi_scripts),
    directories                => [
      {
        'path'     => 'webservices.wsgi',
        'provider' => 'files',
      },
      {
        'path'     => '/usr/share/pulp/wsgi',
        'provider' => 'directory',
      },
      {
        'path'     => '/pulp/static',
        'provider' => 'location',
      },
    ],
    aliases                    => [{
        alias           => '/pulp/static',
        path            => '/var/lib/pulp/static',
        options         => ['Indexes'],
        custom_fragment => 'SSLRequireSSL'
      }
    ],
    options                    => ['SymLinksIfOwnerMatch'],
    add_default_charset        => 'UTF-8',
    custom_fragment            => template('profiles/pulp/httpd/ssl_vhost.conf.erb'),
  }

}
