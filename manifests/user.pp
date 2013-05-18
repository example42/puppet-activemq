# Class: activemq::user
#
# This class creates activemq user
#
# == Usage
#
# This class is not intended to be used directly.
# It's automatically included by activemq
#
class activemq::user inherits activemq {
  $user_before = $activemq::install ? {
    source  => [ Group[$activemq::process_user] , Puppi::Netinstall['netinstall_activemq'] ],
    puppi   => [ Group[$activemq::process_user] , Puppi::Project::Tar['activemq'] ],
    default => undef,
  }
  @user { $activemq::process_user :
    ensure     => $activemq::manage_file,
    comment    => "${activemq::process_user} user",
    password   => '!',
    managehome => false,
    home       => $activemq::activemq_dir,
    shell      => '/bin/bash',
    before     => $user_before ,
  }
  @group { $activemq::process_user :
    ensure     => $activemq::manage_file,
  }

  User <| title == $activemq::process_user |>
  Group <| title == $activemq::process_user |>

}
