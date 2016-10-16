# profiles::system::ca_cert
#
# This class vaul CA Cert on all nodes.

# TODO : use a hash to be able to install several ca cert.

class profiles::system::ca_cert (
  String $ca_cert_file = 'profiles/system/ca_cert/vault_ca_cert.pem',
  String $ca_cert_file_path = '/usr/share/ca-certificates/vault_ca_cert.crt',
  ) {

  # file { '/usr/share/ca-certificates/extra':
  #   ensure => directory,
  #   owner  => 'root',
  #   group  => 'root',
  #   mode   => '0755',
  # }

  file{ $ca_cert_file_path:
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => file( $ca_cert_file ),
    #require => File['/usr/share/ca-certificates/extra'],
    notify  => Exec['update-ca'],
  }

  exec { 'update-ca':
    command     => "echo \"\$(basename ${ca_cert_file_path})\" >> /etc/ca-certificates.conf && /usr/sbin/update-ca-certificates",
    refreshonly => true,
  }

}
