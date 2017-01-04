# profiles::system::nfs_exports
#
# Required modules :
# - derdanne/nfs
#
class profiles::system::nfs_exports (
) {
  # DeepMerge bug, we have to set this here
  $exports = hiera_hash( 'profiles::system::nfs_exports::exports', {} )
  validate_hash( $exports )

  create_resources( nfs::server::export, $exports )
}
