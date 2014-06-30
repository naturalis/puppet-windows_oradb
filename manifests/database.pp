# == Define: windows_oradb::database
#
define windows_oradb::database ( # General
                                 $oracleHome     = undef,
                                 #oracleBase     = undef,
                                 $version = undef,
                                 $installFolder  = undef,

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

# Copy templatefile to templates directory
  file { "${oracleHome}/assistants/dbca/templates/${templateName}":
    ensure             => present,
    source             => "puppet:///modules/windows_oradb/${templateName}",
    source_permissions => ignore,
  }

# Execute dbca command
  exec { "Install database ${title}":
    command   => 'C:\Windows\System32\cmd.exe /c C:/Oracle_Sys/nbcprod/product/11.2/db/BIN/dbca -silent -responseFile C:/Install/dbca_nbcprod.rsp',
    #creates  => "$oracleBase/admin/$dbName",
    require   => [File["${installFolder}/dbca_${title}.rsp"],
                  File["${oracleHome}/assistants/dbca/templates/${templateName}"]],
    logoutput => true,
    timeout   => 0,
  }

}
