# profiles::system::nfs_mounts
#
# Required modules :
# - derdanne/nfs
#
class profiles::system::nfs_mounts (
) {
  # DeepMerge bug, we have to set this here
  $mounts = hiera_hash( 'profiles::system::nfs_mounts::mounts', {} )
  validate_hash( $mounts )

  create_resources( nfs::client::mount, $mounts )
}
