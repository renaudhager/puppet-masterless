# profiles::mongodb::dbs
#
# Create a DB
#
# Require module puppetlabs/mongodb
#
class profiles::mongodb::dbs (
  Hash $dbs = {}
) {

  validate_hash( $dbs )

  create_resources( profiles::mongodb::db, $dbs )

}
