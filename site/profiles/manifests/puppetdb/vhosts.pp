# profiles::puppetdb::vhosts
#
# This class vhost reverse proxy for puppetdb
#
# Required modules :
# - puppet/nginx
#

class profiles::puppetdb::vhosts (
  Hash $vhosts = {},
)  {

  validate_hash( $vhosts )

  create_resources( nginx::resource::vhost, $vhosts )

}
