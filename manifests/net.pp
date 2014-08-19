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
