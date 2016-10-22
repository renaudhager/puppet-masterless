# profiles::nginx::consul_template
#
# This class manage consul template for nginx.
#

class profiles::nginx::consul_template (
  Hash $instances = {},
  String $download_url = 'https://releases.hashicorp.com/consul-template/',
  String $version = '0.16.0',
  String $release = 'linux_amd64',
  ) {

    # Download binary
    exec { 'download_consul_template':
      command => "curl -o /tmp/consul-template_${version}_${$release}.zip https://releases.hashicorp.com/consul-template/${version}/consul-template_${version}_${$release}.zip",
      unless  => 'ls /usr/local/bin/consul-template',
      notify  => Exec['install_consul_template'],
    }

    # Install binary
    exec { 'install_consul_template':
      command => "unzip -d /usr/local/bin/ /tmp/consul-template_${version}_${$release}.zip",
      unless  => "ls /usr/local/bin/consul-template && /usr/local/bin/consul-template  -v 2>&1 | grep ${version}",
      require => Exec['download_consul_template'],
    }

    # Todo : create a resource for this.
    $instances.each |$name, $instance|{

      # Define default value for hash
      if has_key($instance, 'user') {
        $user = $instance['user']
      }
      else {
        $user = 'root'
      }

      if has_key($instance, 'group') {
        $group = $instance['group']
      }
      else {
        $group = 'root'
      }

      if has_key($instance, 'consul_url') {
        $consul_url = $instance['consul_url']
      }
      else {
        $consul_url = '127.0.0.1:8500'
      }

      #notify {"name is ${name} | template value is ${instance['template']} | user is ${user}":}

      # Create init file
      file { "/etc/init/consul-template-${name}.conf":
        ensure  => 'present',
        owner   => $user,
        group   => $group,
        mode    => '0644',
        content => template( 'profiles/nginx/consul_template/init.erb' ),
        notify  => Service["consul-template-${name}"]
      }

      # Create service
      service { "consul-template-${name}":
        ensure   => running,
        enable   => true,
        provider => 'upstart',
        require  => File["/etc/init/consul-template-${name}.conf"],
      }
    }

}
