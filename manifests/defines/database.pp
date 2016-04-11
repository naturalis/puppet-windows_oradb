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
  $dbName,
  $templateName   = undef,
  $templateCustom = undef, # Copy your custom made templates to C:\Install folder
  $sysPassword    = undef,
  $systemPassword = undef,
  $totalMemory    = undef,
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

  if $templateCustom {
    # Copy custom templatefile to templates directory
    file { "${oracleHome}/assistants/dbca/templates/${templateCustom}":
      ensure             => present,
      source             => "${installFolder}/${templateCustom}",
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
