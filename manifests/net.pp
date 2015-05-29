# == Class: windows_oradb::net
#
class windows_oradb::net (
  $net_hash,
  ) {
  create_resources('windows_oradb::defines::net', $net_hash)

}
