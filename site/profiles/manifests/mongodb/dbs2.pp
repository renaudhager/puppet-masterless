# profiles::mongodb::dbs
#
# Create a DB
#
# Require module puppetlabs/mongodb
#
class profiles::mongodb::dbs2 (
  Hash $dbs = {}
) {

  validate_hash( $dbs )

  create_resources( mongodb::db, $dbs )

}
