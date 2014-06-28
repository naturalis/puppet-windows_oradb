# == Define: windows_oradb::database
#
define windows_oradb::database ( # General
                                 $oracleHome     = undef,
				 $version	 = undef,

                                 # Reponsefile
                                 $globalDbName   = undef,
                                 $dbName         = undef,
                                 $templateName   = undef,
                                 $sysPassword    = undef,
                                 $systemPassword = undef,
                               ) {

  if (!( $version == '11.2.0.3')){
    fail("Unrecognized database install version, use 11.2.0.3")
  }

# Create response file
  file { "${installFolder}/dbca_${title}.rsp":
    ensure  => present,
    content => template("windows_oradb/dbca_${version}.rsp.erb"),
  }

# Copy template file
  file { "${installFolder}/${templateName}":
    ensure => present,
    source => "puppet:///modules/windows_oradb/${templateName}",
  }

  exec { "Install database ${title}":
    command => "dbca.exe -silent -responseFile ${installFolder}\\dbca_${title}.rsp",
    path => '${oracleHome}/bin',
    #creates => $oracleHome,
    require => File["${installFolder}/dbca_${title}.rsp"],
  }

}
