# == Define: windows_oradb::installdb
#
define windows_oradb::installdb (

# General
  $version        = undef,

# Unzip
  $installFolder  = undef,
  $zipfilesFolder = undef,

# Responsefile
  $databaseType   = undef,
  $oracleBase     = undef,
  $oracleHome     = undef,
  ) {

  if (!( $version == '11.2.0.3')){
    fail("Unrecognized database install version, use 11.2.0.3")
  }

  notice($installFolder)
  notice($version)

  exec { "Extract zip file 1":
    command => "7z.exe x -y \"$zipfilesFolder\\p10404530_112030_MSWIN-x86-64_1of7.zip\"",
    path    => "C:/Program Files/7-Zip;${::path}",
    cwd     => $installFolder,
    creates => "$installFolder/database/setup.exe",
  }

  exec { "Extract zip file 2":
    command => "7z.exe x -y \"$zipfilesFolder\\p10404530_112030_MSWIN-x86-64_2of7.zip\"",
    path    => "C:/Program Files/7-Zip;${::path}",
    cwd     => $installFolder,
    creates => "$installFolder/database/stage/Components/oracle.ctx",
  }

  file { "${installFolder}/installdb_${title}.rsp":
    ensure  => present,
    content => template("windows_oradb/installdb_${version}.rsp.erb"),
  }

  exec { "Install ${title}":
    command => "setup.exe -silent -responseFile ${installFolder}\\installdb_${title}.rsp",
    path => 'C:/Install/database',
    creates => $oracleHome,
    require => File["${installFolder}/installdb_${title}.rsp"],
  }

}
