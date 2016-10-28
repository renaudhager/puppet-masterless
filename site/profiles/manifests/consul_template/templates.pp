# profiles::consul_template::templates
#
# This class manage template consul template agent.
#

class profiles::consul_template::templates (
  Hash $instances = {},
  ) {

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

      if has_key($instance, 'template_src') {
        $template_src = $instance['template_src']
      }
      else {
        $template_src = '/etc/consul-template/templates'
      }

      if has_key($instance, 'template_dst') {
        $template_dst = $instance['template_dst']
      }
      else {
        $template_dst = '/etc/nginx/sites-enabled'
      }

      # Create init file
      file { "/etc/init/consul-template-${name}.conf":
        ensure  => 'present',
        owner   => $user,
        group   => $group,
        mode    => '0644',
        content => template( 'profiles/consul_template/templates/init.erb' ),
        notify  => Service["consul-template-${name}"]
      }

      # Create service
      service { "consul-template-${name}":
        ensure   => running,
        enable   => true,
        provider => 'upstart',
        require  => File["/etc/init/consul-template-${name}.conf"],
      }

      # Create template directory and files
      file { $template_src:
        ensure => 'directory',
        owner  => $user,
        group  => $user,
        mode   => '0755',
      }

      file { "${template_src}/${name}.ctmpl":
        ensure  => 'present',
        owner   => $user,
        group   => $user,
        mode    => '0644',
        content => $instance['content'],
        require => File[$template_src],
        notify  => Service["consul-template-${name}"],
      }


    }

}
