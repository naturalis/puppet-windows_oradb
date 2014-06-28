# == Define: windows_oradb::database
#
define windows_oradb::database ( $oracleBase               = undef,
                                 $oracleHome               = undef,
                                 $version                  = "11.2",
                                 $user                     = 'oracle',
                                 $group                    = 'dba',
                                 $archiveFilename          = 'p10404530_112030_MSWIN-x86-64',
                                 $installDir               = 'c:\Install',
                                 $extractDir               = 'c:\Zipfiles',
                                 $action                   = 'create',
                                 $dbName                   = 'orcl',
                                 $dbDomain                 = undef,
                                 $sysPassword              = 'Welcome01',
                                 $systemPassword           = 'Welcome01',
                                 $dataFileDestination      = undef,
                                 $recoveryAreaDestination  = undef,
                                 $characterSet             = "AL32UTF8",
                                 $nationalCharacterSet     = "UTF8",
                                 $initParams               = undef,
                                 $sampleSchema             = TRUE,
                                 $memoryPercentage         = "40",
                                 $memoryTotal              = "800",
                                 $databaseType             = "MULTIPURPOSE",
                                 $emConfiguration          = "NONE", # CENTRAL|LOCAL|ALL|NONE
                                 $storageType              = "FS", #FS|CFS|ASM
                                 $recoveryDiskgroup        = undef,
                               ) {

  if (!( $version == "11.2")) {
  fail("Unrecognized version")
  }


  }
}
