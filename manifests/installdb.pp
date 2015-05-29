# == Class: windows_oradb::installdb
#
class windows_oradb::installdb (
  $installdb_hash,
  ){
  create_resources('windows_oradb::defines::installdb', $installdb_hash)
}
