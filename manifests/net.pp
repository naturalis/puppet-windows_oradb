# == Define: windows_oradb::net
#
define windows_oradb::net (
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
  file { "${installFolder}/netca_${title}.rsp":
    ensure             => present,
    content            => template("windows_oradb/netca_${version}.rsp.erb"),
    source_permissions => ignore,
  }

# Execute netca command
  exec { "Install Oracle net ${title}":
    command   => "cmd.exe /c \"$oracleHome\\BIN\\netca -silent -responseFile C:\\Install\\netca_$title.rsp\"",
    path      => $::path,
    #creates   => "$oracleBase/admin/$dbName",
    require   => File["${installFolder}/netca_${title}.rsp"],
    logoutput => true,
    timeout   => 0,
  }

}
