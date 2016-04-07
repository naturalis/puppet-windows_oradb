# == Define: windows_oradb::defines::database
#
define windows_oradb::defines::database ( 
  # General
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

  # If using custom templatefile, copy this file to templates directory
  if ("cmd.exe /c \"dir ${installFolder}\\$templateName\"") {
    file { "${oracleHome}/assistants/dbca/templates/${templateName}":
      ensure             => present,
      source             => "${installFolder}/${templateName}",
      source_permissions => ignore,
    }
  } 
  
  # Execute dbca command
  exec { "Create database ${title}":
    command   => "cmd.exe /c \"$oracleHome\\BIN\\dbca -silent -responseFile C:\\Install\\dbca_$title.rsp\"",
    path      => $::path,
    unless    => "cmd.exe /c \"dir $oracleBase\\admin\\$dbName\"",
    require   => [File["${installFolder}/dbca_${title}.rsp"],
                  File["${oracleHome}/assistants/dbca/templates/${templateName}"]],
    creates   => "$oracleBase/admin/$dbName",
    logoutput => true,
    timeout   => 0,
  }

}
