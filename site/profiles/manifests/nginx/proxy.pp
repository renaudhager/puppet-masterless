# profiles::nginx::proxy
#
# This class manage consul template for nginx.
#

class profiles::nginx::proxy (
  Hash $templates      = {},
  String $template_dir = '/etc/nginx/templates/',
  ) {

    file { $template_dir:
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }

    $templates_default = {
      ensure => 'present',
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }

    create_resources( file, $templates, $templates_default )
}
