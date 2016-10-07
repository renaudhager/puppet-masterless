# profiles::puppetdb::vhosts
#
# This class vhost reverse proxy for puppetdb
#
# Required modules :
# - puppet/nginx
#

class profiles::puppetdb::vhosts (
  Hash $vhosts         = {},
  String $cert_content = 'undef',
  String $key_content  = 'undef',
)  {

  validate_hash( $vhosts )

  # File {
  #   mode   => '0600',
  #   owner  => 'root',
  #   group  => 'root',
  # }

  # if ( $cert_content != 'undef' ) and ( $key_content != 'undef' ){
  #   file { '/etc//ssl':
  #     ensure => 'directory',
  #     mode   => '0700',
  #     #require => Package['nginx'],
  #   }
  #
  #   file { '/etc/nginx/ssl/puppetdb.cert':
  #     content => $cert_content,
  #     require => File['/etc/nginx/ssl'],
  #   }
  #
  #   file { '/etc/nginx/ssl/puppetdb.key':
  #     content => $key_content,
  #     require => File['/etc/nginx/ssl'],
  #     #before  => Nginx::Resource::Vhost[$vhosts],
  #   }

    create_resources( nginx::resource::vhost, $vhosts )

    #File <||> -> Nginx::Resource::Vhost <| |>

  # }
  # else {
  #   failed('cert_content/key_content is needed.')
  # }

}
