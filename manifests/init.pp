# == Class: windows_oradb
#
# Full description of class windows_oradb here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { windows_oradb:
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class windows_oradb  (
  $installdb_hash = { 'dbhome_1' => { # General
                                      version        => '11.2.0.3',
                                      #archiveFilename => 'p10404530_112030_MSWIN-x86-64',
                                      installFolder  => 'C:/Install',
                                      zipfilesFolder => 'C:/Zipfiles',

                                      # Responsefile
                                      oracleHome   => 'C:\app\oracle\product\11.2.0\dbhome_1',
                                      oracleBase   => 'C:\app\oracle',
                                      databaseType => 'SE',
                                    },
                    },

  $database_hash  = { 'orcl' => { # General
                                  oracleHome     => 'C:\app\oracle\product\11.2.0\dbhome_1',
                                  oracleBase     => 'C:\app\oracle',
                                  version        => '11.2.0.3',
                                  installFolder  => 'C:/Install',

                                  # Reponsefile
                                  globalDbName   => 'orcl',
                                  dbName         => 'orcl',
                                  templateName   => 'General_Purpose.dbc',
                                  sysPassword    => 'tiger',
                                  systemPassword => 'tiger',
                                },
                     },

  $net_hash       = { 'orcl' => { # General
                                  oracleHome        => 'C:\app\oracle\product\11.2.0\dbhome_1',
                                  oracleBase        => 'C:\app\oracle',
                                  version           => '11.2.0.3',
                                  installFolder     => 'C:/Install',
                                             
                                  # Reponsefile
                                  installType       => 'custom', # "typical","minimal" or "custom", set to custom if using port other than 1521
                                  listenerProtocols => 'TCP;1521',
                                  nsnProtocol       => 'TCP',
                                  nsnPort           => '1521',
                                },
                    },
) {

  stage {'pre':
  }

  Stage['pre'] -> Stage['main']

  class {"windows_role_base":
    stage => 'pre',
  }
  
  class {"windows_oradb::installdb":
    installdb_hash => $installdb_hash,
  }

  class {"windows_oradb::database":
    database_hash => $database_hash,
    require       => Class['windows_oradb::installdb'],
  }

  class {"windows_oradb::net":
    net_hash => $net_hash,
    require  => Class['windows_oradb::database'],
  }

}
