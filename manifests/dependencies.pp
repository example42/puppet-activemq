# Class: activemq::dependencies
#
# This class includes resources provided by other Example42 modules
# It's automatically included by default in order to provide
# a correct module setup, but you might want to provide the same
# resources in a custom way, using other modules.
# If so set install_dependencies to false and be sure that what
# is placed here is managed by your modules/manifests.
#
# == Usage
#
# This class is not intended to be used directly.
#
class activemq::dependencies {

  # Provide the PuppetLabs yum repo for seamless activemq setup
  case $::operatingsystem {
    'centos','redhat','scientific': {
      require yum::repo::puppetlabs
    }
    /(?i:Debian|Ubuntu|Mint)/ : {
      require apt::repo::puppetlabs
    }
    default: {}
  }

  case $activemq::install {
    'source','puppi': {
      require java
    }
    default: {}
  }

}
