# == Class: windows_oradb::database
#
class windows_oradb::database (
  $database_hash,
  ){
  create_resources('windows_oradb::defines::database', $database_hash)
}
