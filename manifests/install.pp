# Class: activemq::install
#
# This class installs activemq
#
# == Variables
#
# Refer to activemq class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It's automatically included by activemq
#
class activemq::install inherits activemq {

  case $activemq::install {

    package: {
      package { 'activemq':
        ensure => $activemq::manage_package,
        name   => $activemq::package,
      }
    }

    source: {

      # $created_file = url_parse($activemq::real_install_source,'filename')
      $created_file = "apache-activemq-${activemq::version}"
      if $activemq::bool_create_user == true {
        require activemq::user
      }
      include activemq::skel

      puppi::netinstall { 'netinstall_activemq':
        url                 => $activemq::real_install_source,
        destination_dir     => $activemq::install_destination,
        # extract_command     => 'tar -zxf',
        # preextract_command  => $activemq::install_precommand,
        extracted_dir       => $created_file,
        owner               => $activemq::process_user,
        group               => $activemq::process_user,
        before              => File ['activemq_link'],
      }

      file { 'activemq_link':
        ensure  => "${activemq::install_destination}/${created_file}" ,
        path    => "${activemq::install_destination}/activemq" ,
        require => Puppi::Netinstall['netinstall_activemq'],
      }

      file { 'activemq_service':
        ensure  => "${activemq::install_destination}/${created_file}/bin/activemq" ,
        path    => '/etc/init.d/activemq' ,
        require => Puppi::Netinstall['netinstall_activemq'],
      }
    }

    puppi: {

      if $activemq::bool_create_user == true {
        require activemq::user
      }
      include activemq::skel

      puppi::project::tar { 'activemq':
        source                   => $activemq::real_install_source,
        deploy_root              => $activemq::install_destination,
        report_email             => 'root',
        user                     => $activemq::process_user,
        auto_deploy              => true,
        check_deploy             => false,
        run_checks               => false,
        enable                   => true,
        before                   => File ['activemq_link'],
      }

      file { 'activemq_link':
        ensure  => "${activemq::install_destination}/${created_file}" ,
        path    => "${activemq::install_destination}/activemq" ,
        require => Puppi::Project::Tar['activemq'],
      }

      file { 'activemq_service':
        ensure  => "${activemq::install_destination}/${created_file}/bin/activemq" ,
        path    => '/etc/init.d/activemq' ,
        require => Puppi::Project::Tar['activemq'],
      }

    }

    default: { }

  }

}
