# Class: activemq::skel
#
# This class creates additional activemq resources
#
# == Usage
#
# This class is not intended to be used directly.
# It's automatically included by activemq
#
class activemq::skel inherits activemq {

  file { '/etc/activemq':
    ensure  => directory,
    owner   => $activemq::process_user,
    group   => $activemq::process_group,
    audit   => $activemq::manage_audit,
  }
}
