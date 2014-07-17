# == Define: windows_oradb::database
#
define windows_oradb::database ( # General
  $oracleHome     = undef,
  $oracleBase     = undef,
  $version        = undef,
  $installFolder  = undef,
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
  exec { "Create database ${title}":
    command   => "cmd.exe /c \"$oracleHome\\BIN\\dbca -silent -responseFile C:\\Install\\dbca_$title.rsp\"",
    path      => $::path,
    creates   => "$oracleBase/admin/$dbName",
    require   => [File["${installFolder}/dbca_${title}.rsp"],
                  File["${oracleHome}/assistants/dbca/templates/${templateName}"]],
    logoutput => true,
    timeout   => 0,
  }

}
