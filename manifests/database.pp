# == Define: windows_oradb::database
#
define windows_oradb::database ( # General
                                 $oracleHome    = undef,
				                         $version	      = undef,
                                 $installFolder = undef,

                                 # Reponsefile
                                 $globalDbName   = undef,
                                 $dbName         = undef,
                                 $templateName   = undef,
                                 $sysPassword    = undef,
                                 $systemPassword = undef,
                               ) {

  notice($oracleHome)

  if (!( $version == '11.2.0.3')){
    fail("Unrecognized database install version, use 11.2.0.3")
  }

# Create response file
  file { "${installFolder}/dbca_${title}.rsp":
    ensure             => present,
    content            => template("windows_oradb/dbca_${version}.rsp.erb"),
    source_permissions => ignore,
  }

# Copy template file
  file { "${installFolder}/${templateName}":
    ensure             => present,
    source             => "puppet:///modules/windows_oradb/${templateName}",
    source_permissions => ignore,
  }

  exec { "Install database ${title}":
    command  => "C:/Oracle_Sys/nbcprod/product/11.2.0/db/BIN/dbca.bat -silent -responseFile C:\Install\\\dbca_${title}.rsp",
    #path     => '${oracleHome}/bin',
    #cwd      =>'${oracleHome}/bin',
    #creates => $oracleHome,
    require  => File["${installFolder}/dbca_${title}.rsp"],
  }

}
