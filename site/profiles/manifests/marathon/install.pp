# profiles::marathon::install
#
# Install java prerequisite for marathon
# before installing marathon
#
# Required modules:
# - meltwater/marathon
#
class profiles::marathon::install (
) {

  # Fix waiting I setup a personal repo
  exec { 'install_java8':
    command => 'curl -s -k -O https://cloud.renorains.net/extra/java8-runtime-headless_8u101_amd64.deb && dpkg -i java8-runtime-headless_8u101_amd64.deb',
    unless  => 'dpkg -l | grep java8-runtime-headless'
  }

  exec { 'configure_java':
    command => 'update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk1.8.0_101/bin/java 1 && update-alternatives --set java /usr/lib/jvm/jdk1.8.0_101/bin/java',
    unless  => 'java -version  2>&1| grep 1.8.0_101',
    require => Exec['install_java8'],
  }

  class { '::marathon':
    package_ensure => 'present',
    manage_repo    => false,
    install_java   => false,
    extra_options  => '--task_launch_timeout 600000',
    require        => Exec['configure_java'],
  }
}
