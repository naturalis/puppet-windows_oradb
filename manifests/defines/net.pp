# == Define: windows_oradb::defines::net
#
define windows_oradb::defines::net (

# General
  $oracleHome    = undef,
  $oracleBase    = undef,
  $version       = undef,
  $installFolder = undef,

# Reponsefile
  #$listenerNumber   = undef,
  #$listenerNames    = undef,
  $installType       = undef,
  $listenerProtocols = undef,
  $nsnProtocol       = undef,
  $nsnPort           = undef,
  
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
    creates   => "$oracleHome/network/admin/listener.ora",
    require   => File["${installFolder}/netca_${title}.rsp"],
    logoutput => true,
    timeout   => 0,
  }
  
  notify {"Register listener in database: sqlplus> alter system set local_listener=${title} scope=both;":
    require => Exec["Install Oracle net ${title}"]
  }

}
